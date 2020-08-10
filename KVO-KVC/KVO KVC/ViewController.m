//
//  ViewController.m
//  KVO KVC Demo
//
//  Created by Paul Solt on 4/9/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

#import "ViewController.h"
#import "LSIDepartment.h"
#import "LSIEmployee.h"
#import "LSIHRController.h"


@interface ViewController ()

@property (nonatomic) LSIHRController *hrController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    LSIDepartment *marketing = [[LSIDepartment alloc] init];
    marketing.name = @"Marketing";
    LSIEmployee *philSchiller = [[LSIEmployee alloc] init];
    philSchiller.name = @"Phil";
    philSchiller.jobTitle = @"VP of Marketing";
    philSchiller.salary = 10000000; 
    marketing.manager = philSchiller;

    
    LSIDepartment *engineering = [[LSIDepartment alloc] init];
    engineering.name = @"Engineering";
    LSIEmployee *craig = [[LSIEmployee alloc] init];
    craig.name = @"Craig";
    craig.salary = 9000000;
    craig.jobTitle = @"Head of Software";
    engineering.manager = craig;
    
    LSIEmployee *e1 = [[LSIEmployee alloc] init];
    e1.name = @"Chad";
    e1.jobTitle = @"Engineer";
    e1.salary = 200000;
    
    LSIEmployee *e2 = [[LSIEmployee alloc] init];
    e2.name = @"Lance";
    e2.jobTitle = @"Engineer";
    e2.salary = 250000;
    
    LSIEmployee *e3 = [[LSIEmployee alloc] init];
    e3.name = @"Joe";
    e3.jobTitle = @"Marketing Designer";
    e3.salary = 100000;
    
    [engineering addEmployee:e1];
    [engineering addEmployee:e2];
    [marketing addEmployee:e3];

    LSIHRController *controller = [[LSIHRController alloc] init];
    [controller addDepartment:engineering];
    [controller addDepartment:marketing];
    self.hrController = controller;
    
//    NSString *key = @"privateName";
//
//    [craig setValue:@"Hair Force One" forKey:key];
//
//    NSString *value = [craig valueForKey:key]; // Can't use craig.privateName
//    NSLog(@"value for key `%@`: %@", key, value);
//
//    value = [philSchiller valueForKey:key];
//    NSLog(@"before: %@: %@", key, value);
//    [philSchiller setValue:@"Apple Fellow" forKey:key];
//    value = [philSchiller valueForKey:key];
//    NSLog(@"after: %@: %@", key, value);
    
//    NSString *keyPath = @"manager.name";
//    NSString *value = [marketing valueForKeyPath:keyPath];
//    NSLog(@"Manager's name: %@", value);
    
    [marketing addEmployee:craig];
    
    NSLog(@"%@", self.hrController);
    
    NSString *keyPath = @"departments.@distinctUnionOfArrays.employees";
    NSArray *allEmployees = [self.hrController valueForKeyPath:keyPath];
    NSLog(@"Employee names: %@", allEmployees);
    
    [marketing setValue:@(75000) forKeyPath:@"manager.salary"];
    
    NSLog(@"Average Salary: %@", [allEmployees valueForKeyPath:@"@avg.salary"]);
    NSLog(@"Max Salary: %@", [allEmployees valueForKeyPath:@"@max.salary"]);
    NSLog(@"Min Salary: %@", [allEmployees valueForKeyPath:@"@min.salary"]);
    NSLog(@"Number of Salaries: %@", [allEmployees valueForKeyPath:@"@count.salary"]);
    
    @try {
        NSArray *directSalaries = [self valueForKeyPath:@"hrController.departments.@unionOfArrays.employees.salary"];
        NSLog(@"Direct Salaries: %@", directSalaries);
    } @catch (NSException *exception) {
        NSLog(@"Got an exception: %@", exception);
    }
    
    NSSortDescriptor *nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSSortDescriptor *salarySortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"salary" ascending:NO];
    
    [marketing setValue:@"Joe" forKeyPath:@"manager.name"];
    
    NSArray *sortedEmployees = [allEmployees sortedArrayUsingDescriptors:@[nameSortDescriptor, salarySortDescriptor]];
    NSLog(@"Sorted: %@", sortedEmployees);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", @"Joe"];
    NSArray *filteredEmployees = [allEmployees filteredArrayUsingPredicate:predicate];
    NSLog(@"Filtered: %@", filteredEmployees);
}


@end
