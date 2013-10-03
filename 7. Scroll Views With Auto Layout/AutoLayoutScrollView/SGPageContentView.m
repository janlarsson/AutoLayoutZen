//
//  SGPageContentView.m
//  AutoLayoutScrollView
//
//  Created by Justin Williams on 10/3/13.
//  Copyright (c) 2013 Second Gear. All rights reserved.
//

#import "SGPageContentView.h"

@implementation SGPageContentView

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (instancetype)initWithColor:(UIColor *)color
{
    if (self = [super initWithFrame:CGRectZero])
    {
        self.backgroundColor = color;
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

// This is pretty hacky, but the good stuff is in SGViewController.
- (CGSize)intrinsicContentSize
{
    return [[UIScreen mainScreen] bounds].size;
}

@end
