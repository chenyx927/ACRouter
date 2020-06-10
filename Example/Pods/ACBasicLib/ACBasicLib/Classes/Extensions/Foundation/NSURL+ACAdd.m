//
//  NSURL+ACAdd.m
//  QualityDevelopment
//
//  Created by 李明伟 on 16/4/16.
//  Copyright © 2016年 jingcai. All rights reserved.
//

#import "NSURL+ACAdd.h"
#import "NSString+ACAdd.h"
#import "NSDictionary+ACAdd.h"

@implementation NSURL (ACAdd)

- (NSDictionary *)parseQuery {
    NSMutableDictionary *queryDict = [NSMutableDictionary dictionary];
    NSArray *keyValuePairs = [self.query componentsSeparatedByString:@"&"];
    
    for (NSString *keyValuePair in keyValuePairs) {
        NSArray *element = [keyValuePair componentsSeparatedByString:@"="];
        if (element.count != 2) continue;
        NSString *key = element[0], *value = element[1];
        if (key.length == 0) continue;
        queryDict[key] = value;
    }
    
    return [NSDictionary dictionaryWithDictionary:queryDict];
}

- (NSArray *)parseQueryKeyArray
{
    NSMutableArray *keyArray = [NSMutableArray array];
    NSArray *keyValuePairs = [self.query componentsSeparatedByString:@"&"];
    
    for (NSString *keyValuePair in keyValuePairs) {
        NSArray *element = [keyValuePair componentsSeparatedByString:@"="];
        if (element.count != 2) continue;
        NSString *key = element[0];
        if (key.length == 0) continue;
        [keyArray addObject:key];
    }
    
    return [NSArray arrayWithArray:keyArray];
}

- (NSString *)parseQueryFromDictionary:(NSDictionary *)dictionary withKeyOrder:(NSArray *)keyOrder
{
    if ((nil == dictionary) || (dictionary.count == 0)) {
        return @"";
    }
    
    NSString *result = @"";
    NSString *key;
    NSString *value;
    
    if ((nil == keyOrder) || (keyOrder.count == 0)) {
        NSArray *keys = [dictionary allKeys];
        for (int i = 0; i < keys.count; ++i) {
            key    = keys[i];
            value  = [dictionary objectForKey:key];
            result = [result stringByAppendingString:[NSString stringWithFormat:@"%@=%@", key, value]];
            if (i < keys.count-1) {
                result = [result stringByAppendingString:@"&"];
            }
        }
    } else {
        for (int i = 0; i < keyOrder.count; ++i) {
            key    = keyOrder[i];
            value  = [dictionary objectForKey:key];
            result = [result stringByAppendingString:[NSString stringWithFormat:@"%@=%@", key, value]];
            if (i < keyOrder.count-1) {
                result = [result stringByAppendingString:@"&"];
            }
        }
    }
    
    return result;
}

