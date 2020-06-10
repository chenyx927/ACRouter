//
//  CGFloat+ACAdd.h
//  ACBasicLib
//
//  Created by Ken.Liu on 2018/9/27.
//

#ifndef CGFloat_ACAdd_h
#define CGFloat_ACAdd_h

static __inline__ BOOL CGFloatEquals(CGFloat a, CGFloat b)
{
    const CGFloat CGEPSINON = 0.00000001;
    CGFloat c = a - b;
    return (c >= - CGEPSINON) && (c <= CGEPSINON);
}

static __inline__ BOOL FloatEquals(float a, float b)
{
    const float EPSINON = 0.00001;
    float c = a - b;
    return (c >= - EPSINON) && (c <= EPSINON);
}

static __inline__ BOOL DoubleEquals(double a, double b)
{
    const double DEPSINON = 0.00000001;
    double c = a - b;
    return (c >= - DEPSINON) && (c <= DEPSINON);
}

static __inline__ CGFloat transformUIDesignLength(CGFloat designLength)
{
    return ((CGFloat)designLength/3.0f);
}

#endif /* CGFlost_ACAdd_h */
