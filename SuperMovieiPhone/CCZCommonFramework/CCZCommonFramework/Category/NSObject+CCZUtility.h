//
//  NSObject+CCZUtility.h
//  CCZFoundation
//
//  Created by chenchaozhong on 2017/4/12.
//  Copyright © 2017年 chenchaozhong. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
    @property(nonatomic,strong) NSArray *QunarParserArray(orderInfos, FPayBeforeCheckoutOrderInfos);
 */
//#define CCZParserArray(key,type)    key##__Array__##type;     \
//@property (nonatomic, strong, readonly, getter = QunarTestKey__##key) type *key
#define CCZParserArray(key,type)    key##__Array__##type;

@interface NSObject (CCZUtility)


- (NSDictionary *)toDictionary;

// 将简单对象转换成Object
- (void)serializeSimpleObject:(NSMutableDictionary *)dictionary;

- (void)parseJsonAutomaticWithString:(NSString *)jsonString forInfo:(id)customInfo;

// 自动解析Json
- (void)parseJsonAutomatic:(NSDictionary *)dictionaryJson forInfo:(id)customInfo;

// 自动解析JsonArray
+ (NSArray *)parseJsonArrayAutomatic:(NSArray *)arrayJson withObjectClass:(Class)objectClass forInfo:(id)customInfo;

@end
