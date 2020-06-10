//
//  ACBaseModel.h
//  QualityDevelopment
//
//  Created by creasyma on 2017/2/9.
//  Copyright © 2017年 jingcai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ACBaseModel : NSObject <NSCoding, NSCopying>

#pragma mark - Json -> Model
/**
 *  从json创建对象
 *
 *  @param jsonData     接受 `NSDictionary`, `NSString` or `NSData`, 几种类型的json数据.
 *
 *  @return 对象实例
 */
+ (nullable instancetype)initWithJsonData:(id)jsonData;

/**
 *  从Json字典创建对象
 *
 *  @param jsonDict Json字典
 *
 *  @return 对象实例
 */
+ (nullable instancetype)initWithJsonDictionary:(NSDictionary *)jsonDict;


#pragma mark - Update Model with Json
/**
 *  从JsonData更新对象
 *
 *  @param jsonData 接受 `NSDictionary`, `NSString` or `NSData`, 几种类型的json数据.
 *
 *  @return 是否成功
 */
- (BOOL)updateWithJsonData:(id)jsonData;

/**
 *  从Json字典更新对象
 *
 *  @param jsonDict Json字典
 *
 *  @return 是否成功
 */
- (BOOL)updateWithJsonDictionary:(NSDictionary *)jsonDict;



#pragma mark - Model -> Json
/**
 *  model转成Json对象
 *
 *  @return Json 对象
 */
- (nullable id)toJsonObject;
- (nullable id)transformToObject DEPRECATED_MSG_ATTRIBUTE("此方法已经被弃用 请调用 toJsonObject");

/**
 *  model转成Json对象
 *
 *  @return NSData Json对象
 */
- (nullable NSData *)toJsonData;

/**
 *  model转成Json字符串
 *
 *  @return Json 字符串
 */
- (nullable NSString *)toJsonString;
- (NSString *)transformToJson DEPRECATED_MSG_ATTRIBUTE("此方法已经被弃用 请调用 toJsonString");



#pragma mark - 配置各种转换规则，提供给子类继承
/**
 *  实现此方法返回属性黑名单，在进行转换时需要忽略的属性
 *
 *  @return 在进行转换时需要忽略的属性数组
 */
+ (nullable NSArray<NSString *> *)setPropertyBlacklist;

/**
 *  实现此方法返回属性白名单，在进行转换时将忽略数组之外的属性
 *
 *  @return 在进行转换时将忽略数组之外的属性
 */
+ (nullable NSArray<NSString *> *)setPropertyWhitelist;

/**
 *  设置转换时Json节点属性与对象属性之间自定义的映射关系字典
 *  如要把Json节点 id 转为 对象的 userID 属性， 要把Json节点 name 转为 对象的 userName 属性时
 *  只需实现此方法设置 @{@"userId":@"id", @"userName":@"name"}即可
 *
 *  @return 自定义映射关系字典
 */
+ (nullable NSDictionary<NSString *, id> *)setCustomPropertyMap;

/**
 *  当对象属性为容器类型（如 NSArray、NSSet）时, 可调用此方法返回容器类属性中包含的对象类型映射关系字典即可完成自动转换
 *
 *  @return 容器类属性中包含的对象类型映射关系字典
 */
+ (nullable NSDictionary<NSString *, id> *)setContainerPropertyClassMap;

/**
 *  设置转换时某些属性的默认值
 *  如 实现此方法返回 @{@"title":@"默认标题"}，则当 Json 数据没有 title 节点或 title 节点值为 null 时，转换时
 *  对象 title 属性将设为给定的默认值 @"默认标题"
 *
 *  @return 属性默认值字典
 */
- (nullable NSDictionary<NSString *, id> *)setDefaultValueMap;

/**
 *  数据校验与自定义转换, 当 JSON 转为 Model 完成后，该方法会被调用。可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略
 *  可在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。也可以在这里做一些自动转换不能完成的工作
 *
 *  @param dic Json字典
 *
 *  @return 返回 NO，该 Model 会被忽略
 */
- (BOOL)handleCustomTransformFromDictionary:(NSDictionary *)dic;

/**
 *  数据校验与自定义转换, 当 Model 转为 JSON 完成后，该方法会被调用。可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 JSON 会被忽略
 *
 *  @param dic 对象字典
 *
 *  @return 返回 NO，该 JSON 会被忽略
 */
- (BOOL)handleCustomTransformToDictionary:(NSMutableDictionary *)dic;

#pragma mark - 缓存对象
/**
 *  缓存对象
 *
 *  @return 是否成功
 */
- (BOOL)setInstance;

/**
 *  从缓存中取出对象
 *
 *  @return 对象实例
 */
+ (nullable instancetype)getInstance;

/**
 *  从缓存中移除对象
 */
+ (void)removeInstance;

/**
 *  清除所有继承自 AXDBaseModel 的缓存对象
 */
+ (void)clearAllInstance;

@end

NS_ASSUME_NONNULL_END
