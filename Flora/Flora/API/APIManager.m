//
//  APIManager.m
//  Flora
//
//  Created by Kleo Ku on 6/30/22.
//

#import "APIManager.h"
#import "Parse/Parse.h"
#import "Board.h"
#import "Plant.h"
#import "Follow.h"

#define SHADE @"Shade Tolerance"
#define MOIST @"Moisture Use"
#define TEMP @"Temperature, Minimum (°F)"

@implementation APIManager

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        sharedManager.requestSerializer = [AFJSONRequestSerializer serializer];
    });
    return sharedManager;
}

#pragma mark - USDA API

+ (NSData *)searchBody {
    static NSData *data = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"charSearchBody" ofType:@"json"];
        data = [NSData dataWithContentsOfFile:path];
    });
    return data;
}

- (void)searchWithShadeLevel:(NSArray *)shade withMoistureUse:(NSArray *)moist withMinTemperature:(NSArray *)temp offsetBy:(NSUInteger)offset completion:(void(^)(NSArray *results, NSError *error))completion {
    
    NSString *url = @"https://plantsservices.sc.egov.usda.gov/api/CharacteristicsSearch";
    NSMutableDictionary *mutableDict = [NSJSONSerialization JSONObjectWithData:[APIManager searchBody] options:NSJSONReadingMutableContainers error:nil];
    mutableDict[@"Offset"] = @(offset);
    NSMutableArray *filterOptions = [mutableDict objectForKey:@"FilterOptions"];
    
    [self modifyFilterOptions:shade ofArray:filterOptions inCategory:SHADE];
    [self modifyFilterOptions:moist ofArray:filterOptions inCategory:MOIST];
    [self modifyFilterOptions:temp ofArray:filterOptions inCategory:TEMP];
    
    [self POST:url parameters:mutableDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable response) {
        
        NSMutableArray<NSDictionary *> *results = [[NSMutableArray alloc] initWithArray:response[@"PlantResults"] copyItems:YES];
        
        for (NSUInteger i = 0; i < results.count - 1; ++i) {
            NSInteger remainingCount = results.count - i;
            NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
            [results exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
        }
        
        completion(results, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
    
}

- (void)searchPlantsWithShadeLevel:(NSString *)shade withMoistureUse:(NSString *)moist withMinTemperature:(NSString *)temp completion:(void(^)(NSArray *results, NSError *error))completion {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Plant"];
    [query whereKey:@"shadeLevel" equalTo:shade];
    [query whereKey:@"moistureUse" equalTo:moist];
    [query whereKey:@"minTemp" equalTo:temp];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error) {
            NSLog(@"Error getting search results: %@", error.localizedDescription);
        } else {
        }
    }];
}

- (void)modifyFilterOptions:(NSArray *)selections ofArray:(NSMutableArray *)filterOptions inCategory:(NSString *)categoryString{
    NSUInteger index = [filterOptions indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dict = (NSDictionary *)obj;
        return [dict[@"Name"]  isEqualToString:categoryString];}];
    NSMutableArray *options = [filterOptions objectAtIndex:index][@"Filters"];
    for (NSString *selection in selections) {
        NSUInteger selectionIndex = [options indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dict = (NSDictionary *)obj;
            return [dict[@"Display"]  isEqualToString:selection];
        }];
        [options objectAtIndex:selectionIndex][@"IsSelected"] = @YES;
    }
}

- (void)getPlantCharacteristicsWithId:(NSString *)plantId completion:(void (^)(NSString *shade, NSString *moist, NSString *temp, NSError *error))completion {
    NSString *url = [@"https://plantsservices.sc.egov.usda.gov/api/PlantCharacteristics/" stringByAppendingString:plantId];
    [self GET:url parameters:nil progress: nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray * _Nullable response) {
        
        NSString *shadeLevel = [self getCharacteristicValue:SHADE inArray:response];
        NSString *moistureUse = [self getCharacteristicValue:MOIST inArray:response];
        NSString *minimumTemp = [self getCharacteristicValue:TEMP inArray:response];
        
        completion(shadeLevel, moistureUse, minimumTemp, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, nil, nil, error);
    }];
}

- (NSString *)getCharacteristicValue:(NSString *)category inArray:response {
    NSUInteger index = [response indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dict = (NSDictionary *)obj;
        return [dict[@"PlantCharacteristicName"]  isEqualToString:category];}];
    
    if( index <= [response count]){
        return [response objectAtIndex:index][@"PlantCharacteristicValue"];
    } else {
        return @"N/A";
    }
}

- (NSURL *)getPlantImageURL:(NSString *) filename {
    NSString *imageUrlString = [[NSString alloc] init];
    if([filename isKindOfClass:[NSString class]]) {
        NSString *thumbnailString =  [@"https://plants.sc.egov.usda.gov/ImageLibrary/standard/" stringByAppendingString:filename];
        imageUrlString = [thumbnailString stringByReplacingCharactersInRange:NSMakeRange(thumbnailString.length-7, 1) withString:@"s"];
    } else {
        imageUrlString = @"https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1024px-No_image_available.svg.png";
    }
    return [NSURL URLWithString:imageUrlString];
    
}

