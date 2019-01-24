//
//  FUDPersonsViewController.m
//  FUDTestSqlite
//
//  Created by 兰福东 on 2019/1/24.
//  Copyright © 2019 兰福东. All rights reserved.
//

#import "FUDPersonsViewController.h"
#import "FUDPerson.h"
#import "FUDCity.h"

@interface FUDPersonsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FUDPersonsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.persons) {
        return self.persons.count;
    } else {
        return self.cities.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    if (self.persons) {
        FUDPerson *person = self.persons[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"姓名：%@，年龄：%@", person.name, @(person.age)];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"所在城市：%@", person.city.name];
    } else {
        FUDCity *city = self.cities[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"城市编号：%@，城市名称：%@", @(city.cityID), city.name];
    }
    
    return cell;
}

@end
