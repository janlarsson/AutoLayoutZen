//
//  NSLayoutConstraint+SGExtensions.h
//  SecondGearKit
//
//  Created by Justin Williams on 11/11/12.
//  Copyright (c) 2013 Second Gear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSLayoutConstraint (SGExtensions)

+ (id)sg_constraintWithItem:(id)view1
               attribute:(NSLayoutAttribute)attribute1
               relatedBy:(NSLayoutRelation)relation
                  toItem:(id)view2
               attribute:(NSLayoutAttribute)attribute2
              multiplier:(CGFloat)multiplier
                constant:(CGFloat)constant
                priority:(UILayoutPriority)priority;

@end
