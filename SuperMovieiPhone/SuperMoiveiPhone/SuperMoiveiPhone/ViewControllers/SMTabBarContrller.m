//
//  SMTabBarContrller.m
//  SuperMoiveIphone
//
//  Created by chenchaozhong on 2017/4/12.
//  Copyright © 2017年 chenchaozhong. All rights reserved.
//

#import "SMTabBarContrller.h"
//r#import <CCZThirdParty/JSONKit.h>

@interface SMTabBarContrller ()

@property (nonatomic, strong) NSArray *VCData;

@end

@implementation SMTabBarContrller


#pragma mark - init

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *vcs = [NSMutableArray array];
    
    for (SMTabbarItemModel *model in self.VCData) {
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:model.ItemTitle image:[UIImage imageNamed:model.ItemImageNormal] selectedImage:[UIImage imageNamed:model.ItemImageSelect]];
        CCZBaseViewController *vc = [[NSClassFromString(model.VCName) alloc] init];
        CCZBaseNavigationController *nav = [[CCZBaseNavigationController alloc] initWithRootViewController:vc];
        nav.tabBarItem = item;
        [vcs addObject:nav];
    }
    
    self.viewControllers = vcs;
}

#pragma mark - Setter & Getter
- (NSArray *)VCData
{
    if (!_VCData) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"vcjson" ofType:@"json"];
        NSString *json = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSDictionary *dic = [json objectFromJSONString];
        SMViewContllersModel *model = [[SMViewContllersModel alloc] init];
        [model parseJsonAutomatic:dic forInfo:nil];
        _VCData = model.vcs;
    }
    return _VCData;
}
#pragma mark - Target Mehtods

#pragma mark - Public Method

#pragma mark - Private Method

#pragma mark - Notification Method

#pragma mark - UITableView Delegate &Datasource

#pragma mark - Other Delegate
@end
