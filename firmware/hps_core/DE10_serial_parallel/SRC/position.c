/*
 * position.c Process pseudoranges and ephemeris into position
 * Copyright (C) 2005  Andrew Greenberg
 * Distributed under the GNU GENERAL PUBLIC LICENSE (GPL) Version 2 (June 1991).
 * See the "COPYING" file distributed with this software for more information.
 */

#include <math.h>
#include "position.h"
#include "constants.h"
#include "display.h"
#include "ephemeris.h"
#include "pseudorange.h"
#include "time.h"

/******************************************************************************
 * Globals
 ******************************************************************************/
unsigned short positioning;

pvt_t receiver_pvt;
pvt_t receiver_pvt_velocity;
llh_t receiver_llh;

azel_t sat_azel[N_CHANNELS];
xyzt_t sat_pos_by_ch[N_CHANNELS];
xyzt_t sat_pos_by_ch_old[N_CHANNELS];
vxyzt_t sat_vel_by_ch[N_CHANNELS];

satpos_t sat_position[N_CHANNELS];
double m_rho[N_CHANNELS];
double m_rho_dot[N_CHANNELS];

/******************************************************************************
 * Signal from pseudorange thread that there aren't enough satellites to be
 * calculating position. Clear things as necessary.
 ******************************************************************************/
void clear_position(void)
{
    positioning = 0;
}

/******************************************************************************
 * Translate ECEF to LLH coordinates.
 *
 * Based on equations found in Hoffman-Wellinhoff
 ******************************************************************************/
// Heiskanen-Moritz
llh_t ecef_to_llh(xyz_t pos)
{
    double p, n, thet, esq, epsq;
    double a2, b2, slat, clat, sth, sth3, cth, cth3; // Save some float math.
    llh_t result;

    a2 = WGS84_A * WGS84_A;
    b2 = WGS84_B * WGS84_B;

    p = sqrt(pos.x * pos.x + pos.y * pos.y);
    thet = atan(pos.z * WGS84_A / (p * WGS84_B));
    esq = 1.0 - b2 / a2;
    epsq = a2 / b2 - 1.0;

    sth = sin(thet);
    cth = cos(thet);

    sth3 = sth * sth * sth;
    cth3 = cth * cth * cth;

    result.lat = atan((pos.z + epsq * WGS84_B * sth3) / (p - esq * WGS84_A * cth3));
    result.lon = atan2(pos.y, pos.x);
    clat = cos(result.lat);
    slat = sin(result.lat);
    n = a2 / sqrt(a2 * clat * clat + b2 * slat * slat);
    result.hgt = p / clat - n;

    return (result);
}

/******************************************************************************
 * calculate_position
 * Given satellite locations and pseudorange measurements, return an estimated
 * receiver position based purely on the geometry and Earth's rotation rate.
 *
 * The initial estimated position comes from the (rec_pos_xyz) structure, the
 * pseduorange measurements from (m_rho), measured range,
 *
 * If the position cannot be determined, the position returned will be
 * <000>, the center of the Earth.
 *****************************************************************************/
