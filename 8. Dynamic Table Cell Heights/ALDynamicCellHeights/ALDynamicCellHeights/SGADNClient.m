//
//  SGADNClient.m
//  ALDynamicCellHeights
//
//  Created by Justin Williams on 10/30/13.
//  Copyright (c) 2013 Second Gear. All rights reserved.
//

#import "SGADNClient.h"
#import "SGADNPost.h"

@interface SGADNClient ()
@property (nonatomic, strong) NSArray *posts;
@property (nonatomic, strong) NSURLSession *session;
@end

@implementation SGADNClient

- (instancetype)init
{
    if (self = [super init])
    {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:config];

        [self fetchData];
        
    }
    return self;
}

- (void)fetchData
{
    [self startActivityIndicator];
    
    NSURL *publicTimelineURL = [NSURL URLWithString:@"https://alpha-api.app.net/stream/0/posts/stream/global"];

    __weak __typeof(self) bSelf = self;
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:publicTimelineURL
                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                     if (error == nil)
                                                     {
                                                         [bSelf handleResponse:response withData:data];
                                                     }
                                                     else
                                                     {
                                                         [bSelf handleError:error];
                                                     }
                                                     
                }];
    

    [dataTask resume];
}

- (void)handleResponse:(NSURLResponse *)response withData:(NSData *)data
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    if (httpResponse.statusCode == 200) // OK!
    {
        NSError *jsonError;
        
        NSDictionary *postsJSON = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:NSJSONReadingAllowFragments
                                                                    error:&jsonError];
        
        NSMutableArray *postsReturned = [[NSMutableArray alloc] init];
        
        if (jsonError == nil)
        {
            NSArray *contentsOfRootDirectory = postsJSON[@"data"];
            
            for (NSDictionary *data in contentsOfRootDirectory)
            {
                SGADNPost *newPost = [[SGADNPost alloc] initWithJSONData:data];
                [postsReturned addObject:newPost];
            }
            
            self.posts = postsReturned;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stopActivityIndicator];
            });
        }
    }
}

- (void)handleError:(NSError *)error
{
    // Ideally you'd handle this better than I am.
    NSLog(@"error: %@", error);
}

#pragma mark -
#pragma mark Private/Convenience Methods
// +--------------------------------------------------------------------
// | Private/Convenience Methods
// +--------------------------------------------------------------------

- (void)startActivityIndicator
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)stopActivityIndicator
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
