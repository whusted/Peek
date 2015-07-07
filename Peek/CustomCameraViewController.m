//
//  CustomCameraViewController.m
//  Peek
//
//  Created by Willy Husted on 7/7/15.
//  Copyright (c) 2015 Willy Husted. All rights reserved.
//

#import "CustomCameraViewController.h"

@interface CustomCameraViewController ()

@end

@implementation CustomCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Tapped");
    // TODO: on tap, take picture
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

-(void) viewDidAppear: (BOOL)animated {
    [super viewDidAppear:animated];
}
@end
