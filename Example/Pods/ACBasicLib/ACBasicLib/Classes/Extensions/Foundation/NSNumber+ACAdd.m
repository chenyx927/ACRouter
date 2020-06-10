//
//  NSNumber+ACAdd.m
//  BasicLib
//
//  Created by creasyma on 2018/4/2.
//

#import "NSNumber+ACAdd.h"

@implementation NSNumber (ACAdd)

+ (NSInteger)randomInteger:(NSInteger)from to:(NSInteger)to
{
    return (NSInteger)(from + (arc4random() % (to - from + 1)));
}

@end
