//
//  LikesCell.m
//  Flora
//
//  Created by Kleo Ku on 7/11/22.
//

#import "LikesCell.h"

@implementation LikesCell

- (IBAction)didTapPlant:(id)sender {
    [self.delegate didTapPlant:self.plant];
}

@end
