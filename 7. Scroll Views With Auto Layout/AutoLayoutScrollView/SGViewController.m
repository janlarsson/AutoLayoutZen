//
//  SGViewController.m
//  AutoLayoutScrollView
//
//  Created by Justin Williams on 10/3/13.
//  Copyright (c) 2013 Second Gear. All rights reserved.
//

#import "SGViewController.h"
#import "SGPageContentView.h"

@interface SGViewController ()
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@end

@implementation SGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *colors = @[
                        [UIColor redColor],
                        [UIColor lightGrayColor],
                        [UIColor brownColor],
                        [UIColor yellowColor],
                        [UIColor blackColor],
                        [UIColor greenColor],
                        [UIColor grayColor],
                        [UIColor purpleColor],
                        [UIColor blueColor],
                        [UIColor orangeColor]
                        ];
    
    
    SGPageContentView *previous = nil;
    
    for (NSInteger i = 0 ; i < 10 ; i++)
    {
        SGPageContentView *newContentView = [[SGPageContentView alloc] initWithColor:colors[i]];
        [self.scrollView addSubview:newContentView];
        
        NSDictionary *views = @{ @"cv" : newContentView };
        if (previous == nil) // first!
        {
            // Set the first one to be pinned to the left edge.
            [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[cv]" options:0 metrics:nil views:views]];
        }
        else
        {
            // Pin subsequent views to the right edge of the previous view.
            [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:newContentView
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:previous
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1.0
                                                                         constant:0]];
        }
        
        // The height should be full-size.
        [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[cv]|" options:0 metrics:nil views:views]];

        previous = newContentView;
    }
    
    // We need to make sure we add these last constraints to define the bottom and right edges
    // This is what actually sets the contentSize when using auto layout.
    [self.scrollView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[cv]|"
                                             options:0
                                             metrics:nil
                                               views:@{ @"cv" : previous }]];

    [self.scrollView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[cv]|"
                                             options:0
                                             metrics:nil
                                               views:@{ @"cv" : previous }]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
