//
//  MyOperation.m
//  TestOperation_objc
//
//  Created by Paul Solt on 3/25/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

#import "MyOperation.h"


// Resources
// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/KeyValueObserving/Articles/KVOCompliance.html#//apple_ref/doc/uid/20002178-SW1


@interface MyOperation()

@property (nonatomic) BOOL internalFinished;

@end

@implementation MyOperation

- (void)start {
    self.internalFinished = false; // Sends a KVO notification
    NSLog(@"Start");
    
    // Do work ...
    
    self.internalFinished = true; // Sends a KVO notification
}

- (BOOL)isFinished {
    return _internalFinished;
}

// Dependent keys
+ (NSSet<NSString *> *)keyPathsForValuesAffectingFinished {
    return [NSSet setWithObjects:@"internalFinished", nil];
}

//KVO-compliant
- (void)setInternalFinished:(BOOL)internalFinished {
    if (internalFinished != _internalFinished) { // Prevent unnecessary notifications
        
        [self willChangeValueForKey:@"finished"]; // notify
        [self willChangeValueForKey:@"internalFinished"]; // notify
        
        _internalFinished = internalFinished;
        
        [self didChangeValueForKey:@"internalFinished"]; // notify
        [self didChangeValueForKey:@"finished"]; // notify
    }
}

// Disable automatic change notifications (manual control)
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    BOOL automatic = YES;
    if ([key isEqualToString:@"internalFinished"]) {
        automatic = NO;
    } else {
        automatic = [super automaticallyNotifiesObserversForKey:key];
    }
    return automatic;
}



@end
