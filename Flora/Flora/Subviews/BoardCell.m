//
//  BoardCell.m
//  Flora
//
//  Created by Kleo Ku on 7/12/22.
//

#import "BoardCell.h"

@implementation BoardCell
- (IBAction)didTapBoard:(id)sender {
    [self.delegate didTapViewBoard:self.board];
}

@end