pvt_t calculate_position(unsigned short nsats_used)
{
    pvt_t result;
    double x, y, z, b; /* Estimated receiver position and clock bias */
    double alpha;      /* Angle of Earth rotation during signal transit */
    double e_rho;      /* Estimated Range */

    unsigned short i, j, k; // indices

    // matrix declarations
    // (Is it smart to reserve N_CHANNELS when we need (nsats_used)?
    //  Since there's only one instance maybe these should be globals?)
    double delrho[N_CHANNELS]; // vector of per-sat. estimated range error
    double A[N_CHANNELS][3];   // linearized relation of position to pseudorange
    double inv[4][4];          // inverse of matrix (a[i,j] == Transpose[A].A)
    double delx[4];            // incremental position correction
    double a00, a01, a02, a03, // a[i,j], intermediate matrix for
                a11, a12, a13, // generalized inverse calculation.
                     a22, a23, // Only 10 elements due to symmetry.
                          a33; // Don't loop, so no indexing.
    double det;                // matrix determinate
    double dx, dy, dz;         // vector from receiver to satellite (delx)
    xyz_t satxyz[N_CHANNELS];  // sat position in ECEF at time of reception

    unsigned short nits = 0; // Number of ITerationS

    double error = 1000;         // residual calculation error
    unsigned short singular = 0; // flag for matrix inversion
    result.valid = 0;

    // b
    // [m] local estimate of clock bias, initially zero
    // Note, clock bias is defined so that:
    //     measured_time == true_time + clock_bias

    // make local copy of current position estimate (a speed optimization?)
    if(receiver_pvt.valid) {
        x = receiver_pvt.x;
        y = receiver_pvt.y;
        z = receiver_pvt.z;
        b = receiver_pvt.b;
    }
    else {
        x = 0;
        y = 0;
        z = 0;
        b = 0;
    }

    // The instantaneous origin of a satellite's transmission, though fixed
    // in inertial space, nevertheless varies with time in ECEF coordinates
    // due to Earth's rotation. Here we find the position of each satellite
    // in ECEF at the moment our receiver latched its signal.

    // The time-delay used here is based directly on the measured
    // time-difference. Perhaps some sort of filtering should be used.
    // If a variation of this calculation were included in the iteration,
    // more accuracy could be gained at some added computational expense.

    // Note that we may want to correct for the clock bias here, but
    // perhaps it's better if that's already folded into m_rho by
    // the time we get here.
    for (i = 0; i < nsats_used; i++)
    {
        // alpha is the angular rotation of the earth since the signal left
        // satellite[i]. [radians]
        alpha = m_rho[i] * OMEGA_E / SPEED_OF_LIGHT;

        // Compute the change in satellite position during signal propagation.
        // Exact relations:
        //   sa = sin( alpha);
        //   ca = cos( alpha);
        //   dx = (sat_position[i].x * ca - sat_position[i].y * sa) - x;
        //   dy = (sat_position[i].y * ca + sat_position[i].x * sa) - y;
        //   dz = sat_position[i].z - z;
        // Make the small angle approximation
        //   cos( alpha) ~= 1 and sin( alpha) ~= alpha.
        satxyz[i].x = sat_position[i].x + sat_position[i].y * alpha;
        satxyz[i].y = sat_position[i].y - sat_position[i].x * alpha;
        satxyz[i].z = sat_position[i].z;
    }

    /**************************************
     * Explanation of the iterative method:
     *
     * We make measurements of the time of flight of satellite signals to the
     * receiver (delta-t). From this we calculate a distance known as a pseudo-
     * range. The pseudorange differs from the true distance because of atmospheric
     * delay, receiver clock error, and other smaller effects. The error sources
     * other than clock error are dealt with elsewhere. The precise clock error can
     * only be found during this position calculation unless an external and very
     * accurate time source is used, or the carrier "integer ambiguity" can be
     * resolved. Since neither of the latter is usually the case, we solve for the
     * receiver "clock bias" as part of this position calculation. To be precise,
     * We define our pseudorange to be:
     *
     *   rho[i] == sqrt( (sx[i]-x)^2 + (sy[i]-y)^2 + (sz[i]-z)^2) + b
     *
     * Where (rho[i]) is the pseudorange to the ith satellite, (<sx,sy,sz>[i]) are
     * the ECEF (Earth Centered Earth Fixed) rectangular coordinates of the ith
     * satellite which are known from orbital calculations based on the local time
     * and ephemeris data, and (<xyz>) is the current estimate of the receiver
     * position in ECEF coordinates, (b)[meters] is the remaining clock-error
     * (bias) after performing all relevant corrections, and (^2) means to square
     * the quantity in parenthesis.
     *
     * By differentiation of (rho), a linear relation can be found between a change
     * in receiver position (delx), and the change in pseudorange (delrho).
     * Written as a matrix, this relation can be inverted and the receiver position
     * correction (delx) found.  Though approximate, the linearized process can
     * be iterated until a sufficiently accurate position is found.
     *
     * The linear relation in matrix form can be written:
     *
     *   delrho == A . delx
     *
     * Where (delrho) is a column vector representing the change in pseudoranges
     * resulting from a change in receiver position vector (delx), and (A) is
     * the matrix expressing the linear relation.
     *
     * To calculate a receiver position correction, first calculate the
     * pseudoranges based on the estimated receiver position and the known satellite
     * positions, call this (e_rho), and subtract this from the measured
     * pseudoranges:
     *
     *   delrho = m_rho - e_rho
     *
     * Knowing (delrho) and (A) the correction (delx) can be solved for, and
     * the corrected estimate of position can then be found:
     *
     *   (corrected-x) = (previous-x) + delx
     *
     * In the iterative method, (corrected-x) is used as the new value of the
     * estimated receiver position, and the whole correction process repeated.
     * Iteration is successful when the size of the correction is sufficiently small.
     *
     **************************************/
    // Iterate until an accurate solution is found
    // Use some locals to avoid re-computing terms.
    // The names somewhat indicate the terms contained.
    double  a01a33, a02a02, a12a23, a13a13a22,
            a03a03_a00a33, a02a12_a01a22, a02a13_a01a23, a12a13_a11a23;
    do
    { 
        for (i = 0; i < nsats_used; i++)
        {
            // Working in the ECEF (Earth Centered Earth Fixed) frame, find the
            // difference between the position of satellite[i] and the
            // receiver's estimated position at the time the signal was
            // received.
            dx = x - satxyz[i].x;
            dy = y - satxyz[i].y;
            dz = z - satxyz[i].z;

            e_rho = sqrt(dx * dx + dy * dy + dz * dz); // estimated range

            // range error == ( (estimated range) - (measured range) ).
            delrho[i] = m_rho[i] - e_rho - b;

            // Now find the relation (delrho = A . delx). The full relation
            // given above is
            //   rho == sqrt((sx - x)^2 + (sy - y)^2 + (sz - z)^2) + b
            //
            // Taking the derivative gets
            //
            //   delrho = (( dx(x - sx) + dy(y - sy) + dz(z - sz) ) / rho) + b
            //
            // Using the basis <dx,dy,dz,b> a row of the matrix (A) referred to
            // previously is
            //   A[i] = <dx/e_rho, dy/e_rho, dz/e_rho, 1>
            //
            // Where [i] refers to the ith satellite, and the matrix (A) has
            // size (n_sats_used x 4). In practice we store only the first
            // three elements of each row, the last element being always (1).
            A[i][0] = dx / e_rho;
            A[i][1] = dy / e_rho;
            A[i][2] = dz / e_rho;
        }

        // Compute the generalized inverse (GI) of (A) in three steps:

        // First:
        //   a00 a01 a02 a03   Form the square matrix:
        //       a11 a12 a13     a[i,j] == Transpose[A].A
        //           a22 a23  (Since this matrix is symmetric,
        //               a33   compute only the upper triangle.)
        //
        // Initialize with values from the first satellite
        a03 = A[0][0];
        a13 = A[0][1];
        a23 = A[0][2];
        a33 = nsats_used; // This is actually the final value
        a00 = a03 * a03;
        a01 = a03 * a13;
        a02 = a03 * a23;
        a11 = a13 * a13;
        a12 = a13 * a23;
        a22 = a23 * a23;

        // fill in the data from the remaining satellites
        for (i = 1; i < nsats_used; i++)
        {
            a00 += A[i][0] * A[i][0];
            a01 += A[i][0] * A[i][1];
            a02 += A[i][0] * A[i][2];
            a03 += A[i][0];
            a11 += A[i][1] * A[i][1];
            a12 += A[i][1] * A[i][2];
            a13 += A[i][1];
            a22 += A[i][2] * A[i][2];
            a23 += A[i][2];
        }

        // Second:
        // Solve for the inverse of the square matrix
        // The inverse is also symmetric, so again find only the upper triangle.
        //
        // The algorithm used is supposed to be efficient. It's rather hard
        // to derive, but fairly easy to show correct. It has been checked
        // and appears correct.
        // It uses some temporary variables, some of which could be re-used in
        // place it the optimizer is smart enough.

        inv[0][0] = a12 * a13;
        a12a13_a11a23 = inv[0][0] - a11 * a23; // done
        inv[0][0] = a23 * (inv[0][0] + a12a13_a11a23);
        inv[2][2] = a01 * a03;
        inv[1][2] = inv[2][2] - a00 * a13;
        inv[1][3] = a22 * inv[1][2];
        inv[2][2] += inv[1][2];
        inv[1][2] *= -a23;
        inv[2][2] *= a13;
        det = a01 * a12;
        a02a13_a01a23 = a02 * a13;
        inv[0][1] = a03 * a12;
        inv[1][3] += a02 * (a02a13_a01a23 - a03 * a12) -
                     a23 * (a01 * a02 - a00 * a12); // done
        a02a13_a01a23 -= a01 * a23;                 // done
        inv[0][1] += a02a13_a01a23;
        inv[2][3] = inv[0][1];
        inv[0][1] *= -a23;
        inv[2][3] *= -a01;
        inv[0][2] = a02 * a11 - det;
        det = a02 * (det - inv[0][2]);
        inv[3][3] = a02 * a12;
        a02a12_a01a22 = -a01 * a22;
        det += a01 * a02a12_a01a22;
        det *= a33;
        a02a12_a01a22 += inv[3][3]; // done
        inv[3][3] += a02a12_a01a22;
        inv[3][3] *= a01;
        a13a13a22 = a13 * a22;
        inv[0][1] += a03 * a13a13a22 + a33 * a02a12_a01a22;
        a12a23 = a12 * a23;
        det -= (a03 + a03) * (a02 * a12a13_a11a23 -
                              a01 * (a13a13a22 - a12a23));
        a13a13a22 *= a13; // done
        a03a03_a00a33 = a03 * a03;
        inv[0][3] = a12 * a12;
        det -= a00 * (a13a13a22 - (a13 + a13) * a12a23 +
                      inv[0][3] * a33 + a11 * (a23 * a23 - a22 * a33));
        inv[0][3] -= a11 * a22;
        inv[0][0] -= a13a13a22 + a33 * inv[0][3]; // done
        inv[3][3] -= a00 * inv[0][3];
        det += a03a03_a00a33 * inv[0][3] +
               a02a13_a01a23 * a02a13_a01a23; // done
        inv[0][3] *= a03;
        inv[0][3] += a23 * inv[0][2] - a13 * a02a12_a01a22; // done
        inv[0][2] *= -a33;
        inv[0][2] += a13 * a02a13_a01a23 - a03 * a12a13_a11a23; // done
        a03a03_a00a33 -= a00 * a33;                             // done
        inv[1][1] = a02 * a03;
        inv[2][3] += a11 * inv[1][1] + a00 * a12a13_a11a23; // done
        inv[1][1] += inv[1][1];
        inv[1][1] = a23 * (inv[1][1] - a00 * a23) -
                    a22 * a03a03_a00a33;
        a02a02 = a02 * a02;
        inv[1][1] -= a33 * a02a02; // done
        inv[3][3] -= a11 * a02a02; // done
        a01a33 = a01 * a33;
        inv[1][2] += a12 * a03a03_a00a33 -
                     a02 * (a03 * a13 - a01a33);         // done
        inv[2][2] -= a11 * a03a03_a00a33 + a01 * a01a33; // done
        // 66 multiplies.

        if (det <= 0) // det ought not be less than zero because the matrix
                      // (Transpose[A].A) is the square of a real matrix,
                      // therefore its determinate is the square of a real number.
                      // If det is negative it means the numeric errors are large.
        {
            singular = 1;
            break;
        }
        else
        {
            // Third and final step, (generalized inverse) = (inv.Transpose[A])
            // go ahead and multiply (GI).delrho => (delx)
            // Note that (inv[]) as calculated is actually the matrix of
            // cofactors, so we divide by the determinate (det).

            // Copy over the symmetric elements if (inv[]) this should improve
            // the overall speed of the loop, we're guessing.
            inv[1][0] = inv[0][1];
            inv[2][0] = inv[0][2];
            inv[2][1] = inv[1][2];
            inv[3][0] = inv[0][3];
            inv[3][1] = inv[1][3];
            inv[3][2] = inv[2][3];

            for (i = 0; i < 4; i++) // Over (delx) & rows of (inv[])
            {
                double acc; // accumulator
                delx[i] = 0;

                for (j = 0; j < nsats_used; j++) // (delrho) & columns of (A)
                {
                    acc = 0;
                    for (k = 0; k < 3; k++) // rows of (A) & columns of (inv[])
                        acc += A[j][k] * inv[i][k];
                    acc += inv[i][3]; // Last column of (A) always = 1
                    delx[i] += acc * delrho[j];
                }
                delx[i] /= det;
            }

            nits++; // bump number of iterations counter

            x += delx[0]; // correction to position estimates
            y += delx[1];
            z += delx[2];
            b += delx[3]; // correction to time bias

            error =
                sqrt(delx[0] * delx[0] + delx[1] * delx[1] + delx[2] * delx[2] + delx[3] * delx[3]);
        }
    } while ((error > 1.e-8) && (nits < 10) && (error < 1.e8));
    // TODO, justify these numbers.

    // FIXME WHOAH Nelly, errors can creep out of that while loop, let's catch
    // them here and stop them from affecting the clock bias. If the solution
    // doens't converge to less than 100 meters, toss it.
    if (!singular && (error < 10))
        result.valid = 1;
    else
        result.valid = 0;
    result.x = x;
    result.y = y;
    result.z = z;
    result.b = b;
    result.n = nsats_used;
    result.error = error;

    return (result);
}

