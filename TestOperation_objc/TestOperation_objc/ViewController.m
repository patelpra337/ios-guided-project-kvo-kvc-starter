//
//  ViewController.m
//  TestOperation_objc
//
//  Created by Paul Solt on 3/25/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

#import "ViewController.h"
#import "MyOperation.h"

@interface ViewController ()

@property NSOperationQueue *queue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.queue = [[NSOperationQueue alloc] init];
    
    MyOperation *myOp = [[MyOperation alloc] init];
    
    [myOp addObserver:self forKeyPath:@"finished" options:0 context:nil];
    
    [self.queue addOperation:myOp];
    
    // FUTURE: Try listening for the queue to be finished with all operations
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"finished"]) {
        NSLog(@"%@ = %@", keyPath, [object valueForKeyPath:keyPath]);
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