- (BOOL)isEqualTo:(NSURL *)url {
    NSURL *current  = self;
    NSURL *previous = url;
    
    NSURLComponents *currentComponents  = [NSURLComponents componentsWithURL:current resolvingAgainstBaseURL:YES];
    NSURLComponents *previousComponents = [NSURLComponents componentsWithURL:previous resolvingAgainstBaseURL:YES];
    
    BOOL schemeEqual;
    if (![NSString isEmpty:currentComponents.scheme] && ![NSString isEmpty:previousComponents.scheme]) {
        schemeEqual = [currentComponents.scheme equalsIgnoreCase:previousComponents.scheme];
    } else {
        schemeEqual = ([NSString isEmpty:currentComponents.scheme] && [NSString isEmpty:previousComponents.scheme]);
    }
    
    BOOL userEqual;
    if (![NSString isEmpty:currentComponents.user] && ![NSString isEmpty:previousComponents.user]) {
        userEqual = [currentComponents.user equalsIgnoreCase:previousComponents.user];
    } else {
        userEqual = ([NSString isEmpty:currentComponents.user] && [NSString isEmpty:previousComponents.user]);
    }
    
    BOOL passwordEqual;
    if (![NSString isEmpty:currentComponents.password] && ![NSString isEmpty:previousComponents.password]) {
        passwordEqual = [currentComponents.password equalsIgnoreCase:previousComponents.password];
    } else {
        passwordEqual = ([NSString isEmpty:currentComponents.password] && [NSString isEmpty:previousComponents.password]);
    }
    
    BOOL hostEqual;
    if (![NSString isEmpty:currentComponents.host] && ![NSString isEmpty:previousComponents.host]) {
        hostEqual = [currentComponents.host equalsIgnoreCase:previousComponents.host];
    } else {
        hostEqual = ([NSString isEmpty:currentComponents.host] && [NSString isEmpty:previousComponents.host]);
    }
    
    BOOL pathEqual;
    if (![NSString isEmpty:currentComponents.path] && ![NSString isEmpty:previousComponents.path]) {
        pathEqual = [currentComponents.path equalsIgnoreCase:previousComponents.path];
    } else {
        pathEqual = ([NSString isEmpty:currentComponents.path] && [NSString isEmpty:previousComponents.path]);
    }
    
    BOOL portEqual;
    if (currentComponents.port && previousComponents.port) {
        portEqual = currentComponents.port.integerValue == previousComponents.port.integerValue;
    } else {
        portEqual = ((currentComponents.port == nil) && (previousComponents.port == nil));
    }
    
    BOOL fragmentEqual;
    if (![NSString isEmpty:currentComponents.fragment] && ![NSString isEmpty:previousComponents.fragment]) {
        fragmentEqual = [currentComponents.fragment equalsIgnoreCase:previousComponents.fragment];
    } else {
        fragmentEqual = ([NSString isEmpty:currentComponents.fragment] && [NSString isEmpty:previousComponents.fragment]);
    }
    
    BOOL urlEqual = schemeEqual && userEqual && passwordEqual && hostEqual && portEqual && pathEqual && fragmentEqual;
    
    if (urlEqual) {
        if (![NSString isEmpty:currentComponents.query]) {
            if (![NSString isEmpty:previousComponents.query]) {
                NSMutableDictionary *currentQuery  = [NSMutableDictionary dictionaryWithDictionary:[current parseQuery]];
                NSMutableDictionary *previousQuery = [NSMutableDictionary dictionaryWithDictionary:[previous parseQuery]];
                
                if (currentQuery.count == previousQuery.count) {
                    [currentQuery removeObjectsForKeys:@[@"uid", @"sign"]];
                    [previousQuery removeObjectsForKeys:@[@"uid", @"sign"]];
                    
                    if (currentQuery.count == previousQuery.count && currentQuery.count == 0) {
                        return YES;
                    }
                    
                    NSArray *keys = currentQuery.allKeys;
                    BOOL valueEqual = YES;
                    for (NSString *key in keys) {
                        NSString *currentValue  = [currentQuery stringValueForKey:key default:@"currentValue"];
                        NSString *previousValue = [previousQuery stringValueForKey:key default:@"previousValue"];
                        valueEqual = [currentValue isEqualToString:previousValue];
                        if (!valueEqual) {
                            break;
                        }
                    }
                    
                    return valueEqual;
                } else {
                    if (currentQuery.count - previousQuery.count == 2) {
                        if (previousQuery.count == 0) {
                            [currentQuery removeObjectsForKeys:@[@"uid", @"sign"]];
                            return (currentQuery.count == 0);
                        } else {
                            NSArray *keys = previousQuery.allKeys;
                            [currentQuery removeObjectsForKeys:keys];
                            [currentQuery removeObjectsForKeys:@[@"uid", @"sign"]];
                            return (currentQuery.count == 0);
                        }
                    }
                    
                    return NO;
                }
            } else {
                NSMutableDictionary *currentQuery  = [NSMutableDictionary dictionaryWithDictionary:[current parseQuery]];
                if (currentQuery.count == 2) {
                    [currentQuery removeObjectsForKeys:@[@"uid", @"sign"]];
                    return (currentQuery.count == 0);
                }
                
                return NO;
            }
        } else {
            return [NSString isEmpty:previousComponents.query];
        }
    }
    else {
        return NO;
    }
}

@end
