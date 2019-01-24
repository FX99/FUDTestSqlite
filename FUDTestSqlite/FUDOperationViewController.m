//
//  FUDOperationViewController.m
//  FUDTestSqlite
//
//  Created by 兰福东 on 2019/1/24.
//  Copyright © 2019 兰福东. All rights reserved.
//

#import "FUDOperationViewController.h"
#import "FUDPersonsViewController.h"
#import "FUDDBManager.h"
#import "FUDPerson.h"
#import "FUDCity.h"

@interface FUDOperationViewController ()

@property (nonatomic, strong) FUDDBManager *dbManager;

@property (weak, nonatomic) IBOutlet UITextField *personIDField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *ageField;
@property (weak, nonatomic) IBOutlet UITextField *cityIDField;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation FUDOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dbManager = [[FUDDBManager alloc] init];
    if ([self.dbManager createCityTable]) {
        self.messageLabel.text = @"创建城市表成功！\n";
    } else {
        self.messageLabel.text = @"创建城市表失败！\n";
    }
    if ([self.dbManager createPersonTable]) {
        self.messageLabel.text = [self.messageLabel.text stringByAppendingString:@"创建人员表成功！\n"];
    } else {
        self.messageLabel.text = [self.messageLabel.text stringByAppendingString:@"创建人员表失败！\n"];
    }
    
    FUDCity *city1 = [FUDCity new];
    city1.cityID = 1;
    city1.name = @"北京";
    [self.dbManager addCity:city1];
    
    FUDCity *city2 = [FUDCity new];
    city2.cityID = 2;
    city2.name = @"罗马";
    [self.dbManager addCity:city2];
    
    FUDCity *city3 = [FUDCity new];
    city3.cityID = 3;
    city3.name = @"纽约";
    [self.dbManager addCity:city3];
}

- (IBAction)addButtonAction:(id)sender {
    FUDPerson *person = [FUDPerson new];
    person.ID = self.personIDField.text.integerValue;
    person.name = self.nameField.text;
    person.age = self.ageField.text.integerValue;
    person.city = [FUDCity new];
    person.city.cityID = self.cityIDField.text.integerValue;
    
    if ([self.dbManager addPerson:person]) {
        self.messageLabel.text = @"添加 Person 成功！";
    } else {
        self.messageLabel.text = @"添加 Person 失败！";
    }
}

- (IBAction)updateButtonAction:(id)sender {
    FUDPerson *person = [FUDPerson new];
    person.ID = self.personIDField.text.integerValue;
    person.name = self.nameField.text;
    person.age = self.ageField.text.integerValue;
    person.city = [FUDCity new];
    person.city.cityID = self.cityIDField.text.integerValue;
    
    if ([self.dbManager updatePerson:person]) {
        self.messageLabel.text = @"更新 Person 成功！";
    } else {
        self.messageLabel.text = @"更新 Person 失败！";
    }
}

- (IBAction)retrieveButtonAction:(id)sender {
    NSArray *persons = [self.dbManager queryAllPersons];
    if (persons) {
        FUDPersonsViewController *personsVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FUDPersonsViewController"];
        personsVC.persons = persons;
        [self.navigationController pushViewController:personsVC animated:YES];
        self.messageLabel.text = @"查询人员信息成功！";
    } else {
        self.messageLabel.text = @"查询人员信息失败！";
    }
}

- (IBAction)deleteButtonAction:(id)sender {
    NSInteger personID = self.personIDField.text.integerValue;
    
    if ([self.dbManager deletePerson:personID]) {
        self.messageLabel.text = @"删除 Person 成功！";
    } else {
        self.messageLabel.text = @"删除 Person 失败！";
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.nameField resignFirstResponder];
    [self.personIDField resignFirstResponder];
    [self.ageField resignFirstResponder];
    [self.cityIDField resignFirstResponder];
}

@end
