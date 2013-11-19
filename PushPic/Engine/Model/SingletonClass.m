//
//  SingletonClass.m
//  Cariloop
//
//  Created by Wony Shin on 08/22/13.
//  Copyright 2013 Satori Inc. All rights reserved.
//

#import "SingletonClass.h"

@implementation SingletonClass


static SingletonClass *sharedInstance = nil;

// Get the shared instance and create it if necessary.
+ (SingletonClass *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

// We can still have a regular init method, that will get called the first time the Singleton is used.
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


// We don't want to allocate a new instance, so return the current one.
+ (id)allocWithZone:(NSZone*)zone {
    return [self sharedInstance];
}

// Equally, we don't want to generate multiple copies of the singleton.
- (id)copyWithZone:(NSZone *)zone {
    return self;
}

@end
