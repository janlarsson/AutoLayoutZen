//
//  SGViewController.m
//  AutoLayout
//
//  Created by Justin Williams on 5/6/13.
//  Copyright (c) 2013 Second Gear. All rights reserved.
//

#import "SGViewController.h"

@interface SGViewController ()

@property (nonatomic, strong) UILabel *topView;
@property (nonatomic, strong) UIView *centeredView;
@property (nonatomic, strong) UILabel *bottomView;

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
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.centeredView];
    [self.view addSubview:self.bottomView];
    
    NSDictionary *views = @{
                            @"top" : self.topView,
                            @"center" : self.centeredView,
                            @"bottom" : self.bottomView
                            };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[top(>=20@900,<=100@900)]-[center(>=75@1000,<=2000@1000)]-[bottom(>=20@900,<=100@900)]-|" options:0 metrics:nil views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[top(==40)]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[center(==40)]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottom(==40)]|" options:0 metrics:nil views:views]];
}

#pragma mark -
#pragma mark Dynamic Accessor Methods
// +--------------------------------------------------------------------
// | Dynamic Accessor Methods
// +--------------------------------------------------------------------

- (UILabel *)topView
{
    if (_topView == nil)
    {
        _topView = [[UILabel alloc] initWithFrame:CGRectZero];
        
        // jww: This tells Auto Layout to handle all the layout stuff.
        _topView.translatesAutoresizingMaskIntoConstraints = NO;
        _topView.backgroundColor = [UIColor redColor];
        _topView.text = @"00:00";
        
    }
    return _topView;
}

- (UIView *)centeredView
{
    if (_centeredView == nil)
    {
        _centeredView = [[UIView alloc] initWithFrame:CGRectZero];
        
        // jww: This tells Auto Layout to handle all the layout stuff.
        _centeredView.translatesAutoresizingMaskIntoConstraints = NO;
        _centeredView.backgroundColor = [UIColor whiteColor];
        
    }
    return _centeredView;
}

- (UILabel *)bottomView
{
    if (_bottomView == nil)
    {
        _bottomView = [[UILabel alloc] initWithFrame:CGRectZero];
        
        // jww: This tells Auto Layout to handle all the layout stuff.
        _bottomView.translatesAutoresizingMaskIntoConstraints = NO;
        _bottomView.backgroundColor = [UIColor blueColor];
        _bottomView.text = @"00:00";
    }
    return _bottomView;
}


@end
