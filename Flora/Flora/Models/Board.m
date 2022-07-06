//
//  Board.m
//  Flora
//
//  Created by Kleo Ku on 7/6/22.
//

#import "Board.h"

@implementation Board

@dynamic name;
@dynamic plantsArray;

+ (nonnull NSString *) parseClassName {
    return @"Board";
}

+ (void) saveBoard: (NSString * _Nullable)name withPlants:(NSArray * _Nullable)plants withCompletion: (PFBooleanResultBlock _Nullable)completion {
    
    Board *newBoard = [Board new];
    newBoard.name = name;
    newBoard.plantsArray = plants;
    
    [newBoard saveInBackgroundWithBlock: completion];
}


@end
