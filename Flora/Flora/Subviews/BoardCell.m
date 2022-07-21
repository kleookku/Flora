//
//  BoardCell.m
//  Flora
//
//  Created by Kleo Ku on 7/12/22.
//

#import "BoardCell.h"

@implementation BoardCell
- (IBAction)didTapBoard:(id)sender {
    [self.delegate didTapBoard:self.board];
}

- (void) tappedEdit {
    self.deleteButton.contentMode = UIViewContentModeScaleAspectFill;
    self.deleteButton.layer.masksToBounds = false;
    self.deleteButton.layer.cornerRadius = self.deleteButton.frame.size.width/2;
    [self.deleteButton setHidden:NO];
//    [self.detailsButton setUserInteractionEnabled:NO];
}

- (void) stoppedEdit {
    [self.deleteButton setHidden:YES];
//    [self.detailsButton setUserInteractionEnabled:YES];
}

- (IBAction)didTapDelete:(id)sender {
    NSString *title = [[NSString alloc] initWithFormat:@"Delete board \"%@\"?", self.board.name];
    UIAlertController *confirmationAlert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.delegate deleteBoard:self.board.name];
        [self.board deleteInBackground];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
     
    [confirmationAlert addAction:cancelAction];
    [confirmationAlert addAction:confirmAction];
    [confirmationAlert setPreferredAction:cancelAction];
    [self.delegate confirmBoardDelete:confirmationAlert];
}


@end
