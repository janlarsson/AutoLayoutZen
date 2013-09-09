//
//  SGViewController.m
//  AutoLayout
//
//  Created by Justin Williams on 5/6/13.
//  Copyright (c) 2013 Second Gear. All rights reserved.
//

#import "SGViewController.h"

@interface SGViewController ()

@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;

@property (nonatomic, strong) UIView *spacer1;
@property (nonatomic, strong) UIView *spacer2;

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
    
    [self.view addSubview:self.label1];
    [self.view addSubview:self.spacer1];
    [self.view addSubview:self.label2];
    [self.view addSubview:self.spacer2];
    [self.view addSubview:self.label3];
    
    NSDictionary *views =   @{
                              @"label1" : self.label1,
                              @"label2" : self.label2,
                              @"label3" : self.label3,
                              @"spacer1" : self.spacer1,
                              @"spacer2" : self.spacer2
                              };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[label1][spacer1(>=0)][label2][spacer2(==spacer1)][label3]-10-|" options:NSLayoutFormatAlignAllTop metrics:nil views:views]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.label1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];

    // Not really necessary
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[spacer1(==44)]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[spacer2(==44)]" options:0 metrics:nil views:views]];

}

#pragma mark -
#pragma mark Dynamic Accessor Methods
// +--------------------------------------------------------------------
// | Dynamic Accessor Methods
// +--------------------------------------------------------------------

- (UILabel *)label1
{
    if (_label1 == nil)
    {
        _label1 = [[UILabel alloc] initWithFrame:CGRectZero];
        _label1.translatesAutoresizingMaskIntoConstraints = NO;
        _label1.numberOfLines = 0;
        _label1.text = @"ABC";
        _label1.font = [UIFont fontWithName:@"Avenir-Medium" size:14.0f];
        _label1.textColor = [UIColor whiteColor];
        _label1.backgroundColor = [UIColor purpleColor];
    }
    
    return _label1;
}

- (UILabel *)label2
{
    if (_label2 == nil)
    {
        _label2 = [[UILabel alloc] initWithFrame:CGRectZero];
        _label2.translatesAutoresizingMaskIntoConstraints = NO;
        _label2.numberOfLines = 0;
        _label2.text = @"Really Long String Of Text";
        _label2.font = [UIFont fontWithName:@"Avenir-Medium" size:14.0f];
        _label2.textColor = [UIColor blackColor];
        _label2.backgroundColor = [UIColor yellowColor];
    }
    
    return _label2;
}

- (UILabel *)label3
{
    if (_label3 == nil)
    {
        _label3 = [[UILabel alloc] initWithFrame:CGRectZero];
        _label3.translatesAutoresizingMaskIntoConstraints = NO;
        _label3.numberOfLines = 0;
        _label3.text = @"Medium Text";
        _label3.font = [UIFont fontWithName:@"Avenir-Medium" size:14.0f];
        _label3.textColor = [UIColor whiteColor];
        _label3.backgroundColor = [UIColor blueColor];
    }
    
    return _label3;
}

- (UIView *)spacer1
{
    if (_spacer1 == nil)
    {
        _spacer1 = [[UIView alloc] initWithFrame:CGRectZero];
        
        // jww: This tells Auto Layout to handle all the layout stuff.
        _spacer1.translatesAutoresizingMaskIntoConstraints = NO;
        _spacer1.backgroundColor = [UIColor blackColor];
        
    }
    return _spacer1;
}

- (UIView *)spacer2
{
    if (_spacer2 == nil)
    {
        _spacer2 = [[UIView alloc] initWithFrame:CGRectZero];
        
        // jww: This tells Auto Layout to handle all the layout stuff.
        _spacer2.translatesAutoresizingMaskIntoConstraints = NO;
        _spacer2.backgroundColor = [UIColor blackColor];
        
    }
    return _spacer2;
}

@end
