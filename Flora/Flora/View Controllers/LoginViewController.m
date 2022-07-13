//
//  LoginViewController.m
//  Flora
//
//  Created by Kleo Ku on 6/30/22.
//

#import "LoginViewController.h"
#import "APIManager.h"
#import "ResultsViewController.h"
#import "Parse/Parse.h"
#import "AppDelegate.h"
#import "SceneDelegate.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (nonatomic, strong) UIAlertController *emptyFieldsAlert;
@property (nonatomic, strong) UIAlertController *forgotPasswordAlert;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAlerts];
    self.loginButton.layer.cornerRadius = 20;
    self.usernameField.layer.cornerRadius = 40;
    self.passwordField.layer.cornerRadius = 40;
    _usernameField.placeholder = @"username";
    _passwordField.placeholder = @"password";

}


- (IBAction)didTapForgotPassword:(id)sender {
//    PFUser.requestPasswordResetForEmailInBackground("email@example.com", nil)
    
}


- (IBAction)loginUser:(id)sender {
    if([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]) {
        [self presentViewController:self.emptyFieldsAlert animated:YES completion:^{
            // optional code for what happens after the alert controller has finished presenting
        }];
    } else {
        NSString *username = self.usernameField.text;
        NSString *password = self.passwordField.text;
        
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
            if (error != nil) {
                NSLog(@"User log in failed: %@", error.localizedDescription);
            } else {
                NSLog(@"User logged in successfully");
                
                self.usernameField.text = @"";
                self.passwordField.text = @"";
                                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
                SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
                sceneDelegate.window.rootViewController = vc;
<<<<<<< HEAD
=======
            
>>>>>>> b875545 (added profile view, login/logout)
            }
        }];
    }
}

- (void)setupAlerts{
    self.emptyFieldsAlert = [UIAlertController alertControllerWithTitle:@"Fields Empty"
                                                     message:@"Please enter a username and password"
                                              preferredStyle:(UIAlertControllerStyleAlert)];
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * _Nonnull action) {}];
    // add the OK action to the alert controller
    [self.emptyFieldsAlert addAction:okAction];
    
    self.forgotPasswordAlert = [UIAlertController alertControllerWithTitle:@"Forgot Password"
                                                                  message:@"Please enter your email"
                                                           preferredStyle:(UIAlertControllerStyleAlert)];
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //UINavigationController *navController = [segue destinationViewController];
    //ResultsViewController *resultsVC = (ResultsViewController*)navController.topViewController;

}


@end
