//
//  NSLayoutConstraint+SGExtensions.m
//  SecondGearKit
//
//  Created by Justin Williams on 11/11/12.
//  Copyright (c) 2013 Second Gear. All rights reserved.
//

#import "NSLayoutConstraint+SGExtensions.h"

@implementation NSLayoutConstraint (SGExtensions)

+ (id)sg_constraintWithItem:(id)view1
                   attribute:(NSLayoutAttribute)attr1
                   relatedBy:(NSLayoutRelation)relation
                      toItem:(id)view2
                   attribute:(NSLayoutAttribute)attr2
                  multiplier:(CGFloat)multiplier
                    constant:(CGFloat)constant
                    priority:(UILayoutPriority)priority {

    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view1
                                                                  attribute:attr1
                                                                  relatedBy:relation
                                                                     toItem:view2
                                                                  attribute:attr2
                                                                 multiplier:multiplier
                                                                   constant:constant];
    constraint.priority = priority;

    return constraint;
}

#ifdef DEBUG

- (NSString *)sg_description
{
    // Swizzle this instead so you don't lose the good idea.
    // There's a private method to override.
    NSString *description = [self description];

    return [description stringByAppendingFormat:@"(%@, %@)",
            [self.firstItem restorationIdentifier],
            [self.secondItem restorationIdentifier]];
}

#endif


@end
