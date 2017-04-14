//
//  ColorUtils.h
//  ps美白术
//
//  Created by 9188 on 2017/4/11.
//  Copyright © 2017年 朱同海. All rights reserved.
//

#ifndef ColorUtils_h
#define ColorUtils_h


#define Mask8(x)  (  (x) & 0xFF )

#define R(x)  ( Mask8(x) )
#define G(x)  ( Mask8(x >> 8 )  )
#define B(x)  ( Mask8(x >> 16)  )
#define A(x)  ( Mask8(x >> 24)  )

#define RGBAMake(r, g, b, a)  (  Mask8(r) | Mask8(g) << 8 | Mask8(b) << 16 | Mask8(a) << 24 )

#endif /* ColorUtils_h */
