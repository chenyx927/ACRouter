//
//  ACBaseModel.m
//  QualityDevelopment
//
//  Created by creasyma on 2017/2/9.
//  Copyright © 2017年 jingcai. All rights reserved.
//

#import "ACBaseModel.h"
#import "YYModel.h"

@interface ACArchiveFolder : NSObject

+ (NSString *)path;
+ (NSArray *)getFileListAtPath:(NSString *)path;
+ (BOOL)removeItemAtPath:(NSString *)path;

@end

@implementation ACArchiveFolder

+ (NSString *)path
{
    NSString *cacheFolderPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *toPath = [cacheFolderPath stringByAppendingPathComponent:@"com.xpsuperkit.caches"];
    
    
    //创建归档文件夹
    if (![self createDirectoryAtPath:toPath]) {
        return nil;
    }
    
    return toPath;
}

//创建文件夹
+ (BOOL)createDirectoryAtPath:(NSString *)dirPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:dirPath]) {
        return YES;
    }
    
    NSError *error;
    [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
    if (error) {
        NSLog(@"[%@] -- 创建%@文件夹失败 -- error:%@\n", NSStringFromClass(self.class), dirPath.lastPathComponent, error);
        
        return NO;
    }
    
    return YES;
}

//获取文件列表
+ (NSArray *)getFileListAtPath:(NSString *)path
{
    if (!path) {
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:path error:&error];
    
    if (error) {
        NSLog(@"[%@] -- 获取文件列表失败 -- error:%@", NSStringFromClass(self.class), error);
    }
    
    return fileList;
}

+ (BOOL)removeItemAtPath:(NSString *)path
{
    if (!path) {
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error;
        [fileManager removeItemAtPath:path error:&error];
        
        if (error) {
            NSLog(@"[%@] -- %@ 删除失败\n", NSStringFromClass(self.class), path.lastPathComponent);
            
            return NO;
        }
    }
    
    return YES;
}

@end















@interface ACBaseModel () <YYModel>

@end

@implementation ACBaseModel

#pragma mark - Json -> Model
+ (instancetype)initWithJsonData:(id)jsonData
{
    return [self yy_modelWithJSON:jsonData];
}

+ (instancetype)initWithJsonDictionary:(NSDictionary *)jsonDict
{
    return [self yy_modelWithDictionary:jsonDict];
}

#pragma mark - Update Model with Json
- (BOOL)updateWithJsonData:(NSData *)jsonData
{
    return [self yy_modelSetWithJSON:jsonData];
}

- (BOOL)updateWithJsonDictionary:(NSDictionary *)jsonDict
{
    return [self yy_modelSetWithDictionary:jsonDict];
}

#pragma mark - Model -> Json
- (id)toJsonObject
{
    return [self yy_modelToJSONObject];
}

- (NSData *)toJsonData
{
    return [self yy_modelToJSONData];
}

- (NSString *)toJsonString
{
    return [self yy_modelToJSONString];
}

#pragma mark - 配置各种转换规则，提供给子类继承
+ (NSArray<NSString *> *)setPropertyBlacklist
{
    return nil;
}

+ (NSArray<NSString *> *)setPropertyWhitelist
{
    return nil;
}

+ (NSDictionary *)setCustomPropertyMap
{
    return nil;
}

+ (NSDictionary <NSString *, id> *)setContainerPropertyClassMap
{
    return nil;
}

- (NSDictionary *)setDefaultValueMap
{
    return nil;
}

- (BOOL)handleCustomTransformFromDictionary:(NSDictionary *)dic
{
    return YES;
}

- (BOOL)handleCustomTransformToDictionary:(NSMutableDictionary *)dic
{
    return YES;
}

#pragma mark - 缓存对象
- (BOOL)setInstance
{
    NSString *name = [NSString stringWithFormat:@"%@.objectcache", NSStringFromClass(self.class)];
    NSString *path = [[ACArchiveFolder path] stringByAppendingPathComponent:name];
    
    return [NSKeyedArchiver archiveRootObject:self toFile:path];
}

