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
<<<<<<< HEAD
#import "PFImageView.h"

@interface ProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
=======

@interface ProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
>>>>>>> b875545 (added profile view, login/logout)
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *addPictureButton;

@property (nonatomic, strong) UIAlertController *addPictureAlert;
@property (nonatomic, strong) UIAlertController *noCameraAlert;



@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFUser *user = [PFUser currentUser];
    self.usernameField.text = user.username;
    self.passwordField.placeholder = @"reset password";
    self.emailField.text = user.email;
<<<<<<< HEAD
    self.emailField.userInteractionEnabled = NO;
=======
    
>>>>>>> b875545 (added profile view, login/logout)
    // Do any additional setup after loading the view.
    _saveButton.layer.cornerRadius = 10;
    
    self.profileImage.layer.masksToBounds = false;
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2;
    self.profileImage.clipsToBounds = true;
    self.profileImage.layer.borderWidth = 0.05;
<<<<<<< HEAD
    if(user[@"profilePic"] != nil) {
        self.profileImage.file = user[@"profilePic"];
        [self.profileImage loadInBackground];
    }
=======
>>>>>>> b875545 (added profile view, login/logout)
    
    self.addPictureButton.layer.masksToBounds = false;
    self.addPictureButton.layer.cornerRadius = self.addPictureButton.frame.size.width/2;
    self.addPictureButton.clipsToBounds = true;
    
    
    [self setupAddPictureAlert];
    [self setupNoCameraAlert];
    
}
- (IBAction)addProfilePic:(id)sender {
    [self presentViewController:self.addPictureAlert animated:YES completion:^{}];
}


- (IBAction)didTapSave:(id)sender {
<<<<<<< HEAD
    PFUser *user = [PFUser currentUser];
    if(![self.usernameField.text isEqualToString:@""]) {
        user.username = self.usernameField.text;
    }
    if(![self.passwordField.text isEqualToString:@""]) {
        user.password = self.passwordField.text;
    }
    
    NSData *imageData = UIImagePNGRepresentation(self.profileImage.image);
    PFFileObject *imageFile = [PFFileObject fileObjectWithName:@"avatar.png" data:imageData];
    
    PFUser *currentUser = [PFUser currentUser];
    currentUser[@"profilePic"] = imageFile;
    
    [currentUser saveInBackground];
=======
>>>>>>> b875545 (added profile view, login/logout)
}

- (IBAction)logoutUser:(id)sender {
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        NSLog(@"Error is %@", error);
        // PFUser.current() will now be nil
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
        UIViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        sceneDelegate.window.rootViewController = loginViewController;
    }];

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
<<<<<<< HEAD
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
=======
    //    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
>>>>>>> b875545 (added profile view, login/logout)
    
    // Do something with the images (based on your use case)
    UIImage *resizedImage = [self resizeImage:originalImage withSize:self.profileImage.bounds.size];
    self.profileImage.image = resizedImage; //originalImage;
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}


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

- (void)setupNoCameraAlert {
    
    self.noCameraAlert = [UIAlertController alertControllerWithTitle:@"Camera not available" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    
    [self.noCameraAlert addAction:okAction];
    
}

- (void)openCamera {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerVC animated:YES completion:nil];

    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        [self presentViewController:self.noCameraAlert animated:nil completion:^{}];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
