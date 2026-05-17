// ephemeris.c gpl-gps Satellite navigation message to ephemeris processing
// Copyright (C) 2005  Andrew Greenberg
// Distributed under the GNU GENERAL PUBLIC LICENSE (GPL) Version 2 (June 1991).
// See the "COPYING" file distributed with this software for more information.
#include "cmsis_os2.h"
#include <math.h>
#include "constants.h"
#include "ephemeris.h"
#include "message.h"
#include "time.h"

/******************************************************************************
 * Defines
 ******************************************************************************/

// c_2pX == 2^+X, c_2mX == 2^-X
#define c_2p4 16.0
#define c_2m5 0.03125
#define c_2m19 1.9073486328125e-6
#define c_2m29 1.86264514923096e-9
#define c_2m31 4.65661287307739e-10
#define c_2m33 1.16415321826935E-10
#define c_2m43 1.13686837721616e-13
#define c_2m55 2.77555756156289e-17

/******************************************************************************
 * Globals
 ******************************************************************************/

// Right now we're declaring a message structure per channel, since the
// messages come out of locked channels_ready.. but you could argue they should
// be in a per-satellite array.

ephemeris_t ephemeris[N_CHANNELS];

/******************************************************************************
 * Statics
 ******************************************************************************/

// None

/******************************************************************************
 * If the channel is reallocated, then clear the ephemeris data for that
 * channel. Called from allocate.c
 ******************************************************************************/

void clear_ephemeris(unsigned short ch)
{
    ephemeris[ch].valid = 0;
    ephemeris[ch].have_subframe = 0;
    ephemeris[ch].prn = 0;
}

/******************************************************************************
 * Convert subframe bits to ephemeris values.
 *
 * Note that subframes aren't passed up from the message_thread unless they're
 * already considered valid (all parity checks have passed and been removed)
 ******************************************************************************/
void process_subframe1(unsigned short ch)
{
    signed long temp;
    unsigned long utemp;

    subframe_t *sf1 = &messages[ch].subframes[0];

    // Issue Of Data Clock (IODC)
    utemp = ((sf1->word[2] & 0x3) << 8) | (sf1->word[7] >> 16);

    // Skedaddle if we already have a valid ephemeris and we have this subframe,
    // and the IODC hasn't changed.
    if ((ephemeris[ch].valid) && (ephemeris[ch].have_subframe & (1 << 0)) && (ephemeris[ch].iodc == (unsigned short)utemp))
        return;

    ephemeris[ch].iodc = (unsigned short)utemp;
    ephemeris[ch].ura = (unsigned short)((sf1->word[2] & 0xF00) >> 8);
    ephemeris[ch].health = (unsigned short)((sf1->word[2] & 0xFC) >> 2);

    // According to ICD-GPDS-200C sect. 20.3.3.3.1.4, if the MSB of the 6 bit
    // health is set, the satellite's nav message is toast. Bad satellite!
    if (ephemeris[ch].health & (1 << 5))
    {
        clear_ephemeris(ch);
        return;
    }

    // Grab the PRN for good measure
    ephemeris[ch].prn = messages[ch].prn;

    // If we haven't already, then update the time with the week number in
    // this subframe. Note that we have NO stinking clue what the true
    // year is because the week is modulo 1024 which is about 20 years.
    // So we'll just guess it's past 2000 :) and before ~ 2020 which
    // means adding 1024 to the current week.
    // Rollover #1, 1999/08/21
    // Rollover #2, 2019/04/06
    utemp = (sf1->word[2] >> 14) + 1024;
    set_time_with_weeks((unsigned short)utemp);

    // Get the rest of the ephemerides
    utemp = sf1->word[7] & 0xffff;
    ephemeris[ch].toc = (double)utemp * c_2p4;

    // The following variables are signed integers so if the MSB is set,
    // 'deal
    // with the sign. Standard sign extending |= 0xFFFFFF00 wasn't
    // working for whatever reason?! Yes, this sucks but the if makes it
    // faster than another multiply, even by -1.
    // TODO try (-((1<<n) - x)) for (x) of (n)bits.
    temp = sf1->word[6] & 0xff;
    if (temp & (1 << 7))
        temp |= ~0xff;
    ephemeris[ch].tgd = (double)temp * c_2m31;

    temp = sf1->word[8] >> 16;
    if (temp & (1 << 7))
        temp |= ~0xff;
    ephemeris[ch].af2 = (double)temp * c_2m55;

    temp = sf1->word[8] & 0xffff;
    if (temp & (1 << 15))
        temp |= ~0xFFFF;
    ephemeris[ch].af1 = (double)temp * c_2m43;

    temp = sf1->word[9] >> 2;
    if (temp & (1 << 21))
        temp |= ~0x3FFFFF;
    ephemeris[ch].af0 = (double)temp * c_2m31;

    // Got subframe 1
    ephemeris[ch].have_subframe |= (1 << 0);
}

