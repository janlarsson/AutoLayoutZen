//
//  SGPostTableViewCell.h
//  ALDynamicCellHeights
//
//  Created by Justin Williams on 10/30/13.
//  Copyright (c) 2013 Second Gear. All rights reserved.
//

@import UIKit;

@interface SGPostTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImage *thumbnail;

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *bodyLabel;
@property (nonatomic, strong) UIImageView *thumbnailImageView;
@property (nonatomic, strong) UILabel *readDetailsLabel;

@end