/*
 * calculate_velocity()
 */
pvt_t calculate_velocity( unsigned short nsats_used)
{
    pvt_t result;
    double x, y, z, b;  // estimated receiver position and clock bias
    double alpha;       // Angle of Earth rotation during signal transit
    double e_rho;       // Estimated Range

    unsigned short i, j, k; // indices

    // matrix declarations
    // (Is it smart to reserve N_CHANNELS when we need (nsats_used)?
    //  Since there's only one instance maybe these should be globals?)
    double delrho[N_CHANNELS]; // vector of per-sat. estimated range error
    double A[N_CHANNELS][3];   // linearized relation of position to pseudorange
    double inv[4][4];          // inverse of matrix (a[i,j] == Transpose[A].A)
    double delx[4];            // incremental position correction
    double  a00, a01, a02, a03,  // a[i,j], intermediate matrix for
                 a11, a12, a13,  // generalized inverse calculation.
                      a22, a23,  // Only 10 elements due to symmetry.
                           a33;  // Don't loop, so no indexing.
    double det; // matrix determinate
    double dx, dy, dz;          // vector from receiver to satellite (delx)
    xyz_t	satxyz[N_CHANNELS];
    vxyz_t  satvxyz[N_CHANNELS];  // sat position in ECEF at time of reception

    unsigned short nits = 0;    // Number of ITerationS

    double         error = 1000;        // residual calculation error
    unsigned short singular = 0;        // flag for matrix inversion
    result.valid = 0;

    // [m] local estimate of clock bias, initially zero
    // Note, clock bias is defined so that:
    //     measured_time == true_time + clock_bias

    // make local copy of current position estimate (a speed optimization?)
    if(receiver_pvt_velocity.valid) {
        x = receiver_pvt_velocity.vx;
        y = receiver_pvt_velocity.vy;
        z = receiver_pvt_velocity.vz;
        b = receiver_pvt_velocity.df;
    }
    else {
        x = 0;
        y = 0;
        z = 0;
        b = 0.0;
    }

    for( i = 0; i < nsats_used; i++)
    {
        // The instantaneous origin of a satellite's transmission, though fixed
        // in inertial space, nevertheless varies with time in ECEF coordinates
        // due to Earth's rotation. Here we find the position of each satellite
        // in ECEF at the moment our receiver latched its signal.

        // The time-delay used here is based directly on the measured
        // time-difference. Perhaps some sort of filtering should be used.
        // If a variation of this calculation were included in the iteration,
        // more accuracy could be gained at some added computational expense.

        // Note that we may want to correct for the clock bias here, but
        // perhaps it's better if that's already folded into m_rho by
        // the time we get here.

        // alpha is the angular rotation of the earth since the signal left
        // satellite[i]. [radians]
        alpha = m_rho[i] * OMEGA_E / SPEED_OF_LIGHT;

        // Compute the change in satellite position during signal propagation.
        // Exact relations:
        //   sa = sin( alpha);
        //   ca = cos( alpha);
        //   dx = (sat_position[i].x * ca - sat_position[i].y * sa) - x;
        //   dy = (sat_position[i].y * ca + sat_position[i].x * sa) - y;
        //   dz = sat_position[i].z - z;
        // Make the small angle approximation
        //   cos( alpha) ~= 1 and sin( alpha) ~= alpha.

        satxyz[i].x = sat_position[i].x + sat_position[i].y * alpha;
        satxyz[i].y = sat_position[i].y - sat_position[i].x * alpha;
        satxyz[i].z = sat_position[i].z;

        satvxyz[i].x = sat_position[i].vx;
        satvxyz[i].y = sat_position[i].vy;
        satvxyz[i].z = sat_position[i].vz;
        // TODO, check the error in this approximation.
    }


/**************************************
 * Explanation of the iterative method:
 *
 * We make measurements of the time of flight of satellite signals to the
 * receiver (delta-t). From this we calculate a distance known as a pseudo-
 * range. The pseudorange differs from the true distance because of atmospheric
 * delay, receiver clock error, and other smaller effects. The error sources
 * other than clock error are dealt with elsewhere. The precise clock error can
 * only be found during this position calculation unless an external and very
 * accurate time source is used, or the carrier "integer ambiguity" can be
 * resolved. Since neither of the latter is usually the case, we solve for the
 * receiver "clock bias" as part of this position calculation. To be precise,
 * We define our pseudorange to be:
 *
 *   rho[i] == sqrt( (sx[i]-x)^2 + (sy[i]-y)^2 + (sz[i]-z)^2) + b
 *
 * Where (rho[i]) is the pseudorange to the ith satellite, (<sx,sy,sz>[i]) are
 * the ECEF (Earth Centered Earth Fixed) rectangular coordinates of the ith
 * satellite which are known from orbital calculations based on the local time
 * and ephemeris data, and (<xyz>) is the current estimate of the receiver
 * position in ECEF coordinates, (b)[meters] is the remaining clock-error
 * (bias) after performing all relevant corrections, and (^2) means to square
 * the quantity in parenthesis.
 *
 * By differentiation of (rho), a linear relation can be found between a change
 * in receiver position (delx), and the change in pseudorange (delrho).
 * Written as a matrix, this relation can be inverted and the receiver position
 * correction (delx) found.  Though approximate, the linearized process can
 * be iterated until a sufficiently accurate position is found.
 *
 * The linear relation in matrix form can be written:
 *
 *   delrho == A . delx
 *
 * Where (delrho) is a column vector representing the change in pseudoranges
 * resulting from a change in receiver position vector (delx), and (A) is
 * the matrix expressing the linear relation.
 *
 * To calculate a receiver position correction, first calculate the
 * pseudoranges based on the estimated receiver position and the known satellite
 * positions, call this (e_rho), and subtract this from the measured
 * pseudoranges:
 *
 *   delrho = m_rho - e_rho
 *
 * Knowing (delrho) and (A) the correction (delx) can be solved for, and
 * the corrected estimate of position can then be found:
 *
 *   (corrected-x) = (previous-x) + delx
 *
 * In the iterative method, (corrected-x) is used as the new value of the
 * estimated receiver position, and the whole correction process repeated.
 * Iteration is successful when the size of the correction is sufficiently small.
 *
 **************************************/
    // Iterate until an accurate solution is found
    // Use some locals to avoid re-computing terms.
    // The names somewhat indicate the terms contained.
    double a01a33, a02a02, a12a23, a13a13a22,
        a03a03_a00a33, a02a12_a01a22, a02a13_a01a23, a12a13_a11a23;
    do
    {
        for( i = 0; i < nsats_used; i++)
        {
            // Working in the ECEF (Earth Centered Earth Fixed) frame, find the
            // difference between the position of satellite[i] and the
            // receiver's estimated position at the time the signal was
            // received.
            dx = x - satvxyz[i].x;
            dy = y - satvxyz[i].y;
            dz = z - satvxyz[i].z;

            double rx = satxyz[i].x - receiver_pvt.x;
            double ry = satxyz[i].y - receiver_pvt.y;
            double rz = satxyz[i].z - receiver_pvt.z;

            double range = sqrt( rx*rx + ry*ry + rz*rz);

            e_rho = (dx * (receiver_pvt.x - satxyz[i].x) + dy * (receiver_pvt.y - satxyz[i].y) + dz * (receiver_pvt.z - satxyz[i].z)) / (range);

            // range error == ( (estimated range) - (measured range) ).
            delrho[i] = m_rho_dot[i] - e_rho - b;

            // Now find the relation (delrho = A . delx). The full relation
            // given above is
            //   rho == sqrt((sx - x)^2 + (sy - y)^2 + (sz - z)^2) + b
            //
            // Taking the derivative gets
            //
            //   delrho = (( dx(x - sx) + dy(y -sy) + dz(z - sz) ) / rho) + b
            //
            // Using the basis <dx,dy,dz,b> a row of the matrix (A) referred to
            // previously is
            //   A[i] = <dx/e_rho, dy/e_rho, dz/e_rho, 1>
            //
            // Where [i] refers to the ith satellite, and the matrix (A) has
            // size (n_sats_used x 4). In practice we store only the first
            // three elements of each row, the last element being always (1).
            A[i][0] = (receiver_pvt.x - satxyz[i].x) / range;
            A[i][1] = (receiver_pvt.y - satxyz[i].y) / range;
            A[i][2] = (receiver_pvt.z - satxyz[i].z) / range;
        }

        // Compute the generalized inverse (GI) of (A) in three steps:

        // First:
        //   a00 a01 a02 a03   Form the square matrix:
        //       a11 a12 a13     a[i,j] == Transpose[A].A
        //           a22 a23  (Since this matrix is symmetric,
        //               a33   compute only the upper triangle.)
        //
        // Initialize with values from the first satellite
        a03 = A[0][0];
        a13 = A[0][1];
        a23 = A[0][2];
        a33 = nsats_used; // This is actually the final value
        a00 = a03 * a03;
        a01 = a03 * a13;
        a02 = a03 * a23;
        a11 = a13 * a13;
        a12 = a13 * a23;
        a22 = a23 * a23;

        // fill in the data from the remaining satellites
        for( i=1; i < nsats_used; i++)
        {
            a00 += A[i][0] * A[i][0];
            a01 += A[i][0] * A[i][1];
            a02 += A[i][0] * A[i][2];
            a03 += A[i][0];
            a11 += A[i][1] * A[i][1];
            a12 += A[i][1] * A[i][2];
            a13 += A[i][1];
            a22 += A[i][2] * A[i][2];
            a23 += A[i][2];
        }

        // Second:
        // Solve for the inverse of the square matrix
        // The inverse is also symmetric, so again find only the upper triangle.
        //
        // The algorithm used is supposed to be efficient. It's rather hard
        // to derive, but fairly easy to show correct. It has been checked
        // and appears correct.
        // It uses some temporary variables, some of which could be re-used in
        // place it the optimizer is smart enough.

        inv[0][0]      = a12 * a13;
        a12a13_a11a23  = inv[0][0] - a11 * a23; // done
        inv[0][0]      = a23 * (inv[0][0] + a12a13_a11a23);
        inv[2][2]      = a01 * a03;
        inv[1][2]      = inv[2][2] - a00 * a13;
        inv[1][3]      = a22 * inv[1][2];
        inv[2][2]     += inv[1][2];
        inv[1][2]     *= -a23;
        inv[2][2]     *=  a13;
         det           = a01 * a12;
        a02a13_a01a23  = a02 * a13;
        inv[0][1]      = a03 * a12;
        inv[1][3]     += a02 * (a02a13_a01a23 - a03 * a12) -
                          a23 * (a01 * a02 - a00 * a12); // done
        a02a13_a01a23 -= a01 * a23; // done
        inv[0][1]     += a02a13_a01a23;
        inv[2][3]      = inv[0][1];
        inv[0][1]     *= -a23;
        inv[2][3]     *= -a01;
        inv[0][2]      = a02 * a11 - det;
         det           = a02 * (det - inv[0][2]);
        inv[3][3]      = a02 * a12;
        a02a12_a01a22  = - a01 * a22;
         det          += a01 * a02a12_a01a22;
         det          *= a33;
        a02a12_a01a22 += inv[3][3]; // done
        inv[3][3]     += a02a12_a01a22;
        inv[3][3]     *= a01;
        a13a13a22      = a13 * a22;
        inv[0][1]     += a03 * a13a13a22 + a33 * a02a12_a01a22;
        a12a23         = a12 * a23;
         det          -= (a03 + a03) * (a02 * a12a13_a11a23 -
                            a01 * (a13a13a22 - a12a23));
        a13a13a22     *= a13; // done
        a03a03_a00a33  = a03 * a03;
        inv[0][3]      = a12 * a12;
         det          -= a00 * (a13a13a22 - (a13 + a13) * a12a23 +
                          inv[0][3] * a33 + a11 * (a23 * a23 - a22 * a33));
        inv[0][3]     -= a11 * a22;
        inv[0][0]     -= a13a13a22 + a33 * inv[0][3]; // done
        inv[3][3]     -= a00 * inv[0][3];
         det          += a03a03_a00a33 * inv[0][3] +
                            a02a13_a01a23 * a02a13_a01a23; // done
        inv[0][3]     *= a03;
        inv[0][3]     += a23 * inv[0][2] - a13 * a02a12_a01a22; // done
        inv[0][2]     *= -a33;
        inv[0][2]     += a13 * a02a13_a01a23 - a03 * a12a13_a11a23; // done
        a03a03_a00a33 -= a00 * a33; // done
        inv[1][1]      = a02 * a03;
        inv[2][3]     += a11 * inv[1][1] + a00 * a12a13_a11a23; // done
        inv[1][1]     += inv[1][1];
        inv[1][1]      = a23 * (inv[1][1] - a00 * a23) -
                           a22 * a03a03_a00a33;
        a02a02         = a02 * a02;
        inv[1][1]     -= a33 * a02a02; // done
        inv[3][3]     -= a11 * a02a02; //done
        a01a33         = a01 * a33;
        inv[1][2]     += a12 * a03a03_a00a33 -
                           a02 * (a03 * a13 - a01a33); // done
        inv[2][2]     -= a11 * a03a03_a00a33 + a01 * a01a33; // done
        // 66 multiplies.

        if( det <= 0) // det ought not be less than zero because the matrix
                     // (Transpose[A].A) is the square of a real matrix,
                    // therefore its determinate is the square of a real number.
                   // If det is negative it means the numeric errors are large.
        {
            singular = 1;
            break;
        }
        else
        {
            // Third and final step, (generalized inverse) = (inv.Transpose[A])
            // go ahead and multiply (GI).delrho => (delx)
            // Note that (inv[]) as calculated is actually the matrix of
            // cofactors, so we divide by the determinate (det).

            // Copy over the symmetric elements if (inv[]) this should improve
            // the overall speed of the loop, we're guessing.
            inv[1][0] = inv[0][1];
            inv[2][0] = inv[0][2]; inv[2][1] = inv[1][2];
            inv[3][0] = inv[0][3]; inv[3][1] = inv[1][3]; inv[3][2] = inv[2][3];

            for( i = 0; i < 4; i++) // Over (delx) & rows of (inv[])
            {
                double acc;   // accumulator
                delx[i] = 0;

                for( j = 0; j < nsats_used; j++) // (delrho) & columns of (A)
                {
                    acc = 0;
                    for( k = 0; k < 3; k++) // rows of (A) & columns of (inv[])
                        acc += A[j][k] * inv[i][k];
                    acc += inv[i][3]; // Last column of (A) always = 1
                    delx[i] += acc * delrho[j];
                }
                delx[i] /= det;
            }


            nits++;     // bump number of iterations counter

            x += delx[0]; // correction to position estimates
            y += delx[1];
            z += delx[2];
            b += delx[3]; // correction to time bias

            error =
                sqrt( delx[0]*delx[0] + delx[1]*delx[1] + delx[2]*delx[2] + delx[3]*delx[3]);
        }
    }
    while( (error > 1.e-8) && (nits < 10) && (error < 1.e8));
    // TODO, justify these numbers.

    // FIXME WHOAH Nelly, errors can creep out of that while loop, let's catch
    // them here and stop them from affecting the clock bias. If the solution
    // doens't converge to less than 100 meters, toss it.
    if( !singular && (error < 10))
        result.valid = 1;
    else
        result.valid = 0;
    result.vx = x;
    result.vy = y;
    result.vz = z;
    result.df = b;
    result.n = nsats_used;
    result.error = error;

    return ( result);
}

