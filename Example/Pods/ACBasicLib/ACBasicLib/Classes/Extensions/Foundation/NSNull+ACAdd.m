//
//  NSNull+ACAdd.m
//  ACBasicLib
//
//  Created by Ken.Liu on 2018/9/29.
//

#import "NSNull+ACAdd.h"

static NSArray *_NullObjects;

@implementation NSNull (ACAdd)
+ (void)load {
    _NullObjects = @[
                     [NSMutableArray arrayWithCapacity:1],
                     [NSMutableDictionary dictionaryWithCapacity:1],
                     [NSMutableString stringWithString:@""],
                     [NSNumber numberWithInt:0]
                     ];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
    
    if (signature != nil){
        return signature;
    }
    
    for (NSObject *object in _NullObjects) {
        signature = [object methodSignatureForSelector:selector];
        if (signature){
            if (strcmp(signature.methodReturnType, "@") == 0){
                signature = [self methodSignatureForSelector:@selector(_NullNil)];
            }
            break;
        }
    }
    
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if (strcmp(anInvocation.methodSignature.methodReturnType, "@") == 0) {
        anInvocation.selector = @selector(_NullNil);
        [anInvocation invokeWithTarget:self];
        return;
    }
    
    for (NSObject *object in _NullObjects) {
        if ([object respondsToSelector:anInvocation.selector]) {
            [anInvocation invokeWithTarget:object];
            return;
        }
    }
}

- (id)_NullNil{
    return nil;
}

@end
