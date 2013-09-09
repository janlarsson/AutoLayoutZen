//
//  SGViewController.m
//  OldSchool
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
    
    CGFloat width = roundf(self.view.frame.size.width / 2);
    CGFloat height = roundf(self.view.frame.size.height / 4);
    CGFloat centeredX = roundf((self.view.frame.size.width - width) / 2);
    CGFloat centeredY = roundf((self.view.frame.size.height - height) / 2);
    self.centeredView.frame = (CGRect) { { centeredX, centeredY }, { width, height } };
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
        _centeredView.backgroundColor = [UIColor orangeColor];
        
    }
    return _centeredView;
}

@end