- (void)searchWithOffset:(NSUInteger)offset completion:(void(^)(NSArray *results, NSError *error))completion {
    NSString *url = @"https://plantsservices.sc.egov.usda.gov/api/CharacteristicsSearch";
    NSMutableDictionary *mutableDict = [NSJSONSerialization JSONObjectWithData:[APIManager searchBody] options:NSJSONReadingMutableContainers error:nil];
    mutableDict[@"Offset"] = @(offset);
    
    [self POST:url parameters:mutableDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable response) {
        
        NSMutableArray<NSDictionary *> *results = [[NSMutableArray alloc] initWithArray:response[@"PlantResults"] copyItems:YES];
        
        completion(results, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}
# pragma mark - Open Weather API

- (void)weatherValuesAtLat:(NSString *)lat atLong:(NSString *)lon withCompletion:(void(^)(int moist, int sun, int temp, NSError *error))completion {
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    
    NSString *key = [dict objectForKey: @"openWeather"];
    
    NSString *url = @"https://api.openweathermap.org/data/2.5/onecall?lat=33.44&lon=-94.04&exclude=hourly,daily,minutely,alerts&appid=c96c5ecb9da23f5f2d43200563e6eb24";//@"https://api.openweathermap.org/data/2.5/onecall";
    [self GET:url parameters:nil // @{@"lat":lat,@"lon":lon,@"exclude":@"minutely,hourly,daily,alerts",@"appid":key,@"units":@"imperial"}
     progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *response = (NSDictionary *)responseObject;
        int moisture =  (int) response[@"humidity"];
        int sunlight = (int) response[@"uvi"];
        int temperature = (int) response[@"temp"];
        
        int moistIndex = 0;
        int sunIndex = 0;
        int tempIndex = 0;

        if(moisture <= 30) {
            moistIndex = 0;
        } else if (moisture >= 65 ){
            moistIndex = 2;
        } else {
            moistIndex = 1;
        }

        if(sunlight <= -17) {
            sunIndex = 0;
        } else if(sunlight >=  6) {
            sunIndex = 2;
        } else {
            sunIndex = 1;
        }
        
        if(temperature < -17) {
            tempIndex = 0;
        } else if(temperature > 40) {
            tempIndex = 2;
        } else {
            tempIndex = 1;
        }
        
        completion(moistIndex, sunIndex, tempIndex, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(0, 0, 0, error);
    }];
}


# pragma mark - Parse Board

+ (void)saveBoardWithName:(NSString *) boardName {
    PFUser *user = [PFUser currentUser];
    
    // save board PFObject to database
    
    [Board saveBoard:boardName withPlants:@[] forUser:user.username withNotes:@"" withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error saving board: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully saved board!");
        }
    }];
    
    NSMutableArray *boardsArray = [[NSMutableArray alloc] initWithArray: user[@"boards"] copyItems:YES];
    [boardsArray addObject:boardName];
    user[@"boards"] = boardsArray;
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"Saved!");
        }
    }];
}

#pragma mark - Parse Follow

+ (void)followUser:(PFUser *) user {
    PFUser *currentUser = [PFUser currentUser];
    
    [Follow saveFollow:user.username withFollower:currentUser.username withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(error) {
            NSLog(@"Error saving follow: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully saved follow!");
        }
    }];
}


+ (void)unfollowUser:(PFUser *) user {
    PFUser *currentUser = [PFUser currentUser];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
    [query whereKey:@"follower" equalTo:currentUser.username];
    [query whereKey:@"username" equalTo:user.username];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error) {
            NSLog(@"Error getting follow: %@", error.localizedDescription);
        } else if (objects.count > 0){
            Follow *follow = (Follow *)objects[0];
            [follow deleteInBackground];
        }
    }];
}

+ (void)removeFollower:(PFUser *) user {
    PFUser *currentUser = [PFUser currentUser];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
    [query whereKey:@"follower" equalTo:user.username];
    [query whereKey:@"username" equalTo:currentUser.username];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error) {
            NSLog(@"Error getting follow: %@", error.localizedDescription);
        } else if (objects.count > 0){
            Follow *follow = (Follow *)objects[0];
            [follow deleteInBackground];
        }
    }];
}

#pragma mark - Parse Plant

+ (void)savePlantToLikes:(Plant *)plant{
    PFUser *user = [PFUser currentUser];
    
    if(![user[@"likes"] containsObject:plant.plantId]){
        NSMutableArray *likesArray = [[NSMutableArray alloc] initWithArray:user[@"likes"] copyItems:YES];
        [likesArray addObject:plant.plantId];
        user[@"likes"] = likesArray;
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(error) {
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                NSLog(@"Saved!");
            }
        }];
        
    }
}

+ (void)removePlantFromLikes:(Plant *)plant{
    PFUser *user = [PFUser currentUser];
    if([user[@"likes"] containsObject:plant.plantId]){
        NSMutableArray *likesArray = [[NSMutableArray alloc] initWithArray:user[@"likes"] copyItems:YES];
        [likesArray removeObject:plant.plantId];
        user[@"likes"] = likesArray;
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(error) {
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                NSLog(@"Saved!");
            }
        }];
        
    }
}

+ (void)savePlantToSeen:(Plant *)plant {
    PFUser *user = [PFUser currentUser];
    
    // save plant id to user's seen
    NSMutableArray *seenArray = [[NSMutableArray alloc] initWithArray:user[@"seen"] copyItems:YES];
    if(![seenArray containsObject:plant.plantId]) {
        [seenArray addObject:plant.plantId];
        user[@"seen"] = seenArray;
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(error) {
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                NSLog(@"Saved!");
            }
        }];
    }
}

/*
 SVPullToRefresh pod (detect when you get to the bottom)
 addInfiniteScrollingWithActionHandler
 query for post
 
 get size of current array of posts (should be 20)
 get the last post of the current array, which is the oldest one of the current 20 that's showing
 do wehereKey createdAt is lessThan lastPost.createdAt with query limit
 do same query
 add posts to array of posts
 
 content offset tells you how far down
 */

@end

