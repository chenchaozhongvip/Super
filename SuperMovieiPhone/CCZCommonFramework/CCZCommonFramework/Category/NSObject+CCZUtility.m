//
//  NSObject+CCZUtility.m
//  CCZFoundation
//
//  Created by chenchaozhong on 2017/4/12.
//  Copyright © 2017年 chenchaozhong. All rights reserved.
//

#import "NSObject+CCZUtility.h"
#import <Foundation/NSObjCRuntime.h>
#import <objc/runtime.h>

@implementation NSObject (CCZUtility)

- (NSDictionary *)toDictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    NSString *className = NSStringFromClass([self class]);
    const char *cClassName = [className UTF8String];
    id theClass = objc_getClass(cClassName);
    
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList(theClass, &propertyCount);
    for(unsigned int i = 0; i < propertyCount; i++)
    {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        // 获取对象
        Ivar iVar = class_getInstanceVariable([self class], [propertyName UTF8String]);
        
        if(iVar == nil)
        {
            // 采用另外一种方法尝试获取
            iVar = class_getInstanceVariable([self class], [[NSString stringWithFormat:@"_%@", propertyName] UTF8String]);
        }
        
        // 赋值
        if(iVar != nil)
        {
            id propertyValue = object_getIvar(self, iVar);
            
            // 插入Dictionary中
            if(propertyValue != nil)
            {
                if ([propertyValue isKindOfClass:[NSString class]]
                    || [propertyValue isKindOfClass:[NSMutableString class]]
                    || [propertyValue isKindOfClass:[NSNumber class]]
                    || [propertyValue isKindOfClass:[NSDictionary class]]
                    || [propertyValue isKindOfClass:[NSMutableDictionary class]])
                {
                    [dictionary setObject:propertyValue forKey:propertyName];
                }
                else if ([propertyValue isKindOfClass:[NSArray class]]
                         || [propertyValue isKindOfClass:[NSMutableArray class]])
                {
                    NSMutableArray *values = [NSMutableArray array];
                    for (id object in propertyValue) {
                        NSDictionary *dict = [object toDictionary];
                        [values addObject:dict];
                    }
                    
                    NSRange range = [propertyName rangeOfString:@"__Array__"];
                    if (range.length > 0)
                    {
                        propertyName = [propertyName substringToIndex:range.location];
                    }
                    
                    [dictionary setObject:values forKey:propertyName];
                }
                else
                {
                    //自定义类
                    NSDictionary *dict = [propertyValue toDictionary];
                    [dictionary setObject:dict forKey:propertyName];
                }
            }
        }
    }
    
    free(properties);
    
    return dictionary;
}


