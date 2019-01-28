//
//  FUDPersonsViewController.h
//  FUDTestSqlite
//
//  Created by 兰福东 on 2019/1/24.
//  Copyright © 2019 兰福东. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FUDPerson;
@class FUDCity;

NS_ASSUME_NONNULL_BEGIN

@interface FUDPersonsViewController : UIViewController

@property (nonatomic, strong) NSMutableArray<FUDPerson *> *persons;
@property (nonatomic, copy) NSArray<FUDCity *> *cities;

@end

NS_ASSUME_NONNULL_END
