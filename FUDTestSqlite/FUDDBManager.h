//
//  FUDDBManager.h
//  FUDTestSqlite
//
//  Created by 兰福东 on 2019/1/24.
//  Copyright © 2019 兰福东. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FUDCity;
@class FUDPerson;

@interface FUDDBManager : NSObject

@property (nonatomic, copy, readonly) NSString *name;

+ (instancetype)defaultManager;
- (instancetype)initWithName:(nonnull NSString *)name;

- (BOOL)createCityTable;
- (BOOL)addCity:(FUDCity *)city;
- (FUDCity *)queryCity:(NSInteger)cityID;
- (NSArray<FUDCity *> *)queryAllCities;

- (BOOL)createPersonTable;
- (BOOL)addPerson:(FUDPerson *)person;
- (BOOL)deletePerson:(NSInteger)personID;
- (BOOL)updatePerson:(FUDPerson *)person;
- (NSArray<FUDPerson *> *)queryAllPersons;

@end
