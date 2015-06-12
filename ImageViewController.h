//
//  ImageViewController.h
//  Peek
//
//  Created by Willy Husted on 6/10/14.
//  Copyright (c) 2014 Willy Husted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ImageViewController : UIViewController

@property (nonatomic, strong) PFObject *message;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
