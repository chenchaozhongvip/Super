//
//  SMTabbarItemModel.h
//  CCZDataModel
//
//  Created by chenchaozhong on 2017/4/12.
//  Copyright © 2017年 chenchaozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCZBaseObject.h"
#import <CCZCommonFramework/NSObject+CCZUtility.h>

@class SMTabbarItemModel;

@interface SMViewContllersModel : CCZBaseObject

@property (nonatomic, strong, getter=vcs) NSArray *CCZParserArray(viewContrllers,SMTabbarItemModel);

@end

@interface SMTabbarItemModel : CCZBaseObject

@property (nonatomic, strong) NSString *VCName;
@property (nonatomic, strong) NSString *ItemImageNormal;
@property (nonatomic, strong) NSString *ItemImageSelect;
@property (nonatomic, strong) NSNumber *ItemTag;
@property (nonatomic, strong) NSString *ItemTitle;

@end
