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
@dynamic user;
@dynamic notes;
@dynamic coverImage;

+ (nonnull NSString *) parseClassName {
    return @"Board";
}

+ (void) saveBoard: (NSString * _Nullable)name withPlants:(NSArray * _Nullable)plants forUser:(NSString *)username withNotes:(NSString *)notes withCompletion: (PFBooleanResultBlock _Nullable)completion {
    
    Board *newBoard = [Board new];
    newBoard.name = name;
    newBoard.plantsArray = plants;
    newBoard.user = username;
    newBoard.notes = notes;
    
    [newBoard saveInBackgroundWithBlock: completion];
}


@end
