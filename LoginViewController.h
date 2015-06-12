//
//  LoginViewController.h
//  Peek
//
//  Created by Willy Husted on 6/3/14.
//  Copyright (c) 2014 Willy Husted. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

- (IBAction)login:(id)sender;
@end
