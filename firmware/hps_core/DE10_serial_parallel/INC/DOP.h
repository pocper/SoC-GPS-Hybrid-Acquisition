#ifndef __DOP_H
#define __DOP_H

// DOP,  Dilution of Precision
// GDOP, Geometric DOP
// PDOP, Position DOP
// HDOP, Horizontal DOP
// VDOP, Vertical DOP
typedef struct
{
    int valid;
    int Num_of_SV;
    double VDOP; // sqrt(ZDOP^2)
    double HDOP; // sqrt(XDOP^2+YDOP^2)
    double PDOP; // sqrt(XDOP^2+YDOP^2+VDOP^2)
    double GDOP; // sqrt(XDOP^2+YDOP^2+VDOP^2+TDOP^2)
} DOP_t;

DOP_t calculate_DOP(unsigned short NumSV);

#endif // __DOP_H
