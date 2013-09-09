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

@property (nonatomic, strong) NSLayoutConstraint *centeredWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *centeredHeightConstraint;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, assign, getter = isZoomed) BOOL zoomed;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    [self.view addSubview:self.centeredView];
    [self.view addSubview:self.button];
    
    // Establishing the width to be half the view width
    self.centeredWidthConstraint = [NSLayoutConstraint constraintWithItem:self.centeredView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.5 constant:1.0];
    [self.view addConstraint:self.centeredWidthConstraint];
    
    // Establishing the height to be 25% of the view height
    self.centeredHeightConstraint = [NSLayoutConstraint constraintWithItem:self.centeredView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.25 constant:1.0];
    [self.view addConstraint:self.centeredHeightConstraint];
    
    // We want our view to be centered horizontally
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.centeredView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    // We want our view to be centered vertically
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.centeredView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
    // Align our button along the bottom
    NSDictionary *views = @{ @"button" : self.button };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(==100)]-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button(==44)]-|" options:0 metrics:nil views:views]];
}

#pragma mark -
#pragma mark Instance Methods
// +--------------------------------------------------------------------
// | Instance Methods
// +--------------------------------------------------------------------

- (void)moo:(id)sender
{
    CGFloat constant = 1.0f;
    if (self.isZoomed == NO)
    {
        constant = 100.0f;
    }
    
    self.centeredHeightConstraint.constant = constant;
    self.centeredWidthConstraint.constant = constant;
    [UIView animateWithDuration:0.1f animations:^{
        [self.centeredView layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.zoomed = !self.isZoomed;
    }];
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

- (UIButton *)button
{
    if (_button == nil)
    {
        _button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _button.translatesAutoresizingMaskIntoConstraints = NO;
        [_button setTitle:@"Moo" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(moo:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

@end
