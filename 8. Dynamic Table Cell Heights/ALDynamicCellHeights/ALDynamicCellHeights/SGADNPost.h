//
//  SGADNPost.h
//  ALDynamicCellHeights
//
//  Created by Justin Williams on 10/30/13.
//  Copyright (c) 2013 Second Gear. All rights reserved.
//

@import Foundation;

@interface SGADNPost : NSObject

@property (nonatomic, strong) UIImage *avatarImage;
@property (nonatomic, assign) CGFloat avatarWidth;
@property (nonatomic, assign) CGFloat avatarHeight;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSDate *postDate;
@property (nonatomic, strong) NSString *postText;
@property (nonatomic, strong) UIImage *thumbnailImage; // If image attached.
@property (nonatomic, assign) CGFloat thumbnailHeight;
@property (nonatomic, assign) BOOL hasThumbnail;
@property (nonatomic, assign) NSUInteger numberOfReplies;
@property (nonatomic, assign) NSUInteger numberOfReposts;
@property (nonatomic, assign) NSUInteger numberOfStars;

- (instancetype)initWithJSONData:(NSDictionary *)dictionary;

@end
