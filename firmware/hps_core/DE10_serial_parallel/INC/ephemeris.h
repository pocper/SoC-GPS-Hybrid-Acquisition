// message.h: Header file for the message.c file
// Copyright (C) 2005  Andrew Greenberg
// Distributed under the GNU GENERAL PUBLIC LICENSE (GPL) Version 2 (June 1991).
// See the "COPYING" file distributed with this software for more information.

#ifndef __EPHEMERIS_H
#define __EPHEMERIS_H

#include "constants.h" // N_CHANNELS
#include "namuru.h"

/*******************************************************************************
 * Definitions
 ******************************************************************************/

// None
 
/*******************************************************************************
 * Declarations
 ******************************************************************************/

typedef struct
{
    unsigned short  prn;            // which satellite we're talkin' about
    unsigned short  valid;           // Use me, I'm valid.
    unsigned short  have_subframe;  // 5bits of how many valid subframe we have;
                                    // have all = 0x1F (or 0x7 if no 4/5)

    unsigned short  iodc;       // Issue of Data: Clock     (10 bits)
    unsigned short  iode;       // Issue of Data: Ephemeris (10 bits)
    unsigned short  ura;        // User Range Accuracy       (4 bits)
    unsigned short  health;     // Sat vehicle health        (6 bits)
    
    /* Subframe 1: Clock Corrections for delta t(sv)
     *             (2C) = Two's complement = signed number
     *             b = bits */
    
    double  tgd;        // T(gd): L1-L2 correction            (2C 8b * 2^-31)
    double  toc;        // t(oc): clock ref. time   (max = 604784, 16b * 2^4) 
    double  af0;        // a(f0): Constant term              (2C 22b * 2^-31)
    double  af1;        // a(f1): Linear term                (2C 16b * 2^-43)
    double  af2;        // a(f2): Squared term                (2C 8b * 2^-55)
    
    /* Subframe 2: Ephemeris */
    
    double  crs;        // C(rs): SIN correction radius      (2C 16b * 2^ -5)
    double  dn;         // Delta n: mean motion difference   (2C 16b * 2^-43)
    double  ma;         // M(0): mean anomaly                (2C 32b * 2^-31)
    double  cuc;        // C(uc): COS correction latitude    (2C 16b * 2^-29)
    double  ety;        // e: eccentricity of orbit   (max=0.03, 32b * 2^-33)
    double  cus;        // C(us): SIN correctoin latitude    (2C 16b * 2^-29)
    double  sqra;       // (A)^1/2: sqrt semimajor axis         (32b * 2^-19)
    double  toe;        // T(oe):ephemeris ref. time (max=604,784, 16b * 2^4)
    
    /* Subframe 3: ephemeris */
    
    double  cic;        // C(ic): COS correction inclination (2C 16b * 2^-29)
    double  w0;         // Omega(0): longitude of asc. node  (2C 32b * 2^-31)
    double  cis;        // C(is): SIN correction inclination (2C 16b * 2^-29)
    double  inc0;       // I(0): inclination angle @ ref.    (2C 32b * 2^-31)
    double  crc;        // C(rc): COS correction radius      (2C 16b * 2^ -5)
    double  w;          // Omega: arguemnt of perigee        (2C 32b * 2^-31)
    double  omegadot;   // OMEGADOT: rate of right asc.      (2C 24b * 2^-43)
    double  idot;       // IDOT: rate of inclination angle   (2C 14b * 2^-43)

} ephemeris_t;
 
void clear_ephemeris(unsigned short ch);
void process_subframe1(unsigned short ch);
void process_subframe2(unsigned short ch);
void process_subframe3(unsigned short ch);
void process_subframe4(unsigned short ch);
void process_subframe5(unsigned short ch);

/*******************************************************************************
 * Externs
 ******************************************************************************/

extern ephemeris_t ephemeris[N_CHANNELS];

#endif // __EPHEMERIS_H
