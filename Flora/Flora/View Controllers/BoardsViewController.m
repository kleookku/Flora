//
//  BoardsViewController.m
//  Flora
//
//  Created by Kleo Ku on 7/12/22.
//

#import "BoardsViewController.h"

@interface BoardsViewController ()
- (IBAction)addBoardButton:(id)sender;

@property (nonatomic, strong) UIAlertController *createBoardAlert;


@end

@implementation BoardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupCreateBoardAlert];
    
    
}

- (void) setupCreateBoardAlert {
    self.createBoardAlert = [UIAlertController alertControllerWithTitle:@"Create a Board" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self.createBoardAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"name";
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Current password %@", [[self.createBoardAlert textFields][0] text]);
        //compare the current password and do action here

    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Canelled");
    }];
    
    [self.createBoardAlert addAction:confirmAction];
    [self.createBoardAlert addAction:cancelAction];
}

- (IBAction)didTapAddBoard:(id)sender {
    NSLog(@"clicked add board");
    [self presentViewController:self.createBoardAlert animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addBoardButton:(id)sender {
}
@end
