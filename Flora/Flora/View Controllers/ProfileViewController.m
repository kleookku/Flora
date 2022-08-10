//
//  ProfileViewController.m
//  Flora
//
//  Created by Kleo Ku on 7/8/22.
//

#import "ProfileViewController.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "PFImageView.h"
#import "APIManager.h"
#import "Plant.h"

@interface ProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *addPictureButton;

@property (nonatomic, strong) UIAlertController *addPictureAlert;
@property (nonatomic, strong)UIAlertController *savedAlert;


@property NSUInteger offset;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFUser *user = [PFUser currentUser];
    self.usernameField.text = user.username;
    self.passwordField.placeholder = @"reset password";
    self.passwordField.secureTextEntry = YES;
    self.emailField.text = user.email;
    self.emailField.userInteractionEnabled = NO;
    _saveButton.layer.cornerRadius = 10;
    
    self.profileImage.layer.masksToBounds = false;
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2;
    self.profileImage.clipsToBounds = true;
    self.profileImage.layer.borderWidth = 0.05;
    
    self.addPictureButton.layer.masksToBounds = false;
    self.addPictureButton.layer.cornerRadius = self.addPictureButton.frame.size.width/2;
    self.addPictureButton.clipsToBounds = true;
    
    if(user[@"profilePic"] != nil) {
        self.profileImage.file = user[@"profilePic"];
        [self.profileImage loadInBackground];
    }
    
    // alerts
    [self setupAddPictureAlert];
    [self setupSavedAlert];
    
    self.offset = 0;
}

#pragma mark - Actions

- (IBAction)addProfilePic:(id)sender {
    [self presentViewController:self.addPictureAlert animated:YES completion:^{}];
}

- (IBAction)didTapSave:(id)sender {
    PFUser *user = [PFUser currentUser];
    if(![self.usernameField.text isEqualToString:@""])
        user.username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(![self.passwordField.text isEqualToString:@""])
        user.password = self.passwordField.text;
    
    NSData *imageData = UIImagePNGRepresentation(self.profileImage.image);
    PFFileObject *imageFile = [PFFileObject fileObjectWithName:@"avatar.png" data:imageData];
    
    user[@"profilePic"] = imageFile;
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error) {
            [self presentViewController:[APIManager errorAlertWithTitle:@"Error saving profile picture" withMessage:error.localizedDescription] animated:YES completion:nil];
            
        } else {
            [self.delegate updateInformation];
        }
    }];
    
    [self presentViewController:self.savedAlert animated:YES completion:^{
        NSTimeInterval delayInSeconds = 0.25;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.savedAlert dismissViewControllerAnimated:YES completion:nil];
        });
    }];
    
    
}

- (IBAction)logoutUser:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
        UIViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        sceneDelegate.window.rootViewController = loginViewController;
    }];
}

- (IBAction)didTap:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - Alerts


- (void)setupAddPictureAlert {
    self.addPictureAlert = [UIAlertController alertControllerWithTitle:@"Select Profile Picture" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    
    UIAlertAction *takePictureAction = [UIAlertAction actionWithTitle:@"Take a Picture" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openCamera];
    }];
    
    UIAlertAction *choosePictureAction = [UIAlertAction actionWithTitle:@"Choose from Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openLibrary];
    }];
    
    // add the OK action to the alert controller
    [self.addPictureAlert addAction:takePictureAction];
    [self.addPictureAlert addAction:choosePictureAction];
    [self.addPictureAlert addAction:cancelAction];
    
    self.addPictureAlert.preferredAction = cancelAction;
}

- (void)setupSavedAlert {
    self.savedAlert = [UIAlertController alertControllerWithTitle:@"Saved" message:nil preferredStyle:UIAlertControllerStyleAlert];
}

#pragma mark - Image Select

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    if(editedImage){
        UIImage *resizedImage = [self resizeImage:editedImage withSize:self.profileImage.bounds.size];
        self.profileImage.image = resizedImage;
    } else {
        UIImage *resizedImage = [self resizeImage:originalImage withSize:self.profileImage.bounds.size];
        self.profileImage.image = resizedImage;
    }
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (void)openCamera {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }
}

- (void)openLibrary {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - Data Import

- (IBAction)onTapImport:(id)sender {
    [self updatePlants];
}

- (void)updatePlants {
    [[APIManager shared] searchWithOffset:self.offset completion:^(NSArray * _Nonnull results, NSError * _Nonnull error) {
        if(error) {
            [self presentViewController:[APIManager errorAlertWithTitle:@"Error searching plants" withMessage:error.localizedDescription] animated:YES completion:nil];
            
        } else {
            [self saveResults:results];
            if(results.count<25){
                return;
            } else {
                self.offset += 25;
                [self updatePlants];
            }
            
        }
    }];
}

- (void)saveResults:(NSArray*) results {
    for (NSDictionary *result in results) {
        [Plant savePlantWithDict:result withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if(error)
                [self presentViewController:[APIManager errorAlertWithTitle:@"Error saving plants" withMessage:error.localizedDescription] animated:YES completion:nil];
            
        }];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
