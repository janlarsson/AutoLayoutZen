//
//  SGADNPost.m
//  ALDynamicCellHeights
//
//  Created by Justin Williams on 10/30/13.
//  Copyright (c) 2013 Second Gear. All rights reserved.
//

#import "SGADNPost.h"

@implementation SGADNPost

- (instancetype)initWithJSONData:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        NSDictionary *userDict = dictionary[@"user"];
        
        self.userName = userDict[@"name"];
        
        NSURL *avatarURL  = userDict[@"url"];        
        NSDictionary *avatarDict = userDict[@"avatar_image"];
        self.avatarImage = nil;
        self.avatarWidth = [avatarDict[@"width"] floatValue];
        self.avatarWidth = [avatarDict[@"height"] floatValue];
        
        // 2013-08-09T06:35:59Z
        self.postDate = dictionary[@"created_at"];
        
        self.postText = dictionary[@"text"];
        self.numberOfReplies = [dictionary[@"num_replies"] unsignedIntegerValue];
        self.numberOfReposts = [dictionary[@"num_reposts"] unsignedIntegerValue];
        self.numberOfStars = [dictionary[@"num_stars"] unsignedIntegerValue];
        
        self.hasThumbnail = arc4random_uniform(2);
        
    }
    
    return self;
}

@end
