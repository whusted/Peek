//
//  SignupViewController.h
//  Peek
//
//  Created by Willy Husted on 6/3/14.
//  Copyright (c) 2014 Willy Husted. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

- (IBAction)signup:(id)sender;
- (IBAction)dismiss:(id)sender;

@end
