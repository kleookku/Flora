//
//  Board.h
//  Flora
//
//  Created by Kleo Ku on 7/6/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Board : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *plantsArray;
@property (nonatomic, strong) NSString *user;

+ (void) saveBoard: (NSString * _Nullable)name withPlants:(NSArray * _Nullable)plants forUser:(NSString *)username withCompletion: (PFBooleanResultBlock _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
