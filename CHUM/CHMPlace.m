//
//  CHMPlace.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 11/02/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMPlace.h"

@implementation CHMPlace


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.city = @"";
        self.tags = @[];
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[CHMPlace class]]) {
        return NO;
    }
    
    return [self.placeID isEqualToString:[object placeID]];
}

- (NSUInteger)hash {
    return [[self placeID] hash];
}

@end
