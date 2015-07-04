//
//  CameraViewController.m
//  Peek
//
//  Created by Willy Husted on 6/9/14.
//  Copyright (c) 2014 Willy Husted. All rights reserved.
//

#import "CameraViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "MSCellAccessory.h"
#import "DZNPhotoPickerController.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

UIColor *disclosureColor;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.recipients = [[NSMutableArray alloc] init];
    disclosureColor = [UIColor colorWithRed:0.353 green:0.659 blue:0.788 alpha:1];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];

    PFQuery *query = [self.friendsRelation query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        } else {
            self.friends = objects;
            [self.tableView reloadData];
        }
    }];
    
    if (self.image == nil && [self.videoFilePath length] == 0) {
        self.picker = [[UIImagePickerController alloc] init];
        self.picker.allowsEditing = NO;
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.picker.showsCameraControls = NO;
        self.picker.delegate = self;
        
        // Thanks to http://stackoverflow.com/users/1486261/daspianist for the transforms and scales
        CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 71.0);
        self.picker.cameraViewTransform = translate;
        
        CGAffineTransform scale = CGAffineTransformScale(translate, 1.333333, 1.333333);
        self.picker.cameraViewTransform = scale;
        
        //TODO: Modularize code and add custom overlay with cancel button and "click anywhere" message
        
        [self presentViewController:self.picker animated:NO completion:NULL];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdenitier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdenitier forIndexPath:indexPath];
    
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    if ([self.recipients containsObject:user.objectId]) {
        cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK color:disclosureColor];
    } else {
        cell.accessoryView = nil;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    if (cell.accessoryView == nil) {
        cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK color:disclosureColor];
        [self.recipients addObject:user.objectId];
    } else {
        cell.accessoryView = nil;
        [self.recipients removeObject:user.objectId];
    }
}

#pragma mark - Image Picker Controller Delegate
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [self.tabBarController setSelectedIndex:0];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        // photo
        self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (self.picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
        }
    } else {
        // video
        self.videoFilePath = (NSString *)[[info objectForKey:UIImagePickerControllerMediaURL] path];
        if (self.picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.videoFilePath)) {
                UISaveVideoAtPathToSavedPhotosAlbum(self.videoFilePath, nil, nil, nil);
            }
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - IBActions

- (IBAction)cancel:(id)sender {
    [self reset];
    [self.tabBarController setSelectedIndex:0];
}

- (void)reset {
    self.image = nil;
    self.videoFilePath = nil;
    [self.recipients removeAllObjects];
}

- (IBAction)send:(id)sender {
    if (self.image == nil && [self.videoFilePath length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Try again" message:@"Please take a video or picture to share" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [self presentViewController:self.picker animated:NO completion:nil];
    } else {
        [self uploadMessage];
        [self.tabBarController setSelectedIndex:0];
    }
}

#pragma mark - Helper methods

//-(void)showImagePickerOverlay {
//    [[NSBundle mainBundle] loadNibNamed:@"CameraOverlay" owner:self options:nil];
//    self.overlayView.frame = self.picker.cameraOverlayView.frame;
//    self.picker.cameraOverlayView = self.overlayView;
//    self.overlayView = nil;
//}

- (void)uploadMessage {
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;
    
    if (self.image != nil) {
        UIImage *newImage;
        if ([UIScreen mainScreen].bounds.size.height == 480) {
            newImage = [self resizeImage:self.image toWidth:320.0f andHeight:640.0f];
        } else {
            newImage = [self resizeImage:self.image toWidth:640.0f andHeight:960.0f];
        }
        fileData = UIImagePNGRepresentation(newImage);
        fileName = @"image.png";
        fileType = @"image";
    } else {
        fileData = [NSData dataWithContentsOfFile:self.videoFilePath];
        fileName = @"video.mov";
        fileType = @"video";
    }
    PFFile *file = [PFFile fileWithName:fileName data:fileData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred" message:@"Please try sending your message again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        } else {
            PFObject *message = [PFObject objectWithClassName:@"Messages"];
            [message setObject:file forKey:@"file"];
            [message setObject:fileType forKey:@"fileType"];
            [message setObject:self.recipients forKey:@"recipientIds"];
            [message setObject:[[PFUser currentUser] objectId] forKey:@"senderId"];
            [message setObject:[[PFUser currentUser] username] forKey:@"senderName"];
            [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred" message:@"Please try sending your message again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                } else {
                    [self reset];
                }
            }];
        }
    }];
    
}

-(UIImage *)resizeImage:(id)image toWidth:(float)width andHeight:(float)height
{
    CGSize newSize = CGSizeMake(width, height);
    CGRect newRectangle = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(newSize);
    [self.image drawInRect:newRectangle];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}


@end
