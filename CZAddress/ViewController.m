//
//  ViewController.m
//  CZAddress
//
//  Created by 程健 on 2017/9/19.
//  Copyright © 2017年 程健. All rights reserved.
//

#import "ViewController.h"
#import "CZAddressSelectView.h"

@interface ViewController ()
@property(nonatomic,strong)CZAddressSelectModel *province;
@property(nonatomic,strong)CZAddressSelectModel *city;
@property(nonatomic,strong)CZAddressSelectModel *district;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)click
{
    __weak typeof(self)weakSelf = self;
    [CZAddressSelectView showWithComplete:^(CZAddressSelectModel *province, CZAddressSelectModel *city, CZAddressSelectModel *district) {
        
        typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.province = province;
        strongSelf.city = city;
        strongSelf.district = district;
        
        strongSelf.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@",province.region_name,city.region_name,district.region_name];
        
    } province:self.province.region_id city:self.city.region_id district:self.district.region_id];
}

@end
