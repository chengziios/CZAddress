//
//  CZAddressSelectView.h
//  PQD
//
//  Created by 程健 on 2017/9/16.
//  Copyright © 2017年 程健. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYKit.h>

@interface CZAddressSelectModel : NSObject
@property (nonatomic, strong) NSString * region_id;
@property (nonatomic, strong) NSString * region_name;
@property (nonatomic, strong) NSArray <CZAddressSelectModel *> * children;
@end

@interface CZAddressSelectModels : NSObject
@property (nonatomic, strong) NSArray <CZAddressSelectModel *> * items;
@end



typedef void (^CZAddressSelectViewWithComplete)(CZAddressSelectModel *province,CZAddressSelectModel *city,CZAddressSelectModel *district);

@interface CZAddressSelectView : UIView
+(void)showWithComplete:(CZAddressSelectViewWithComplete)complete
               province:(NSString *)province
                   city:(NSString *)city
               district:(NSString *)district;
+(NSArray *)addressDatas;
@end




