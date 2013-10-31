//
//  SGPostTableViewCell.m
//  ALDynamicCellHeights
//
//  Created by Justin Williams on 10/30/13.
//  Copyright (c) 2013 Second Gear. All rights reserved.
//

#import "NSLayoutConstraint+SGExtensions.h"
#import "SGPostTableViewCell.h"
#import "SGPostBodyLabel.h"

static CGFloat const SGContentViewEdgePadding = 10.0f;
static CGFloat const SGUserAvatarSize = 48.0f;

@interface SGPostTableViewCell ()


@property (nonatomic, strong) NSArray *topPostConstraints;
@property (nonatomic, strong) NSArray *commentConstraints;
@property (nonatomic, strong) NSArray *nonmediaBottomConstraints;
@property (nonatomic, strong) NSArray *mediaThumbnailConstraints;
@property (nonatomic, strong) NSArray *nonmediaVerticalBodyPaddingConstraints;

@end

@implementation SGPostTableViewCell

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        [self setup];
        [self applyConstraints];
    }
    return self;
}

#pragma mark -
#pragma mark Dynamic Accessor Methods
// +--------------------------------------------------------------------
// | Dynamic Accessor Methods
// +--------------------------------------------------------------------

- (void)setThumbnail:(UIImage *)newThumbnail
{
    if (_thumbnail != newThumbnail)
    {
        if (_thumbnail != nil)
        {
            [self.contentView removeConstraints:self.mediaThumbnailConstraints];
        }
        
        _thumbnail = newThumbnail;
        
        if (self.thumbnail != nil)
        {
            if (self.nonmediaBottomConstraints != nil)
            {
                [self.contentView removeConstraints:self.nonmediaBottomConstraints];
            }
            
            _thumbnailImageView.image = _thumbnail;
            [self.contentView addConstraints:self.mediaThumbnailConstraints];
        }
        else
        {
            [self.contentView removeConstraints:self.mediaThumbnailConstraints];
        }
        
        [self removeUnnecessaryConstraintsIfAppropriate];
    }
}


- (NSArray *)nonmediaVerticalBodyPaddingConstraints
{
    if (_nonmediaVerticalBodyPaddingConstraints == nil)
    {
        // We want standard vertical padding between the body text and the comments label.
        _nonmediaVerticalBodyPaddingConstraints = @[[NSLayoutConstraint sg_constraintWithItem:self.readDetailsLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.bodyLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:SGContentViewEdgePadding priority:UILayoutPriorityRequired]];
    }
    
    return _nonmediaVerticalBodyPaddingConstraints;
}

- (void)setNonmediaBottomConstraints:(NSArray *)nonmediaBottomConstraints
{
    if (_nonmediaBottomConstraints != nonmediaBottomConstraints)
    {
        if (_nonmediaBottomConstraints != nil)
        {
            [self.contentView removeConstraints:_nonmediaBottomConstraints];
        }
        
        _nonmediaBottomConstraints = nonmediaBottomConstraints;
        
        if (_nonmediaBottomConstraints != nil)
        {
            [self.contentView addConstraints:_nonmediaBottomConstraints];
        }
        else
        {
            [self.contentView setNeedsUpdateConstraints];
        }
    }
}

#pragma mark -
#pragma mark Auto Layout
// +--------------------------------------------------------------------
// | Auto Layout
// +--------------------------------------------------------------------

- (NSDictionary *)viewsDictionary
{
    NSMutableDictionary *keysDictionary = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                            @"avatar" : self.avatarImageView,
                                                                                            @"username" : self.userNameLabel,
                                                                                            @"date" : self.dateLabel,
                                                                                            @"body" : self.bodyLabel,
                                                                                            @"media" : self.thumbnailImageView,
                                                                                            @"comments" : self.readDetailsLabel
                                                                                            }];
    return keysDictionary;
}

