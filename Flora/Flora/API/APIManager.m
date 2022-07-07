//
//  APIManager.m
//  Flora
//
//  Created by Kleo Ku on 6/30/22.
//

#import "APIManager.h"
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

+ (NSDictionary *)searchBody {
    static NSDictionary *dict = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"charSearchBody" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    });
    return dict;
}

- (void)searchWithShadeLevel:(NSArray *)shade withMoistureUse:(NSArray *)moist withMinTemperature:(NSArray *)temp offsetBy:(NSUInteger)offset completion:(void(^)(NSArray *results, NSError *error))completion {
    NSString *url = @"https://plantsservices.sc.egov.usda.gov/api/CharacteristicsSearch";
    NSMutableDictionary *mutableDict = [[APIManager searchBody] mutableCopy];
    mutableDict[@"Offset"] = @(offset);
    NSMutableArray *filterOptions = [mutableDict objectForKey:@"FilterOptions"];
            
    [self modifyFilterOptions:shade ofArray:filterOptions inCategory:SHADE];
    [self modifyFilterOptions:moist ofArray:filterOptions inCategory:MOIST];
    [self modifyFilterOptions:temp ofArray:filterOptions inCategory:TEMP];
    
    [self POST:url parameters:mutableDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable response) {
        completion(response[@"PlantResults"], nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
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

- (void)getPlantCharacteristics:(NSString *)plantId completion:(void (^)(NSDictionary *characteristics, NSError *error))completion {
    NSString *url = [@"https://plantsservices.sc.egov.usda.gov/api/PlantCharacteristics/" stringByAppendingString:plantId];
    [self GET:url parameters:nil progress: nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray * _Nullable response) {

        NSDictionary *dict = @{@"shade": [self getCharacteristicValue:SHADE inArray:response],
                               @"moist": [self getCharacteristicValue:MOIST inArray:response],
                               @"temp": [self getCharacteristicValue:TEMP inArray:response]};
        
        completion(dict, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (NSString *)getCharacteristicValue:(NSString *)category inArray:response {
    NSUInteger index = [response indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dict = (NSDictionary *)obj;
        return [dict[@"PlantCharacteristicName"]  isEqualToString:category];}];
    return [response objectAtIndex:index][@"PlantCharacteristicValue"];
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