// 成员变量转换成字典
- (void)serializeSimpleObject:(NSMutableDictionary *)dictionary
{
    NSString *className = NSStringFromClass([self class]);
    const char *cClassName = [className UTF8String];
    id theClass = objc_getClass(cClassName);
    
    // 获取property
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList(theClass, &propertyCount);
    for(unsigned int i = 0; i < propertyCount; i++)
    {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        // 获取对象
        Ivar iVar = class_getInstanceVariable([self class], [propertyName UTF8String]);
        if(iVar == nil)
        {
            // 采用另外一种方法尝试获取
            iVar = class_getInstanceVariable([self class], [[NSString stringWithFormat:@"_%@", propertyName] UTF8String]);
        }
        
        // 赋值
        if(iVar != nil)
        {
            id propertyValue = object_getIvar(self, iVar);
            
            // 插入Dictionary中
            if(propertyValue != nil)
            {
                [dictionary setObject:propertyValue forKey:propertyName];
            }
        }
    }
    
    free(properties);
}
- (void)parseJsonAutomaticWithString:(NSString *)jsonString forInfo:(id)customInfo
{
    
}
// 自动解析Json
- (void)parseJsonAutomatic:(NSDictionary *)dictionaryJson forInfo:(id)customInfo
{
    // 如果Json数据无效,产生Sentry Json
    if(dictionaryJson == nil)
    {
        dictionaryJson = [[NSDictionary alloc] init];
    }
    
    // 获取对象
    NSString *className = NSStringFromClass([self class]);
    const char *cClassName = [className UTF8String];
    id theClass = objc_getClass(cClassName);
    
    // 获取property
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList(theClass, &propertyCount);
    for(unsigned int i = 0; i < propertyCount; i++)
    {
        // 获取Var
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        NSString *propertyType = [[NSString alloc] initWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
        
        Ivar iVar = class_getInstanceVariable([self class], [propertyName UTF8String]);
        if(iVar == nil)
        {
            // 采用另外一种方法尝试获取
            iVar = class_getInstanceVariable([self class], [[NSString stringWithFormat:@"_%@", propertyName] UTF8String]);
        }
        
        // 获取Name
        if((iVar != nil) && (![dictionaryJson isEqual:[NSNull null]]))
        {
            // 通过propertyName去Json中寻找Value
            id jsonValue = [dictionaryJson objectForKey:propertyName];
            
//#ifdef DEBUG
//            if ((jsonValue != nil && ([jsonValue isKindOfClass:[NSDictionary class]] || [jsonValue isKindOfClass:[NSMutableDictionary class]]))
//                || [propertyType hasPrefix:@"T@\"NSArray\""]
//                || [propertyType hasPrefix:@"T@\"NSMutableArray\""]
//                || ([propertyType rangeOfString:[NSString stringWithFormat:@",GQunarTestKey__%@", propertyName]].length > 0 && [propertyType rangeOfString:[NSString stringWithFormat:@",R,"]].length > 0))
//            {
//                
//            }
//            else if ([propertyType hasPrefix:@"T@\""] && jsonValue != nil)
//            {
//                // Debug
//                NSString *propertyClassName = [NSString stringWithFormat:@"%s", ivar_getTypeEncoding(iVar)];//NSStringFromClass(NSClassFromString(propertyType));
//                propertyClassName = [propertyClassName stringByReplacingOccurrencesOfString:@"@" withString:@""];
//                propertyClassName = [propertyClassName stringByReplacingOccurrencesOfString:@"\"" withString:@""];
//                Class propertyClass = NSClassFromString(propertyClassName);
//                if (![jsonValue isKindOfClass:propertyClass])
//                {
//                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@解析异常", className]
//                                                                        message:[NSString stringWithFormat:@"property:[%@:%@]\nJSon:[%@:%@]", propertyName, NSStringFromClass(propertyClass),propertyName, NSStringFromClass([jsonValue class])]
//                                                                       delegate:nil
//                                                              cancelButtonTitle:@"鄙视一下"
//                                                              otherButtonTitles:nil, nil];
//                    [alertView show];
//                    
//                }
//            }
//#endif
            
            if ([propertyType hasPrefix:@"T@\"NSString\""])
            {
                if (jsonValue != nil && ([jsonValue isKindOfClass:[NSString class]] || [jsonValue isKindOfClass:[NSMutableString class]]))
                {
                    object_setIvar(self, iVar, jsonValue);
                }
            }
            else if ([propertyType hasPrefix:@"T@\"NSMutableString\""])
            {
                if (jsonValue != nil && ([jsonValue isKindOfClass:[NSString class]] || [jsonValue isKindOfClass:[NSMutableString class]]))
                {
                    object_setIvar(self, iVar, jsonValue);
                }
            }
            else if ([propertyType hasPrefix:@"T@\"NSNumber\""])
            {
                if (jsonValue != nil && [jsonValue isKindOfClass:[NSNumber class]])
                {
                    object_setIvar(self, iVar, jsonValue);
                }
            }
            else if ([propertyType hasPrefix:@"T@\"NSArray\""] || [propertyType hasPrefix:@"T@\"NSMutableArray\""])
            {
                NSArray *arrayVarInfo = [propertyName componentsSeparatedByString:@"__Array__"];
                if ([arrayVarInfo count] == 2)
                {
                    NSString *keyValue = [arrayVarInfo objectAtIndex:0];
                    NSString *varClassName = [arrayVarInfo objectAtIndex:1];
                    
                    jsonValue = [dictionaryJson objectForKey:keyValue];
                    
                    if (jsonValue != nil && ([jsonValue isKindOfClass:[NSArray class]] || [jsonValue isKindOfClass:[NSMutableArray class]]))
                    {
                        NSMutableArray *arrayDest = [[NSMutableArray alloc] init];
                        
                        // 基本数据类型
                        if(([varClassName isEqualToString:@"NSString"]) || ([varClassName isEqualToString:@"NSNumber"]))
                        {
                            [arrayDest addObjectsFromArray:jsonValue];
                        }
                        else
                        {
                            Class varClass = NSClassFromString(varClassName);
                            
                            // 解析
                            NSInteger jsonCount = [jsonValue count];
                            for(NSInteger i = 0; i < jsonCount; i++)
                            {
                                NSDictionary *dictionaryJsonValue = [jsonValue objectAtIndex:i];
                                if(dictionaryJsonValue != nil)
                                {
                                    id varObject = [[varClass alloc] init];
                                    
                                    // 进行自定义解析
                                    if(varObject != nil)
                                    {
//                                        if ([varObject respondsToSelector:@selector(parseNetResult:forInfo:)])
//                                        {
//                                            [varObject parseNetResult:dictionaryJsonValue forInfo:customInfo];
//                                        }
//                                        // 递归进行下层解析
//                                        else
//                                        {
                                            [varObject parseJsonAutomatic:dictionaryJsonValue forInfo:customInfo];
//                                        }
                                        
                                        [arrayDest addObject:varObject];
                                    }
                                }
                            }
                        }
                        
                        // 赋值
                        object_setIvar(self, iVar, arrayDest);
                    }
                }
            }
            else if ([propertyType hasPrefix:@"T@\""])
            {
                if (jsonValue != nil && ([jsonValue isKindOfClass:[NSDictionary class]] || [jsonValue isKindOfClass:[NSMutableDictionary class]]))
                {
                    NSArray *arrayTypeInfo = [propertyType componentsSeparatedByString:@"\""];
                    if ([arrayTypeInfo count] > 2)
                    {
                        NSString *varClassName = [arrayTypeInfo objectAtIndex:1];
                        
                        // 创建对象
                        Class varClass = NSClassFromString(varClassName);
                        if (varClass != nil)
                        {
                            id varObject = [[varClass alloc] init];
                            
//                            // 进行自定义解析
//                            if((varObject != nil) && ([varObject respondsToSelector:@selector(parseNetResult:forInfo:)]))
//                            {
//                                [varObject parseNetResult:jsonValue forInfo:customInfo];
//                            }
//                            // 递归进行下层解析
//                            else
//                            {
                                [varObject parseJsonAutomatic:jsonValue forInfo:customInfo];
                           // }
                            
                            // 赋值
                            object_setIvar(self, iVar, varObject);
                        }
                    }
                }
            }
        }
    }
    
    free(properties);
}

// 自动解析JsonArray
+ (NSArray *)parseJsonArrayAutomatic:(NSArray *)arrayJson withObjectClass:(Class)objectClass forInfo:(id)customInfo
{
    // 如果Json数据无效,产生Sentry Json
    if(arrayJson == nil)
    {
        arrayJson = [[NSArray alloc] init];
    }
    
    NSMutableArray *arrayDest = [[NSMutableArray alloc] init];
    
    const char *cClassName = class_getName(objectClass);
    NSString *className = [NSString stringWithUTF8String:cClassName];
    
    // 基本数据类型
    if(([className isEqualToString:@"NSString"]) || ([className isEqualToString:@"NSNumber"]))
    {
        [arrayDest addObjectsFromArray:arrayJson];
    }
    else
    {
        // 解析
        NSInteger jsonCount = [arrayJson count];
        for(NSInteger i = 0; i < jsonCount; i++)
        {
            NSDictionary *dictionaryJson = [arrayJson objectAtIndex:i];
            if(dictionaryJson != nil)
            {
                id varObject = [[objectClass alloc] init];
                
                // 进行自定义解析
//                if((varObject != nil) && ([varObject respondsToSelector:@selector(parseNetResult:forInfo:)]))
//                {
//                    [varObject parseNetResult:dictionaryJson forInfo:customInfo];
//                }
//                // 递归进行下层解析
//                else
//                {
                    [varObject parseJsonAutomatic:dictionaryJson forInfo:customInfo];
               // }
                
                [arrayDest addObject:varObject];
            }
        }
    }
    
    return arrayDest;
}


@end
