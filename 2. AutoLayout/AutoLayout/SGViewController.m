//
//  SGViewController.m
//  AutoLayout
//
//  Created by Justin Williams on 5/6/13.
//  Copyright (c) 2013 Second Gear. All rights reserved.
//

#import "SGViewController.h"

@interface SGViewController ()

@property (nonatomic, strong) UIView *centeredView;

@end

@implementation SGViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        
    }
    
    return self;
}

#pragma mark -
#pragma mark View Lifecyle
// +--------------------------------------------------------------------
// | View Lifecyle
// +--------------------------------------------------------------------

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkGrayColor];
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self.view addSubview:self.centeredView];
    
    CGFloat width = [[UIScreen mainScreen] applicationFrame].size.width / 2;
    CGFloat height = [[UIScreen mainScreen] applicationFrame].size.height / 4;
    NSDictionary *views = @{ @"view" : self.centeredView };
    NSDictionary *metrics = @{
                              @"halfViewWidth" : @(width),
                              @"halfViewHeight" : @(height)
                             };
    
    // Establishing the width to be half the view width
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[view(>=halfViewWidth)]" options:0 metrics:metrics views:views]];
    
    // Establishing the height to be half the view height.
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(==halfViewHeight)]" options:0 metrics:metrics views:views]];
    
    // We want our view to be centered horizontally
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.centeredView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    // We want our view to be centered vertically
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.centeredView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
}

#pragma mark -
#pragma mark Dynamic Accessor Methods
// +--------------------------------------------------------------------
// | Dynamic Accessor Methods
// +--------------------------------------------------------------------

- (UIView *)centeredView
{
    if (_centeredView == nil)
    {
        _centeredView = [[UIView alloc] initWithFrame:CGRectZero];
        
        // jww: This tells Auto Layout to handle all the layout stuff.
        _centeredView.translatesAutoresizingMaskIntoConstraints = NO;
        _centeredView.backgroundColor = [UIColor orangeColor];
        
    }
    return _centeredView;
}


@end
