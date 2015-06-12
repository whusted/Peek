//
//  InboxViewController.h
//  Peek
//
//  Created by Willy Husted on 6/3/14.
//  Copyright (c) 2014 Willy Husted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MediaPlayer/MediaPlayer.h>

@interface InboxViewController : UITableViewController

@property (nonatomic, strong) NSArray *messages;
@property (nonatomic, strong) PFObject *selectedMessage;
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

- (IBAction)logout:(id)sender;
@end