/******************************************************************************
 * Calculate a az/el for each satellite given a reference position
 * (Reference taken from "here.h".)
 ******************************************************************************/
azel_t satellite_azel(xyzt_t satpos)
{
    double xls, yls, zls, tdot, satang, xaz, yaz, az;
    azel_t result;

// What are these?
#define north_x 0.385002966431406
#define north_y 0.60143634005935
#define north_z 0.70003360254707
#define east_x 0.842218174688889
#define east_y -0.539136852963804
#define east_z 0
#define up_x -0.377413913446142
#define up_y -0.589581022958081
#define up_z 0.71410990421991

    // DETERMINE IF A CLEAR LINE OF SIGHT EXISTS
    xls = satpos.x;
    yls = satpos.y;
    zls = satpos.z;

    tdot = (up_x * xls + up_y * yls + up_z * zls) /
           sqrt(xls * xls + yls * yls + zls * zls);

    if (tdot >= 1.0)
        satang = PI_OVER_2;
    else if (tdot <= -1.0)
        satang = -PI_OVER_2;
    else
        satang = asin(tdot);

    xaz = east_x * xls + east_y * yls;
    yaz = north_x * xls + north_y * yls + north_z * zls;

    if (xaz != 0.0 || yaz != 0.0)
    {
        az = atan2(xaz, yaz);
        if (az < 0)
            az += TWO_PI;
    }
    else
        az = 0.0;

    result.el = satang;
    result.az = az;

    return (result);
}

