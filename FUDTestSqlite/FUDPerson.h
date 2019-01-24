//
//  FUDPerson.h
//  FUDTestSqlite
//
//  Created by 兰福东 on 2019/1/24.
//  Copyright © 2019 兰福东. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FUDCity;

NS_ASSUME_NONNULL_BEGIN

@interface FUDPerson : NSObject

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) FUDCity *city;

@end

NS_ASSUME_NONNULL_END
