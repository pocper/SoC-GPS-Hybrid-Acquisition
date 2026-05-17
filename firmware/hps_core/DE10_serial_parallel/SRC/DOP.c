#include <stdio.h>
#include <math.h>
#include <stdlib.h>

#include "DOP.h"
#include "namuru.h"
#include "position.h"

DOP_t calculate_DOP(unsigned short NumSV)
{
    DOP_t DOP;
    DOP.valid = 0;
    DOP.Num_of_SV = NumSV;

    // user East-North-Up (ENU) coordinates
    double EASTi = 0;
    double NORTHi = 0;
    double UPi = receiver_llh.hgt;

    // Satellite : Convert ECEF coordinates to East-North-Up (ENU) coordinates
    double EASTs[N_CHANNELS];
    double NORTHs[N_CHANNELS];
    double UPs[N_CHANNELS];

    double SV[N_CHANNELS][3];
    double r[N_CHANNELS], Dx[N_CHANNELS], Dy[N_CHANNELS], Dz[N_CHANNELS], Dt[N_CHANNELS];
    
    double Alp[N_CHANNELS][4];
    double Brv[4][N_CHANNELS];
    // FIXME:
    double Chl[4][4];
    double Drv[4][4]; // 只要開第二組[4][4]就會故障
    double det_Chl = 0;
    double D[4][4];
    // FIXME:
    // Prime vertical radius of curvature
    double N = WGS84_A / sqrt(1 - WGS84_ES * sin(receiver_llh.lat) * sin(receiver_llh.lat));

    // ECEF coordinates for Local Reference Pt for ENU frame (meters)
    double xLocalRef = (N + SEA_LEVEL) * cos(receiver_llh.lat) * cos(receiver_llh.lon);
    double yLocalRef = (N + SEA_LEVEL) * cos(receiver_llh.lat) * sin(receiver_llh.lon);
    double zLocalRef = (((1 - WGS84_ES) * N) + SEA_LEVEL) * sin(receiver_llh.lat);

    // λ (lambda): Longitude, the angular displacement in radians east or west of the Prime Meridian.
    // φ (phi): Latitude, the angular displacement in radians north or south of the Equator.
    // ΔX: The difference in the X-coordinate between the satellite's position and the local reference point
    // ΔY: The difference in the Y-coordinate between the satellite's position and the local reference point
    // ΔZ: The difference in the Z-coordinate between the satellite's position and the local reference point
    // [ East  ]   [ -sin(λ)          cos(λ)           0          ]   [ ΔX ]
    // [ North ] = [ -sin(φ)*cos(λ)   -sin(φ)*sin(λ)   cos(φ)     ] * [ ΔY ]
    // [ Up    ]   [ cos(φ)*cos(λ)    cos(φ)*sin(λ)    sin(φ)     ]   [ ΔZ ]
    for (int num = 0; num < NumSV; num++)
    {
        EASTs[num] = -sin(receiver_llh.lon) * (sat_position[num].x - xLocalRef) + cos(receiver_llh.lon) * (sat_position[num].y - yLocalRef);
        NORTHs[num] = (-sin(receiver_llh.lat) * cos(receiver_llh.lon) * (sat_position[num].x - xLocalRef)) - (sin(receiver_llh.lat) * sin(receiver_llh.lon) * (sat_position[num].y - yLocalRef)) + (cos(receiver_llh.lat) * (sat_position[num].z - zLocalRef));
        UPs[num] = (cos(receiver_llh.lat) * cos(receiver_llh.lon) * (sat_position[num].x - xLocalRef)) + (cos(receiver_llh.lat) * sin(receiver_llh.lon) * (sat_position[num].y - yLocalRef)) + (sin(receiver_llh.lat) * (sat_position[num].z - zLocalRef));
    }

    // Assigning coordinates to respective visible satellites
    for (int i = 0; i < NumSV; i++)
    {
        SV[i][0] = EASTs[i];
        SV[i][1] = NORTHs[i];
        SV[i][2] = UPs[i];
    }

    // Calculate Directional Derivatives
    for (int i = 0; i < NumSV; i++)
    {
        // Calculate pseudo-ranges from target position to visible satellites
        r[i] = sqrt((SV[i][0] - EASTi) * (SV[i][0] - EASTi) + (SV[i][1] - NORTHi) * (SV[i][1] - NORTHi) + (SV[i][2] - UPi) * (SV[i][2] - UPi));
        // Calculate directional derivatives for East, North, Up and Time
        Dx[i] = SV[i][0] / r[i];                      // unit length
        Dy[i] = SV[i][1] / r[i];                      // unit length
        Dz[i] = (SV[i][2] - receiver_llh.hgt) / r[i]; // unit length
        Dt[i] = -1;
    }

    // Produce the Covariance Matrix from the Directional Derivatives
    for (int i = 0; i < N_CHANNELS; i++)
    {
        for (int j = 0; j < 4; j++)
        {
            Alp[i][j] = 0; // Initialize Alp
        }
    }

    for (int i = 0; i < NumSV; i++)
    {
        Alp[i][0] = Dx[i];
        Alp[i][1] = Dy[i];
        Alp[i][2] = Dz[i];
        Alp[i][3] = Dt[i];
    }

    // Transpose Alp to get Brv
    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < N_CHANNELS; j++)
        {
            Brv[i][j] = 0; // Initialize Brv
        }
    }

    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < NumSV; j++)
        {
            Brv[i][j] = Alp[j][i];
        }
    }

    // Matrix multiplication of Brv and Alp
    // Alp := H
    // Brv := transpose(H)
    // Brv * Alp := transpose(H) * H
    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < 4; j++)
        {
            Chl[i][j] = 0; // Initialize Chl
        }
    }
    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < 4; j++)
        {
            for (int k = 0; k < N_CHANNELS; k++)
                Chl[i][j] += Brv[i][k] * Alp[k][j];
        }
    }

    // calculate |Chl|
    for (int i = 0; i < 4; i++)
    {
        det_Chl = det_Chl + pow(-1,i)*Chl[0][i]*(
              Chl[1][(i+1)%4] * Chl[2][(i+2)%4] * Chl[3][(i+3)%4]
            + Chl[1][(i+2)%4] * Chl[2][(i+3)%4] * Chl[3][(i+1)%4]
            + Chl[1][(i+3)%4] * Chl[2][(i+1)%4] * Chl[3][(i+2)%4]
            - Chl[1][(i+3)%4] * Chl[2][(i+2)%4] * Chl[3][(i+1)%4]
            - Chl[1][(i+2)%4] * Chl[2][(i+1)%4] * Chl[3][(i+3)%4]
            - Chl[1][(i+1)%4] * Chl[2][(i+3)%4] * Chl[3][(i+2)%4]);
    }

    if (det_Chl == 0)
        return DOP;

    // Transpose Chl to get Drv
    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < 4; j++)
        {
            Drv[i][j] = Chl[j][i];
        }
    }

    // Inverse Matrix
    // C_x = inverse(transpose(H) * H), C_x = Covariance Matrix
    D[0][0] = (Drv[1][1] * Drv[2][2] * Drv[3][3] +
               Drv[1][2] * Drv[2][3] * Drv[3][1] +
               Drv[1][3] * Drv[2][1] * Drv[3][2] -
               Drv[1][3] * Drv[2][2] * Drv[3][1] -
               Drv[1][2] * Drv[2][1] * Drv[3][3] -
               Drv[1][1] * Drv[2][3] * Drv[3][2]) /
              det_Chl;
    D[1][1] = (Drv[0][0] * Drv[2][2] * Drv[3][3] +
               Drv[0][2] * Drv[2][3] * Drv[3][0] +
               Drv[0][3] * Drv[2][0] * Drv[3][2] -
               Drv[0][3] * Drv[2][2] * Drv[3][0] -
               Drv[0][2] * Drv[2][0] * Drv[3][3] -
               Drv[0][0] * Drv[2][3] * Drv[3][2]) /
              det_Chl;
    D[2][2] = (Drv[0][0] * Drv[1][1] * Drv[3][3] +
               Drv[0][1] * Drv[1][3] * Drv[3][0] +
               Drv[0][3] * Drv[1][0] * Drv[3][1] -
               Drv[0][3] * Drv[1][1] * Drv[3][0] -
               Drv[0][1] * Drv[1][0] * Drv[3][3] -
               Drv[0][0] * Drv[1][3] * Drv[3][1]) /
              det_Chl;
    D[3][3] = (Drv[0][0] * Drv[1][1] * Drv[2][2] +
               Drv[0][1] * Drv[1][2] * Drv[2][0] +
               Drv[0][2] * Drv[1][0] * Drv[2][1] -
               Drv[0][2] * Drv[1][1] * Drv[2][0] -
               Drv[0][1] * Drv[1][0] * Drv[2][2] -
               Drv[0][0] * Drv[1][2] * Drv[2][1]) /
              det_Chl;

    DOP.valid = 1;
    DOP.VDOP = sqrt(D[2][2]);
    DOP.HDOP = sqrt(D[0][0] + D[1][1]);
    DOP.PDOP = sqrt(D[0][0] + D[1][1] + D[2][2]);
    DOP.GDOP = sqrt(D[0][0] + D[1][1] + D[2][2] + D[3][3]);
    return DOP;
}