/*******************************************************************************
FUNCTION SatPosEphemeris(double t, unsigned short n)
RETURNS  eceft

INPUT   t  double   coarse time of week in seconds
        n  char     satellite prn

PURPOSE

     THIS SUBROUTINE CALCULATES THE SATELLITE POSITION
     BASED ON BROADCAST EPHEMERIS DATA

     R    - RADIUS OF SATELLITE AT TIME T
     Crc  - RADIUS COSINE CORRECTION TERM
     Crs  - RADIUS SINE   CORRECTION TERM
     SLAT - SATELLITE LATITUDE
     SLONG- SATELLITE LONGITUDE
     TOE  - TIME OF EPHEMERIS FROM START OF WEEKLY EPOCH
     ETY  - ORBITAL INITIAL ECCENTRICITY
     TOA  - TIME OF APPLICABILITY FROM START OF WEEKLY EPOCH
     INC  - ORBITAL INCLINATION
     IDOT - RATE OF INCLINATION ANGLE
     CUC  - ARGUMENT OF LATITUDE COSINE CORRECTION TERM
     CUS  - ARGUMENT OF LATITUDE SINE   CORRECTION TERM
     CIC  - INCLINATION COSINE CORRECTION TERM
     CIS  - INCLINATION SINE   CORRECTION TERM
     RRA  - RATE OF RIGHT ASCENSION
     SQA  - SQUARE ROOT OF SEMIMAJOR AXIS
     LAN  - LONGITUDE OF NODE AT WEEKLY EPOCH
     AOP  - ARGUMENT OF PERIGEE
     MA   - MEAN ANOMALY AT TOA
     -> MA IS THE ANGLE FROM PERIGEE AT TOA
     DN   - MEAN MOTION DIFFERENCE

*******************************************************************************/

