//
//  SignupViewController.m
//  Flora
//
//  Created by Kleo Ku on 7/8/22.
//

#import "SignupViewController.h"
#import "Parse/Parse.h"
#import "APIManager.h"

@interface SignupViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (nonatomic, strong) UIAlertController *emptyFieldsAlert;
@property (nonatomic, strong) UIAlertController *passwordMatchAlert;
@property (nonatomic, strong) UIAlertController *errorAlert;

@property (nonatomic, strong) CABasicAnimation *buttonAnimation;


@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.signupButton.layer.cornerRadius = 20;
    self.emailField.layer.cornerRadius = 40;
    self.usernameField.layer.cornerRadius = 40;
    self.passwordField.layer.cornerRadius = 40;
    [self.passwordField setSecureTextEntry:YES];
    self.confirmPasswordField.layer.cornerRadius = 40;
    [self.confirmPasswordField setSecureTextEntry:YES];
    
    self.emailField.placeholder = @"email";
    self.usernameField.placeholder = @"username";
    self.passwordField.placeholder = @"password";
    self.confirmPasswordField.placeholder = @"confirm password";
    
    _buttonAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    _buttonAnimation.duration=0.15;
    _buttonAnimation.autoreverses=YES;
    _buttonAnimation.fromValue=[NSNumber numberWithFloat:1.0];
    _buttonAnimation.toValue=[NSNumber numberWithFloat:0.7];
    _buttonAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [self setupAlerts];
}

#pragma mark - Alerts

- (void)setupAlerts {
    // emptyFieldsAlert
    self.emptyFieldsAlert = [UIAlertController alertControllerWithTitle:@"Fields Empty"
                                                                message:@"Please enter a username and password"
                                                         preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {}];
    [self.emptyFieldsAlert addAction:okAction];
    
    // passwordMatchAlert
    self.passwordMatchAlert = [UIAlertController alertControllerWithTitle:@"Passwords don't match"
                                                                  message:@"Please enter a valid password"
                                                           preferredStyle:(UIAlertControllerStyleAlert)];
    [self.passwordMatchAlert addAction:okAction];
    
}

- (void)displayErrorAlertWithMessage:(NSString *)message {
    self.errorAlert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                message:message
                                                         preferredStyle:(UIAlertControllerStyleAlert)];
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {}];
    // add the OK action to the alert controller
    [self.errorAlert addAction:okAction];
    [self presentViewController:self.errorAlert animated:YES completion:^{}];
    self.errorAlert = nil;
}


#pragma mark - Actions

- (IBAction)registerUser:(id)sender {
    [self.signupButton.layer addAnimation:self.buttonAnimation forKey:@"animateOpacity"];
    if([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]) {
        [self presentViewController:self.emptyFieldsAlert animated:YES completion:^{
            // optional code for what happens after the alert controller has finished presenting
        }];
    } else if(![self.passwordField.text isEqual:self.confirmPasswordField.text]){
        [self presentViewController:self.passwordMatchAlert animated:YES completion:^{}];
    } else {
        PFUser *newUser = [PFUser user];
        
        // set user properties
        newUser.username = [[self.usernameField.text lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];;
        newUser.email = self.emailField.text;
        newUser.password = self.passwordField.text;
        
        // call sign up function on the object
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error) {
                [self presentViewController:[APIManager errorAlertWithTitle:@"Signup failed" withMessage:error.localizedDescription] animated:YES completion:nil];
            } else {
                self.usernameField.text = @"";
                self.passwordField.text = @"";
                
                // manually segue to logged in view
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
}

- (IBAction)didTap:(id)sender {
    [self.view endEditing:YES];

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
