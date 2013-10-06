//
//  SGViewController.m
//  AutoLayout
//
//  Created by Justin Williams on 5/6/13.
//  Copyright (c) 2013 Second Gear. All rights reserved.
//

#import "SGViewController.h"

@interface SGViewController ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *shortButton;
@property (nonatomic, strong) UIButton *mediumButton;
@property (nonatomic, strong) UIButton *largeButton;

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
    
    [self.view addSubview:self.containerView];
    
    [self.containerView addSubview:self.shortButton];
    [self.containerView addSubview:self.mediumButton];
    [self.containerView addSubview:self.largeButton];
    
    // We want the container to be the width of the superview, with standard spacing.
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[container]-|" options:0 metrics:Nil views:[self viewsDictionary]]];
    
    // Setting a fixed height of 100pt for the container
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:100]];
    
    
    // Vertically centering our container view
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
    
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[top]-[center]-[bottom]|" options:0 metrics:nil views:[self viewsDictionary]]];

    
    // Take a look at these values.
    // They are determinining which of the views in our three boxes will get to dominate
    // how much space is used when laying them out.
    
    // Try adjusting them between UILayoutPriorityRequired, UILayoutPriorityDefaultLow and
    // UILayoutPriorityDefaultHigh and see what effects it has on the layout of the buttons
    // in the container view.
    [self.shortButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.mediumButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.largeButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    
}

#pragma mark -
#pragma mark Dynamic Accessor Methods
// +--------------------------------------------------------------------
// | Dynamic Accessor Methods
// +--------------------------------------------------------------------


- (UIView *)containerView
{
    if (_containerView == nil)
    {
        _containerView = [UIView new];
        
        // jww: This tells Auto Layout to handle all the layout stuff.
        _containerView.translatesAutoresizingMaskIntoConstraints = NO;
        _containerView.backgroundColor = [UIColor blackColor];
        
    }
    return _containerView;
}

- (UIButton *)shortButton
{
    if (_shortButton == nil)
    {
        _shortButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        // jww: This tells Auto Layout to handle all the layout stuff.
        _shortButton.translatesAutoresizingMaskIntoConstraints = NO;
        _shortButton.backgroundColor = [UIColor redColor];
        [_shortButton setTitle:@"Short Button" forState:UIControlStateNormal];
        _shortButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _shortButton;
}

- (UIButton *)mediumButton
{
    if (_mediumButton == nil)
    {
        _mediumButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        // jww: This tells Auto Layout to handle all the layout stuff.
        _mediumButton.translatesAutoresizingMaskIntoConstraints = NO;
        _mediumButton.backgroundColor = [UIColor whiteColor];
        [_mediumButton setTitle:@"This is a medium button" forState:UIControlStateNormal];
        _mediumButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _mediumButton;
}

- (UIButton *)largeButton
{
    if (_largeButton == nil)
    {
        _largeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        // jww: This tells Auto Layout to handle all the layout stuff.
        _largeButton.translatesAutoresizingMaskIntoConstraints = NO;
        _largeButton.backgroundColor = [UIColor blueColor];
        [_largeButton setTitle:@"This is a really really really long button" forState:UIControlStateNormal];
        _largeButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _largeButton;
}

#pragma mark -
#pragma mark Private/Convenience Methods
// +--------------------------------------------------------------------
// | Private/Convenience Methods
// +--------------------------------------------------------------------

- (NSDictionary *)viewsDictionary
{
    return @{
            @"container" : self.containerView,
            @"top" : self.shortButton,
            @"center" : self.mediumButton,
            @"bottom" : self.largeButton
            };
    
}

@end
