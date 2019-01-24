//
//  FUDDBManager.m
//  FUDTestSqlite
//
//  Created by 兰福东 on 2019/1/24.
//  Copyright © 2019 兰福东. All rights reserved.
//

#import "FUDDBManager.h"
#import "FUDPerson.h"
#import "FUDCity.h"
#import <sqlite3.h>

static NSString * const kDBNameDefault = @"FUDDBNameDefault";
static NSString * const kCityIDKey = @"id";
static NSString * const kCityNameKey = @"name";
static NSString * const kCityTableDefault = @"t_cityTableDefault";
static NSString * const kPersonIDKey = @"id";
static NSString * const kPersonNameKey = @"name";
static NSString * const kPersonAgeKey = @"age";
static NSString * const kPersonCityIDkey = @"cityID";
static NSString * const kPersonTableDefault = @"t_personTableDefault";

@interface FUDDBManager ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *dbPath;
@property (nonatomic, assign) sqlite3 *db;

@end

@implementation FUDDBManager

- (instancetype)initWithName:(nonnull NSString *)name {
    self = [super init];
    if (self) {
        _name = name.copy;
        
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        self.dbPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", _name]];
        
        [self _openDB];
    }
    return self;
}

- (instancetype)init {
    return [[FUDDBManager alloc] initWithName:kDBNameDefault];
}

- (BOOL)createCityTable {
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ (%@ integer primary key, %@ text);", kCityTableDefault, kCityIDKey, kCityNameKey];
    return [self _executeSql:sql];
}

- (BOOL)addCity:(FUDCity *)city {
    NSString *sql = [NSString stringWithFormat:@"insert into %@ (%@, %@) values (%@, '%@');", kCityTableDefault, kCityIDKey, kCityNameKey, @(city.cityID), city.name];
    return [self _executeSql:sql];
}

- (FUDCity *)queryCity:(NSInteger)cityID {
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@=%@;", kCityTableDefault, kCityIDKey, @(cityID)];
    sqlite3_stmt *stmt = NULL;
    
    int result = sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        FUDCity *city = [FUDCity new];
        city.cityID = cityID;
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            city.name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
        }
        if (city.name.length == 0) {
            city.name = @"未知";
        }
        
        return city;
    } else {
        return nil;
    }
}

- (BOOL)createPersonTable {
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ (%@ integer priamry key, %@ text, %@ integer, %@ integer);", kPersonTableDefault, kPersonIDKey, kPersonNameKey, kPersonAgeKey, kPersonCityIDkey];
    return [self _executeSql:sql];
}

- (BOOL)addPerson:(FUDPerson *)person {
    NSString *sql = [NSString stringWithFormat:@"insert into %@ (%@, %@, %@, %@) values (%@, '%@', %@, %@);", kPersonTableDefault, kPersonIDKey, kPersonNameKey, kPersonAgeKey, kPersonCityIDkey, @(person.ID), person.name, @(person.age), @(person.city.cityID)];
    return [self _executeSql:sql];
}

- (BOOL)deletePerson:(NSInteger)personID {
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@=%@;", kPersonTableDefault, kPersonIDKey, @(personID)];
    return [self _executeSql:sql];
}

- (BOOL)updatePerson:(FUDPerson *)person {
    NSString *sql = [NSString stringWithFormat:@"update %@ set %@='%@', %@=%@, %@=%@ where %@=%@;", kPersonTableDefault, kPersonNameKey, person.name, kPersonAgeKey, @(person.age), kPersonCityIDkey, @(person.city.cityID), kPersonIDKey, @(person.ID)];
    return [self _executeSql:sql];
}

- (NSArray<FUDPerson *> *)queryAllPersons {
    NSString *sql = [NSString stringWithFormat:@"select * from %@;", kPersonTableDefault];
    sqlite3_stmt *stmt = NULL;
    
    int result = sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        NSMutableArray *temp = [NSMutableArray array];
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            FUDPerson *person = [FUDPerson new];
            person.ID = sqlite3_column_int(stmt, 0);
            person.name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            person.age = sqlite3_column_int(stmt, 2);
            NSInteger cityID = sqlite3_column_int(stmt, 3);
            person.city = [self queryCity:cityID];
            [temp addObject:person];
        }
        
        return temp.copy;
    } else {
        return nil;
    }
}

- (BOOL)_openDB {
    if (self.db) return YES;
    
    int result = sqlite3_open(self.dbPath.UTF8String, &(_db));
    if (result == SQLITE_OK) {
        return YES;
    } else {
        _db = nil;
        return NO;
    }
}

- (BOOL)_executeSql:(NSString *)sql {
    if (sql.length == 0) return NO;
    if (![self _openDB]) return NO;
    
    char *error;
    int result = sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &error);
    if (result == SQLITE_OK) {
        return YES;
    } else {
        return NO;
    }
}

@end
