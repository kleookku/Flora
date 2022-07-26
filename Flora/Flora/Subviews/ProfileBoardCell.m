//
//  ProfileBoardCell.m
//  Flora
//
//  Created by Kleo Ku on 7/25/22.
//

#import "ProfileBoardCell.h"

@implementation ProfileBoardCell
- (IBAction)tappedBoard:(id)sender {
    [self.delegate didTapBoard:self.board];
}

@end