satinfo_t SatPosEphemeris(unsigned short ch)
{
    satinfo_t result;

    unsigned short i;

    double del_toc; // Time since ephemeris
    double del_toe;
    double del_tsv; // Clock correction term
    double tc;
    double ea, ei, diff, ta, aol, delr, delal, delinc, r, inc, la, xp, yp;
    double wm;

    double n;
    double ma_dot;

    /* Save some float math. */
    double s, c, sin_ea, cos_ea, e2, sqra2, s_la, c_la;

    // Find the time difference in seconds for the clock correction
    del_toc = pr[ch].sat_time - ephemeris[ch].toc;

    // Adjust for wrapping at end-of-week: assumes ephemeris never more than
    // 1/2 week old. (BB p138)
    // I don't think this is handled correctly (toc vs toe) (GBp210)
    if (del_toc > SECONDS_IN_WEEK / 2)
        del_toc -= SECONDS_IN_WEEK;
    else if (del_toc < -SECONDS_IN_WEEK / 2)
        del_toc += SECONDS_IN_WEEK;

    // Calculate the time correction except for relativistic effects - need
    // to calculate Ek first below. (BB p133)
    // FIXME This may be wrong see above.
    del_tsv = ephemeris[ch].af0 + del_toc * (ephemeris[ch].af1 + ephemeris[ch].af2 * del_toc);

    // L1 - L2 Correction (group delay) for single freq. users
    // Bluebook pg 134
    del_tsv -= ephemeris[ch].tgd;

    // Tsv corrected time (except relativistic effects)
    tc = pr[ch].sat_time - del_tsv;

    // Find the time since orbital reference in seconds.
    del_toe = tc - ephemeris[ch].toe;

    // Adjusted for wrapping at end-of-week (assumes reference never more than
    // 1/2 week ago) Note the time used is corrected EXCEPT for relativistic
    // effects
    // Yes, this wrapping is right, but shouldn't it apply to (tc) prior to
    // computing (del_tsv)?
    if (del_toe > SECONDS_IN_WEEK / 2)
        del_toe -= SECONDS_IN_WEEK;
    else if (del_toe < -SECONDS_IN_WEEK / 2)
        del_toe += SECONDS_IN_WEEK;

    /* Solve for the eccentric anomaly
     * ea is the eccentric anomaly to be found,
     * ei is the iterated value of ea,
     * ma is the mean anomaly at reference time,
     * ety is the orbital eccentricity,
     * wm is the average sat.ang.velocity,
     * dn is the ephemeris correction to wm,
     */
    // The eccentric anomaly is a solution to the equation
    //   ea = ma + ety sin[ea]
    // Solve this equation by Newton's method
    // Initial value is taken to be the mean anomaly
    // might do better with a better initial value (BBp164)

    // calculate average sat.ang.vel.
    wm = SQRMU / pow(ephemeris[ch].sqra, 3.0);

    n = wm + ephemeris[ch].dn;
    ma_dot = n;

    // Prep the loop
    ei = ephemeris[ch].ma + del_toe * (wm + ephemeris[ch].dn);
    ea = ei;
    sin_ea = sin(ea);
    cos_ea = cos(ea);

    for (i = 0; i < 10; i++) /* Avoid possible endless loop. */
    {
        // FIXME Why isn't it En - eSin En - ***M***???
        diff = (ei - (ea - ephemeris[ch].ety * sin_ea)) /
               (1.0 - ephemeris[ch].ety * cos_ea);
        ea += diff;
        sin_ea = sin(ea); // Used after for loop done!
        cos_ea = cos(ea); // Used after for loop done!
        if (fabs(diff) < 1.0e-12)
            break;
    }

    /* ea may not converge. No error handling. */
    // It would be interesting to tag non-convergence, probably never happens.

    double ea_dot = ma_dot / (1 - ephemeris[ch].ety * cos(ea));

    // Now make the relativistic correction  to the coarse time (BBp133)
    del_tsv = del_tsv +
              (F_RC * ephemeris[ch].ety * ephemeris[ch].sqra * sin_ea);

    // Store the final clock corrections (Used for m_rho in position_thread.)
    result.pos.tb = del_tsv;

    /* ta is the true anomaly (angle from perigee) */
    // This is clever because it magically gets the sign right
    e2 = ephemeris[ch].ety * ephemeris[ch].ety;
    ta = atan2((sqrt(1.0 - e2) * sin_ea), (cos_ea - ephemeris[ch].ety));

    double ta_dot = sin(ea) * ea_dot * (1 + ephemeris[ch].ety * cos(ta)) / ((1 - cos(ea) * ephemeris[ch].ety) * sin(ta));

    /* aol is the argument of latitude of the satellite */
    // w is the argument of perigee (GBp59)
    // aol is v
    aol = ta + ephemeris[ch].w;

    double phi_dot = ta_dot;

    /* Calculate the second harmonic perturbations of the orbit */
    c = cos(aol + aol);
    s = sin(aol + aol);
    delr = ephemeris[ch].crc * c + ephemeris[ch].crs * s;   // radius
    delal = ephemeris[ch].cuc * c + ephemeris[ch].cus * s;  // arg. of latitude
    delinc = ephemeris[ch].cic * c + ephemeris[ch].cis * s; // inclination

    double delal_dot = 2 * (ephemeris[ch].cus * c - ephemeris[ch].cuc * s) * phi_dot;
    double delr_dot = 2 * (ephemeris[ch].crs * c - ephemeris[ch].crc * s) * phi_dot;
    double delinc_dot = 2 * (ephemeris[ch].cis * c - ephemeris[ch].cic * s) * phi_dot;

    /* r is the radius of satellite orbit at time pr[ch].sat_time */
    // A = sqrt(Orbital major axis)^2
    /* sqra??? */
    sqra2 = ephemeris[ch].sqra * ephemeris[ch].sqra;
    r = sqra2 * (1 - ephemeris[ch].ety * cos_ea) + delr;
    aol += delal;
    inc = ephemeris[ch].inc0 + delinc + ephemeris[ch].idot * del_toe;

    double r_dot = sqra2 * ephemeris[ch].ety * sin(ea) * ea_dot + delr_dot;
    double aol_dot = phi_dot + delal_dot;
    double inc_dot = ephemeris[ch].idot + delinc_dot;

    /* la is the corrected longitude of the ascending node */
    la = ephemeris[ch].w0 + del_toe * (ephemeris[ch].omegadot - OMEGA_E) -
         OMEGA_E * ephemeris[ch].toe;

    // xy position in orbital plane
    xp = r * cos(aol);
    yp = r * sin(aol);

    double xp_dot = r_dot * cos(aol) - r * sin(aol) * aol_dot;
    double yp_dot = r_dot * sin(aol) + r * cos(aol) * aol_dot;

    double la_dot = ephemeris[ch].omegadot - OMEGA_E;

    // transform to ECEF
    s_la = sin(la);
    c_la = cos(la);
    s = sin(inc);
    c = cos(inc);

    result.pos.x = xp * c_la - yp * c * s_la;
    result.pos.y = xp * s_la + yp * c * c_la;
    result.pos.z = yp * s;

    result.vel.vx = xp_dot * c_la - yp_dot * c * s_la +
                    yp * s * s_la * inc_dot - result.pos.y * la_dot;
    result.vel.vy = xp_dot * s_la + yp_dot * c * c_la -
                    yp * s * inc_dot * c_la + result.pos.x * la_dot;
    result.vel.vz = yp_dot * s + yp * c * inc_dot;

    return (result);
}

/******************************************************************************
 * Wake up on valid measurements and produce pseudoranges. Flag the navigation
 * thread if we have four or more valid pseudoranges
 ******************************************************************************/
