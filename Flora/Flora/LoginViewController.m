//
//  LoginViewController.m
//  Flora
//
//  Created by Kleo Ku on 6/30/22.
//

#import "LoginViewController.h"
#import "APIManager.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)getPlantChars:(NSString *)plantID {
    [[APIManager shared] getPlantCharacteristics:@"42690" completion:^(NSDictionary * _Nonnull characteristics, NSError * _Nonnull error) {
        if(characteristics) {
            NSLog(@"Characteristics: %@", characteristics);
        } else {
            NSLog(@"Error getting plant characteristics: %@", error.localizedDescription);
        }
    }];
}

- (void)createCharacteristicSearch:(NSDictionary *)selectedAttributes {
    
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
