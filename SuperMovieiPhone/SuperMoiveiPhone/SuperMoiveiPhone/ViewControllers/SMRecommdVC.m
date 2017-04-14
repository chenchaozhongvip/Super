//
//  SMRecommdVC.m
//  SuperMoiveiPhone
//
//  Created by chenchaozhong on 2017/4/12.
//  Copyright © 2017年 chenchaozhong. All rights reserved.
//

#import "SMRecommdVC.h"

@interface SMRecommdVC ()

@end

@implementation SMRecommdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(didclick)];
    [self.navigationItem setRightBarButtonItem:item] ;
    
    
}
- (void)didclick
{
    CCZBaseViewController *vc = [CCZBaseViewController new];
    vc.view.backgroundColor = [UIColor redColor];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