void process_subframe2(unsigned short ch)
{
    unsigned short short_temp;
    unsigned long ultemp;
    long temp;

    // map the messages structure to OSGPS's "sf"
    // subframe_t *sf = messages[ch].subframes;
    subframe_t *sf2 = &messages[ch].subframes[1];

    short_temp = (unsigned short)(sf2->word[2] >> 16);

    // Skedaddle if we already have a valid ephemeris, and we have this
    // subframe, and the `Issue Of Data Ephemeris' (IODE) hasn't changed.
    if ((ephemeris[ch].valid) && (ephemeris[ch].have_subframe & (1 << 1)) && (ephemeris[ch].iode == short_temp))
        return;

    // Some of these data words are signed; check their sign bit and extend
    // as appropriate
    ephemeris[ch].iode = (unsigned short)short_temp;

    // Grab the PRN for good measure
    ephemeris[ch].prn = messages[ch].prn;

    temp = sf2->word[2] & 0xFFFF;
    if (temp & (1 << 15))
        temp |= ~0xFFFF;
    ephemeris[ch].crs = (double)temp * c_2m5;

    temp = sf2->word[3] >> 8;
    if (temp & (1 << 15))
        temp |= ~0xFFFF;
    ephemeris[ch].dn = (double)temp * (c_2m43 * PI);

    temp = ((sf2->word[3] & 0xFF) << 24) | sf2->word[4];
    ephemeris[ch].ma = (double)temp * (c_2m31 * PI);

    temp = sf2->word[5] >> 8;
    if (temp & (1 << 15))
        temp |= ~0xFFFF;
    ephemeris[ch].cuc = (double)temp * c_2m29;

    temp = ((sf2->word[5] & 0xFF) << 24) | sf2->word[6];
    ephemeris[ch].ety = (double)temp * c_2m33;

    temp = sf2->word[7] >> 8;
    if (temp & (1 << 15))
        temp |= ~0xFFFF;
    ephemeris[ch].cus = (double)temp * c_2m29;

    ultemp = (((sf2->word[7] & 0xFF) << 24) | sf2->word[8]);
    ephemeris[ch].sqra = (double)ultemp * c_2m19;

    ultemp = (sf2->word[9] >> 8);
    ephemeris[ch].toe = (double)ultemp * c_2p4;

    // Got subframe 2
    ephemeris[ch].have_subframe |= (1 << 1);
}

void process_subframe3(unsigned short ch)
{
    long temp;
    unsigned short short_temp;
    // map the messages structure to OSGPS's "sf"
    // subframe_t *sf = messages[ch].subframes;
    subframe_t *sf3 = &messages[ch].subframes[2];

    short_temp = (unsigned short)(sf3->word[9] >> 16);

    // Skedaddle if we already have a valid ephemeris, we have this subframe,
    // and the IODE hasn't changed.
    if ((ephemeris[ch].valid) && (ephemeris[ch].have_subframe & (1 << 3)) && (ephemeris[ch].iode == short_temp))
        return;

    // Grab the PRN for good measure
    ephemeris[ch].prn = messages[ch].prn;

    // Some of these data words are signed; check their sign bit and extend
    // as appropriate

    temp = sf3->word[2] >> 8;
    if (temp & (1 << 15))
        temp |= ~0xFFFF;
    ephemeris[ch].cic = (double)temp * c_2m29;

    temp = ((sf3->word[2] & 0xFF) << 24) | sf3->word[3];
    ephemeris[ch].w0 = (double)temp * (c_2m31 * PI);

    temp = sf3->word[4] >> 8;
    if (temp & (1 << 15))
        temp |= ~0xFFFF;
    ephemeris[ch].cis = (double)temp * c_2m29;

    temp = ((sf3->word[4] & 0xFF) << 24) | sf3->word[5];
    ephemeris[ch].inc0 = (double)temp * (c_2m31 * PI);

    temp = sf3->word[6] >> 8;
    if (temp & (1 << 15))
        temp |= ~0xFFFF;
    ephemeris[ch].crc = (double)temp * c_2m5;

    temp = ((sf3->word[6] & 0xFF) << 24) | sf3->word[7];
    ephemeris[ch].w = (double)temp * (c_2m31 * PI);

    temp = sf3->word[8];
    if (temp & (1 << 23))
        temp |= ~0xFFFFFF;
    ephemeris[ch].omegadot = (double)temp * (c_2m43 * PI);

    temp = (sf3->word[9] >> 2) & 0x3FFF;
    if (temp & (1 << 13))
        temp |= ~0x3FFF;
    ephemeris[ch].idot = (double)temp * (c_2m43 * PI);

    // Got subframe 3
    ephemeris[ch].have_subframe |= (1 << 2);
}

void process_subframe4(unsigned short ch)
{
    // Sure, you got subframe 4, why not?
    ephemeris[ch].have_subframe |= (1 << 3);
}

void process_subframe5(unsigned short ch)
{
    // Sure, you got subframe 5, why not?
    ephemeris[ch].have_subframe |= (1 << 4);
}

/******************************************************************************
 * Stuff incoming bits from the tracking interrupt into words and subframes in
 * the messages structure.
 ******************************************************************************/
