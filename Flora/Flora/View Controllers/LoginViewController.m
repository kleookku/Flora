//
//  LoginViewController.m
//  Flora
//
//  Created by Kleo Ku on 6/30/22.
//

#import "LoginViewController.h"
#import "APIManager.h"
#import "ResultsViewController.h"

@interface LoginViewController ()


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // [self getPlantChars:@"42690"];
}

- (void)getPlantChars:(NSString *)plantID {
    [[APIManager shared] getPlantCharacteristics:plantID completion:^(NSDictionary * _Nonnull characteristics, NSError * _Nonnull error) {
        if(characteristics) {
            NSLog(@"Characteristics: %@", characteristics);
        } else {
            NSLog(@"Error getting plant characteristics: %@", error.localizedDescription);
        }
    }];
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
