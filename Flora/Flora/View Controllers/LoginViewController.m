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
    self.passwordField.secureTextEntry = YES;
    _usernameField.placeholder = @"username";
    _passwordField.placeholder = @"password";
    
}

- (void)setupAlerts{
    self.emptyFieldsAlert = [UIAlertController alertControllerWithTitle:@"Fields Empty" message:@"Please enter a username and password" preferredStyle:(UIAlertControllerStyleAlert)];
    [self.emptyFieldsAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}]];
    
    self.forgotPasswordAlert = [UIAlertController alertControllerWithTitle:@"Reset Password"
                                                                   message:@"Enter your email"
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    [self.forgotPasswordAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"email";
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *email = [[self.forgotPasswordAlert textFields][0] text];
        [PFUser requestPasswordResetForEmailInBackground:email block:^(BOOL succeeded, NSError * _Nullable error) {
            UIAlertController *alert = nil;
            if(error)
                alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            else
                alert = [UIAlertController alertControllerWithTitle:@"Reset password link sent" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alert animated:YES completion:^{
                    NSTimeInterval delayInSeconds = 1;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [alert dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            
        }];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancelled");
    }];
    
    [self.forgotPasswordAlert addAction:cancelAction];
    [self.forgotPasswordAlert addAction:okAction];
    [self.forgotPasswordAlert setPreferredAction:cancelAction];
}



#pragma mark - Actions

- (IBAction)didTapForgotPassword:(id)sender {
    [self presentViewController:self.forgotPasswordAlert animated:YES completion:nil];
}

- (IBAction)loginUser:(id)sender {
    if([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]) {
        [self presentViewController:self.emptyFieldsAlert animated:YES completion:^{}];
    } else {
        NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *password = self.passwordField.text;
        
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
            if (error) {
                [self presentViewController:[APIManager errorAlertWithTitle:@"Login failed" withMessage:error.localizedDescription] animated:YES completion:nil];
                
            } else {
                self.usernameField.text = @"";
                self.passwordField.text = @"";
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
                SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
                sceneDelegate.window.rootViewController = vc;
            }
        }];
    }
}
- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