+ (instancetype)getInstance
{
    NSString *name = [NSString stringWithFormat:@"%@.objectcache", NSStringFromClass(self.class)];
    NSString *path = [[ACArchiveFolder path] stringByAppendingPathComponent:name];
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

+ (void)removeInstance
{
    NSString *name = [NSString stringWithFormat:@"%@.objectcache", NSStringFromClass(self.class)];
    NSString *path = [[ACArchiveFolder path] stringByAppendingPathComponent:name];
    
    [ACArchiveFolder removeItemAtPath:path];
}

+ (void)clearAllInstance
{
    NSString *path = [ACArchiveFolder path];
    NSArray *fileList = [ACArchiveFolder getFileListAtPath:path];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    for (NSString *filename in fileList) {
        NSString *filePath = [path stringByAppendingPathComponent:filename];
        [ACArchiveFolder removeItemAtPath:filePath];
    }
}




#pragma mark - YYModel method
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return [self setCustomPropertyMap];
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
    return [self setContainerPropertyClassMap];
}

+ (NSArray<NSString *> *)modelPropertyBlacklist
{
    return [self setPropertyBlacklist];
}

+ (NSArray<NSString *> *)modelPropertyWhitelist
{
    return [self setPropertyWhitelist];
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic
{
    NSMutableDictionary *customDict = nil;
    if (!dic.count) {
        customDict = [NSMutableDictionary dictionary];
    }else {
        customDict = [NSMutableDictionary dictionaryWithDictionary:dic];
    }
    
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(self.class, &propertyCount);
    for (unsigned int i = 0; i < propertyCount; i++) {
        objc_property_t property =  properties[i];
        const char *name = property_getName(property);
        const char *attributes = property_getAttributes(property);
        NSString *nsName = nil;
        NSString *nsAttributes = nil;
        if (name) {
            nsName = [NSString stringWithUTF8String:name];
        }else {
            continue;
        }
        
        if (attributes) {
            nsAttributes = [NSString stringWithUTF8String:attributes];
        }else {
            continue;
        }
        
        if ([nsAttributes hasPrefix:@"TB"]) {
            id value = customDict[nsName];
            if (value && [value isKindOfClass:[NSString class]]) {
                NSString *stringValue = (NSString *)value;
                
                if ([stringValue isEqualToString:@"y"] || [stringValue isEqualToString:@"Y"]) {
                    [customDict setObject:@"true" forKey:nsName];
                }else if ([stringValue isEqualToString:@"n"] || [stringValue isEqualToString:@"N"]) {
                    [customDict setObject:@"false" forKey:nsName];
                }
             }
        }
    }
    free(properties);
    
    NSDictionary *defaultMap = [self setDefaultValueMap];
    if (!defaultMap.count) {
        return customDict;
    }
    [defaultMap enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id value = [customDict objectForKey:key];
        
        if (!value || (value == (id)kCFNull)) {
            [customDict setObject:obj forKey:key];
        }
    }];
    
    return customDict;
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{    
    return [self handleCustomTransformFromDictionary:dic];
}

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic
{
    return [self handleCustomTransformToDictionary:dic];
}

#pragma mark - 内部方法
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self yy_modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    return [self yy_modelInitWithCoder:aDecoder];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self yy_modelCopy];
}
- (NSUInteger)hash
{
    return [self yy_modelHash];
}

- (BOOL)isEqual:(id)object
{
    return [self yy_modelIsEqual:object];
}

- (NSString *)description
{
    return [self yy_modelDescription];
}



















#pragma mark - deprecated method
- (NSString *)transformToJson
{
    return [self yy_modelToJSONString];
}

- (id)transformToObject
{
    return [self yy_modelToJSONObject];
}

@end
