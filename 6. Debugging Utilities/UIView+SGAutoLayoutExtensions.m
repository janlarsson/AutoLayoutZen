//
//  UIView+SGAutoLayoutExtensions.m
//  SecondGearKit
//
//  Created by Justin Williams on 11/11/12.
//  Copyright (c) 2013 Second Gear. All rights reserved.
//


#import <objc/objc-runtime.h>
#import "UIView+SGAutoLayoutExtensions.h"
#import "NSLayoutConstraint+SGExtensions.h"

@implementation UIView (SGAutoLayoutExtensions)

+ (instancetype)autolayoutView
{
    UIView *view = [[self alloc] initWithFrame:CGRectZero];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}

#ifdef DEBUG

- (NSString *)nsli_description {
    return [self restorationIdentifier] ?: [NSString stringWithFormat:@"%@:%p", [self class], self];
}

- (BOOL)nsli_descriptionIncludesPointer {
    return [self restorationIdentifier] == nil;
}

- (NSString *)sg_description
{
    // Evil!
    NSString *string = [self performSelector:@selector(nsli_description)];

    if (self.restorationIdentifier != nil)
    {
        return [string stringByAppendingFormat:@" (%@)", self.restorationIdentifier];
    }

    return string;
}
#endif

@end
