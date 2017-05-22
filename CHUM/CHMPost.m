//
//  CHMPost.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 06/01/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMPost.h"
#import "CHMPostHelper.h"
#import "CHMPlace.h"
#import "CHMLocationManager.h"


@implementation CHMPost

- (NSMutableArray *)comments {
    if(!_comments) {
        _comments = [NSMutableArray array];
    }
    return _comments;
}


- (NSInteger)countOfComments {
    if(self.comments.count > 0) {
        return self.comments.count;
    }
    if(self.commentCount) {
        return self.commentCount.integerValue;
    }
    
    return 0;
}

- (NSString *)locationText {
    if(self.place.placeName ) {
        return self.place.placeName;
    } else {
        
        NSNumber *dist = self.distance;
        
        
        if (!dist) {
            return nil;
        }
        
        if (dist.floatValue < 0) {
            return NSLocalizedString(@"Рядом", @"post");
        }
        
        float d = dist.floatValue;
        
        NSString *placeText = [NSString stringWithFormat:@"%.02fкм",d/1000];
        
        return placeText;
    }
}

+ (CHMPost *)emptyPost {
    return [CHMPostHelper emptyPost];
}

- (CHMPlace *)place {
    if(!_place) {
        _place = [[CHMPlace alloc] init];
    }
    return _place;
}


- (CHMPlace *)location {//redo
    
    if(!_location) {
        _location = [[CHMPlace alloc] init];
    }
    
    return _location;
}


- (CHMPlace *)locationPlace {
    if (self.place.lat && self.place.lon) {
        return self.place;
    } else if (self.location.lat && self.location.lon) {
        return self.location;
    } else {
        return nil;
    }
    
}


@end
