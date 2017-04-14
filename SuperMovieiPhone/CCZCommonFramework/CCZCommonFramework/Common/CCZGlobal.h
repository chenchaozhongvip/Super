//
//  CCZGlobal.h
//  CCZFoundation
//
//  Created by chenchaozhong on 2017/4/12.
//  Copyright © 2017年 chenchaozhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface CCZGlobal : NSObject

+ (id<UIApplicationDelegate>)getAppDelegate;

+ (UITabBarController *)getRootViewController;

+ (UITabBar *)getTabbar;
@end
