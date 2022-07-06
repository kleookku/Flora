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
    // [self getPlantChars:@"42690"];
    [self createCharacteristicSearch:nil];
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

- (void)createCharacteristicSearch:(NSDictionary *)selectedAttributes {
    NSDictionary *selection = @{@"shade":@[@"Intolerant"],
                                @"moist":@[@"High"],
                                @"temp":@[]}; //@"-17 - -13", @"-12 - -8", @"-7 - -3", @"-2 - 2",@"3 - 7", @"8 - 13", @"13 - 17", @"18 - 22"]};
    [[APIManager shared] characteristicSearch:selection completion:^(NSArray * _Nonnull results, NSError * _Nonnull error) {
        if(results) {
            NSLog(@"Successfully created characteristics search!");
            NSLog(@"results: %@", results);
        } else {
            NSLog(@"Error creating characteristics search: %@", error.localizedDescription);
        }
    }];
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
