//
//  SelectBoardCell.m
//  Flora
//
//  Created by Kleo Ku on 7/12/22.
//

#import "SelectBoardCell.h"

@implementation SelectBoardCell

- (IBAction)didTapAddToBoard:(id)sender {
    UIAlertController *confirmationAlert = nil;
    if([self.board[@"plantsArray"] containsObject:self.plantToAdd]){
        confirmationAlert = [UIAlertController alertControllerWithTitle:@"Already exists in this board" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        [confirmationAlert addAction:okAction];
        
    } else {
        NSString *title = [@"Add plant to " stringByAppendingString:self.board.name];
        confirmationAlert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self addPlantToBoard];
            [self.delegate updateBoards];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
         
        [confirmationAlert addAction:cancelAction];
        [confirmationAlert addAction:confirmAction];
        [confirmationAlert setPreferredAction:cancelAction];
        
    }
    
    [self.delegate confirmAddToBoard:confirmationAlert];
        
}

- (void)addPlantToBoard {
    // save plant to board's plants
    NSMutableArray *plantsArray = [[NSMutableArray alloc] initWithArray:self.board[@"plantsArray"] copyItems:YES];
    [plantsArray addObject:self.plantToAdd];
    self.board[@"plantsArray"] = plantsArray;
    [self.board saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error) {
            NSLog(@"Error adding plant to board %@", error.localizedDescription);
        } else {
            NSLog(@"Saved plant to board!");
        }
    }];
}

@end
