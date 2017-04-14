//
//  CCZGlobal.m
//  CCZFoundation
//
//  Created by chenchaozhong on 2017/4/12.
//  Copyright © 2017年 chenchaozhong. All rights reserved.
//

#import "CCZGlobal.h"

@implementation CCZGlobal

+ (id<UIApplicationDelegate>)getAppDelegate
{
    return [UIApplication sharedApplication].delegate;
}

+ (UITabBarController *)getRootViewController
{
    id<UIApplicationDelegate> appdelegate = [CCZGlobal getAppDelegate];
    if (appdelegate) {
        return (UITabBarController *)appdelegate.window.rootViewController;
    }
    
    return nil;
}

+ (UITabBar *)getTabbar;
{
    return [CCZGlobal getRootViewController].tabBar;
}
@end
