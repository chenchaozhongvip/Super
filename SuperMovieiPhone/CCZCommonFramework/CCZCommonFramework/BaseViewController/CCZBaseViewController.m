//
//  CCZBaseViewController.m
//  CCZGUI
//
//  Created by chenchaozhong on 2017/4/12.
//  Copyright © 2017年 chenchaozhong. All rights reserved.
//

#import "CCZBaseViewController.h"

@interface CCZBaseViewController ()

@end

@implementation CCZBaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self isKindOfClass:NSClassFromString(kSMMyVCName)] || [self isKindOfClass:NSClassFromString(kSMRecommdVCName)] || [self isKindOfClass:NSClassFromString(kSMDownloadVCName)]) {
        [CCZGlobal getTabbar].hidden = NO;    } else {
        [CCZGlobal getTabbar].hidden = YES;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [CCZGlobal getTabbar].hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