- (void)addCommentConstraints
{
    // We swap the hugging priorities so that the date label maintains its position and the
    // name label fills out the remaining space.
    [self.userNameLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.dateLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    // Remove unneeded constraints, add new ones. These are all defined in applyConstraints
    [self.contentView removeConstraints:self.topPostConstraints];
    [self.contentView addConstraints:self.commentConstraints];
}

- (void)addTopPostConstraints
{
    
    // The inverse of the other part of this branch.
    [self.userNameLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.dateLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView removeConstraints:self.commentConstraints];
    [self.contentView addConstraints:self.topPostConstraints];
}


- (void)removeUnnecessaryConstraintsIfAppropriate
{
    // There's no media, so it's a plain old post with a body of text and maybe some replies.
    if ((self.thumbnail == nil))
    {
        NSMutableArray *constraints = [[NSMutableArray alloc] init];
        [constraints addObjectsFromArray:self.nonmediaVerticalBodyPaddingConstraints];
        
        self.nonmediaBottomConstraints = constraints;
        [self.contentView removeConstraints:self.mediaThumbnailConstraints];
        [self.contentView addConstraints:self.nonmediaBottomConstraints];
    }
    else
    {
        self.nonmediaBottomConstraints = nil;
    }
}

- (void)configureAvatarConstraints
{
    // Avatar should be SGUserAvatarSize wide.
    NSLayoutConstraint *avatarWidthConstraint = [NSLayoutConstraint sg_constraintWithItem:self.avatarImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:SGUserAvatarSize priority:UILayoutPriorityRequired];
    [self.contentView addConstraint:avatarWidthConstraint];
    
    // Avatar should be SGUserAvatarSize tall.
    NSLayoutConstraint *avatarHeightConstraint = [NSLayoutConstraint sg_constraintWithItem:self.avatarImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:SGUserAvatarSize priority:UILayoutPriorityRequired];
    [self.contentView addConstraint:avatarHeightConstraint];
    
    // We want to pin the image view to be 10 points off the top of its parent view.
    NSLayoutConstraint *avatarTopPaddingConstraint = [NSLayoutConstraint constraintWithItem:self.avatarImageView
                                                                                  attribute:NSLayoutAttributeTop
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:self.contentView
                                                                                  attribute:NSLayoutAttributeTop
                                                                                 multiplier:1.0f
                                                                                   constant:SGContentViewEdgePadding];
    [self.contentView addConstraint:avatarTopPaddingConstraint];
}

- (void)updateCommentSpecificConstraints
{
    if (self.commentConstraints == nil)
    {
        NSMutableArray *constraints = [[NSMutableArray alloc] init];
        
        NSDictionary *metrics = @{ @"padding" : @(SGContentViewEdgePadding) };
        // ================================================================
        // Comment-Post Specific Constraints
        // ================================================================
        
        // We want to align the tops of of the avatar, display name and date.
        // We are also saying they should be next to each other with default padding between them.
        // The date should be up against the edge of the contentView
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[username]-[date]-[avatar]-(padding)-|" options:NSLayoutFormatAlignAllTop metrics:metrics views:[self viewsDictionary]]];
        
        self.commentConstraints = constraints;
    }
}

- (void)updateTopPostConstraints
{
    if (self.topPostConstraints == nil)
    {
        NSMutableArray *constraints = [[NSMutableArray alloc] init];
        // ================================================================
        // Root-Post Specific Constraints
        // ================================================================
        
        // If a post, we want the left side of the avatar to have GBUserAvatarEdgePadding padding from its
        // content view's left side.
        NSLayoutConstraint *avatarPinnedAsPostConstraint = [NSLayoutConstraint constraintWithItem:self.avatarImageView
                                                                                        attribute:NSLayoutAttributeLeft
                                                                                        relatedBy:NSLayoutRelationEqual
                                                                                           toItem:self.contentView
                                                                                        attribute:NSLayoutAttributeLeft
                                                                                       multiplier:1.0f
                                                                                         constant:SGContentViewEdgePadding];
        [constraints addObject:avatarPinnedAsPostConstraint];
        
        NSDictionary *metrics = @{ @"padding" : @(SGContentViewEdgePadding) };
        // We want to align the tops of of the avatar, display name and date.
        // We are also saying they should be next to each other with default padding between them.
        // The date should be up against the edge of the contentView
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[avatar]-[username]-[date]-(padding)-|" options:NSLayoutFormatAlignAllTop metrics:metrics views:[self viewsDictionary]]];
        
        self.topPostConstraints = constraints;
    }
}

- (void)configureNameAndDateLabelConstraints
{
    [self.contentView addConstraint:[NSLayoutConstraint sg_constraintWithItem:self.userNameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.avatarImageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0 priority:UILayoutPriorityRequired]];
    [self.contentView addConstraint:[NSLayoutConstraint sg_constraintWithItem:self.userNameLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.avatarImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0 priority:UILayoutPriorityRequired]];
    
    [self.contentView addConstraint:[NSLayoutConstraint sg_constraintWithItem:self.dateLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.userNameLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:0 priority:UILayoutPriorityRequired]];
    [self.contentView addConstraint:[NSLayoutConstraint sg_constraintWithItem:self.dateLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.userNameLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0 priority:UILayoutPriorityRequired]];
    
}

- (void)configureBodyTextConstraints
{
    // The left of the body text should be aligned to the left of the user name label.
    [self.contentView addConstraint:[NSLayoutConstraint sg_constraintWithItem:self.bodyLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.userNameLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0 priority:UILayoutPriorityRequired]];
    
    // There should be standard vertical spacing between the username label and the top of the body text.
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[username]-[body]" options:0 metrics:0 views:[self viewsDictionary]]];
    
    // There should be 10 points of padding from the right edge of the body text from its superview.
    [self.contentView addConstraint:[NSLayoutConstraint sg_constraintWithItem:self.bodyLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.dateLabel attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0 priority:UILayoutPriorityRequired]];
}

- (void)configureCommentLabelConstraints
{
    // We want the leading edge of the read comments label to be equal to the leading edge of the body text label.
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.readDetailsLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.bodyLabel attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.readDetailsLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.bodyLabel attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    [self setNonmediaBottomConstraints:self.nonmediaVerticalBodyPaddingConstraints];
}

- (void)updateMediaAttachmentConstraints
{
    if (self.mediaThumbnailConstraints == nil)
    {
        NSMutableArray *constraints = [[NSMutableArray alloc] init];
        
        // We want to pin the left edge of the media attachment thumbnail to the leading edge of the body label.
        [constraints addObject:[NSLayoutConstraint sg_constraintWithItem:self.thumbnailImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.bodyLabel attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0 priority:UILayoutPriorityRequired]];
        
        // We want the right edge of the file attachment thumbnail to be 10 points off the edge of its superview.
        [constraints addObject:[NSLayoutConstraint sg_constraintWithItem:self.thumbnailImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.bodyLabel attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0 priority:UILayoutPriorityRequired]];
        
        // If we have media, we want to have standard vertical spacing between the body, the thumbnail, and the comments label.
        [constraints addObject:[NSLayoutConstraint sg_constraintWithItem:self.thumbnailImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.bodyLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:SGContentViewEdgePadding priority:UILayoutPriorityRequired]];
        [constraints addObject:[NSLayoutConstraint sg_constraintWithItem:self.readDetailsLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.thumbnailImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:SGContentViewEdgePadding*2 priority:UILayoutPriorityDefaultHigh]];
        
        
        // We want the bottom of the content view to be greater than or equal to
        // the bottom of the comment label.
        NSLayoutConstraint *commentPaddingConstraint = [NSLayoutConstraint sg_constraintWithItem:self.contentView
                                                                                       attribute:NSLayoutAttributeBottom
                                                                                       relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                                          toItem:self.readDetailsLabel
                                                                                       attribute:NSLayoutAttributeBottom
                                                                                      multiplier:1.0f
                                                                                        constant:SGContentViewEdgePadding
                                                                                        priority:UILayoutPriorityDefaultLow];
        
        
        [constraints addObject:commentPaddingConstraint];
        
        self.mediaThumbnailConstraints = constraints;
    }
}

- (void)applyConstraints
{
    [self.contentView removeConstraints:self.contentView.constraints];
    
    [self configureAvatarConstraints];
    [self configureNameAndDateLabelConstraints];
    [self configureBodyTextConstraints];
    [self configureCommentLabelConstraints];
    [self updateMediaAttachmentConstraints];
    
    // We want the bottom of the content view to be greater than or equal to
    // the bottom of the comment label.
    NSLayoutConstraint *commentPaddingConstraint = [NSLayoutConstraint sg_constraintWithItem:self.contentView
                                                                                   attribute:NSLayoutAttributeBottom
                                                                                   relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                                      toItem:self.readDetailsLabel
                                                                                   attribute:NSLayoutAttributeBottom
                                                                                  multiplier:1.0f
                                                                                    constant:SGContentViewEdgePadding
                                                                                    priority:UILayoutPriorityDefaultLow];
    [self.contentView addConstraint:commentPaddingConstraint];
    
    [self updateTopPostConstraints];
    [self updateCommentSpecificConstraints];
    
    // Default state is a top-post.
    [self addTopPostConstraints];
}

#pragma mark -
#pragma mark Private/Convenience Methods
// +--------------------------------------------------------------------
// | Private/Convenience Methods
// +--------------------------------------------------------------------

- (void)setup
{
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.contentMode = UIViewContentModeRedraw;
    
    
    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.avatarImageView.restorationIdentifier = NSStringFromSelector(@selector(avatarImageView));
    self.avatarImageView.clipsToBounds = YES;
    [self.avatarImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.avatarImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addSubview:self.avatarImageView];
    
    self.userNameLabel = [[UILabel alloc] init];
    self.userNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.userNameLabel.restorationIdentifier = NSStringFromSelector(@selector(userNameLabel));
    self.userNameLabel.textColor = [UIColor blackColor];
    self.userNameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.userNameLabel.numberOfLines = 1;
    [self.userNameLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.contentView addSubview:self.userNameLabel];
    
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.dateLabel.restorationIdentifier = NSStringFromSelector(@selector(dateLabel));
    self.dateLabel.textColor = [UIColor lightGrayColor];
    self.dateLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    self.dateLabel.numberOfLines = 1;
    [self.dateLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addSubview:self.dateLabel];
    
    self.thumbnailImageView = [[UIImageView alloc] init];
    self.thumbnailImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.thumbnailImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    self.thumbnailImageView.restorationIdentifier = NSStringFromSelector(@selector(thumbnailImageView));
    [self.contentView addSubview:self.thumbnailImageView];
    self.thumbnailImageView.backgroundColor = [UIColor whiteColor];
    self.thumbnailImageView.contentMode = UIViewContentModeRedraw;
    
    self.bodyLabel = [SGPostBodyLabel new];
    self.bodyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.bodyLabel.restorationIdentifier = NSStringFromSelector(@selector(bodyLabel));
    self.bodyLabel.numberOfLines = 0;
    self.bodyLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.bodyLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.bodyLabel];
    
    
    self.readDetailsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.readDetailsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.readDetailsLabel.restorationIdentifier = NSStringFromSelector(@selector(readDetailsLabel));
    self.readDetailsLabel.hidden = YES;
    self.readDetailsLabel.textColor = [UIColor grayColor];
    self.readDetailsLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.readDetailsLabel.numberOfLines = 1;
    self.readDetailsLabel.backgroundColor = self.contentView.backgroundColor;
    [self.contentView addSubview:self.readDetailsLabel];
}

@end
