//
//  SGViewController.m
//  ALDynamicCellHeights
//
//  Created by Justin Williams on 10/30/13.
//  Copyright (c) 2013 Second Gear. All rights reserved.
//

#import "SGViewController.h"
#import "SGPostTableViewCell.h"
#import "SGADNClient.h"
#import "SGADNPost.h"

static NSString * const kPostCellReuseIdentifier = @"kPostCellReuseIdentifier";

static void *kKVOContextPosts = &kKVOContextPosts;


@interface SGViewController ()
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SGADNClient *apiClient;
@property (readwrite, nonatomic) SGPostTableViewCell *metricsCell;
@property (nonatomic, readwrite) NSMutableDictionary *cellHeights;
@end

@implementation SGViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.apiClient = [[SGADNClient alloc] init];
        [self.apiClient addObserver:self forKeyPath:NSStringFromSelector(@selector(posts)) options:NSKeyValueObservingOptionNew context:kKVOContextPosts];

        
    }
    return self;
}

- (void)dealloc
{
    [self.apiClient removeObserver:self forKeyPath:NSStringFromSelector(@selector(posts)) context:kKVOContextPosts];
}

#pragma mark -
#pragma mark KVO Methods
// +--------------------------------------------------------------------
// | KVO Methods
// +--------------------------------------------------------------------

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kKVOContextPosts)
    {
        [self refreshTable];
    }
}

#pragma mark -
#pragma mark View Lifecycle Methods
// +--------------------------------------------------------------------
// | View Lifecycle Methods
// +--------------------------------------------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Class tableCellClass = [SGPostTableViewCell class];
    [self.tableView registerClass:tableCellClass forCellReuseIdentifier:kPostCellReuseIdentifier];
    
    // @kongtomorrow
    // This metrics cell is what I am using to do all my cell height calculations against.
    // I hide it and add it to the tableview.
    self.metricsCell = [[tableCellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
	self.metricsCell.hidden = YES;
    
	[self.tableView addSubview:self.metricsCell];

}

#pragma mark -
#pragma mark UITableViewDataSource Methods
// +--------------------------------------------------------------------
// | UITableViewDataSource Methods
// +--------------------------------------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.apiClient posts] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SGPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPostCellReuseIdentifier forIndexPath:indexPath];
    
    SGADNPost *post = [self.apiClient.posts objectAtIndex:indexPath.row];
    [self updateCell:cell withPost:post];
    
    return cell;
}

- (void)updateCell:(SGPostTableViewCell *)cell withPost:(SGADNPost *)post
{
    // We are faking this because I don't want to abuse ADN's bandwidth.
    // And I am vain and want you to see my face.
    cell.avatarImageView.image = [UIImage imageNamed:@"Me"];
    cell.userNameLabel.text = post.userName;
    cell.dateLabel.text = @"Just now";
    cell.bodyLabel.text = post.postText;
    
    // We are faking this because I don't want to abuse ADN's bandwidth.
    if (post.hasThumbnail)
    {
        cell.thumbnail = [UIImage imageNamed:@"SampleImage"];
    }
    
}

#pragma mark -
#pragma mark UITableViewDelegate Methods
// +--------------------------------------------------------------------
// | UITableViewDelegate Methods
// +--------------------------------------------------------------------

- (CGFloat)estimatedHeightForPost:(SGADNPost *)post
{
    BOOL hasMediaAttachment = post.hasThumbnail;
    CGFloat avatarHeight = 48.0f;
    CGFloat emoteViewHeightEstimate = 20.0f;
    
    NSDictionary *bodyTextAttributes = @{ NSFontAttributeName : self.metricsCell.bodyLabel.font };
    CGFloat bodyTextHeightEstimate = [post.postText sizeWithAttributes:bodyTextAttributes].height;
    CGFloat fileAttachmentHeightEstimate = 0.0f;
    
    CGFloat imageAttachmentHeightEstimate = 0.0f;
    if (hasMediaAttachment == YES)
    {
        imageAttachmentHeightEstimate = post.thumbnailHeight;
    }
    
    // We have a comment label.
    CGFloat commentLabelHeight = 0.0;
    if ((post.numberOfReplies > 0) || (post.numberOfReposts > 0) || (post.numberOfStars > 0))
    {
        NSDictionary *commentLabelAttributes = @{ NSFontAttributeName : self.metricsCell.readDetailsLabel.font };
        
        commentLabelHeight = [@"1 Comment" sizeWithAttributes:commentLabelAttributes].height;
    }
    
    CGFloat estimate = avatarHeight + emoteViewHeightEstimate + bodyTextHeightEstimate + fileAttachmentHeightEstimate + imageAttachmentHeightEstimate + commentLabelHeight;
    
    return estimate;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [NSString stringWithFormat:@"%ld-%ld", indexPath.section, indexPath.row];
    if ([self.cellHeights objectForKey:key] != nil)
    {
        return [self.cellHeights[key] floatValue];
    }
    
    SGADNPost *post = self.apiClient.posts[indexPath.row];
    CGFloat estimate = [self estimatedHeightForPost:post];
    
    self.cellHeights[key] = @(estimate);
    
    return estimate;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    SGADNPost *post = self.apiClient.posts[indexPath.row];
    if (post == nil)
    {
        return 0.0f;
    }
    
    // THis updates all the values like on the metrics cell and fires off relevant KVO things in
    // GBStatusTableViewCell and GBTimelineTableViewCell.
    [self updateCell:self.metricsCell withPost:post];
    [self.metricsCell.contentView updateConstraintsIfNeeded];
    [self.metricsCell.contentView layoutIfNeeded];
    
    
    // And figure out our size.
    CGSize layoutSize = [self.metricsCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return layoutSize.height;
}

#pragma mark -
#pragma mark Private/Convenience Methods
// +--------------------------------------------------------------------
// | Private/Convenience Methods
// +--------------------------------------------------------------------

- (void)refreshTable
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}

@end
