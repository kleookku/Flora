//
//  APIManager.m
//  Flora
//
//  Created by Kleo Ku on 6/30/22.
//

#import "APIManager.h"

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

- (void)characteristicSearch:(NSDictionary *)selections completion:(void(^)(NSArray *results, NSError *error))completion {
    NSString *url = @"https://plantsservices.sc.egov.usda.gov/api/CharacteristicsSearch";
    NSString *path = [[NSBundle mainBundle] pathForResource:@"charSearchBody" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray *filterOptions = [dict objectForKey:@"FilterOptions"];
    
    
//    [self setSelection:selections[@"shade"] ofArray:filterOptions inCategory:@"Shade Tolerance"];
//    [self setSelection:selections[@"moist"] ofArray:filterOptions inCategory:@"Moisture Use"];
//    [self setSelection:selections[@"temp"] ofArray:filterOptions inCategory:@"Temperature, Minimum (°F)"];

    // Shade Tolerance: @"Tolerant", @"Intolerant", @"Intermediate"
    // Moisture Use: @"High", @"Low", @"Medium"
    // Temperature:
    // LOW: @"-75 - -53", @"-52 - -48", @"-47 - -43", @"-42 - -38", @"-37 - -33", @"-32 - -28", @"-27 - -23",@"-22 - -18"
    // MEDIUM: @"-17 - -13", @"-12 - -8", @"-7 - -3", @"-2 - 2",@"3 - 7", @"8 - 13", @"13 - 17", @"18 - 22",
    // HIGH: @"23 - 27",@"28 - 32", @"33 - 37", @"38 - 42", @"43 - 47", @"48 - 52", @"53 - 57"
    
    

    [self POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable response) {
        NSLog(@"response is %@", response[@"PlantResults"]);
        completion(response[@"PlantResults"], nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)setSelection:(NSArray *)selections ofArray:(NSMutableArray *)filterOptions inCategory:(NSString *)categoryString{
    NSUInteger index = [filterOptions indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dict = (NSDictionary *)obj;
        return [dict[@"Name"]  isEqualToString:categoryString];}];
    NSMutableArray *options = [filterOptions objectAtIndex:index][@"Filters"]; // intermediate, tolerant, intolerant
    for (NSString *selection in selections) {
        NSUInteger selectionIndex = [options indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dict = (NSDictionary *)obj;
            return [dict[@"Display"]  isEqualToString:selection];
        }];
        NSMutableDictionary *selectionDict = [options objectAtIndex:selectionIndex];
        selectionDict[@"IsSelected"] = @YES;
    }

}

- (void)getPlantCharacteristics:(NSString *)plantId completion:(void (^)(NSDictionary *characteristics, NSError *error))completion {
    NSString *url = [@"https://plantsservices.sc.egov.usda.gov/api/PlantCharacteristics/" stringByAppendingString:plantId];
    [self GET:url parameters:nil progress: nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray * _Nullable response) {
        
        NSUInteger shadeIndex = [response indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dict = (NSDictionary *)obj;
            return [dict[@"PlantCharacteristicName"]  isEqualToString:@"Shade Tolerance"];}];
        
        NSUInteger moistIndex = [response indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dict = (NSDictionary *)obj;
            return [dict[@"PlantCharacteristicName"]  isEqualToString:@"Moisture Use"];}];
        
        NSUInteger tempIndex = [response indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dict = (NSDictionary *)obj;
            return [dict[@"PlantCharacteristicName"]  isEqualToString:@"Temperature, Minimum (°F)"];}];
        
        NSDictionary *dict = @{@"shade": [response objectAtIndex:shadeIndex][@"PlantCharacteristicValue"],
                               @"moisture": [response objectAtIndex:moistIndex][@"PlantCharacteristicValue"],
                               @"temp": [response objectAtIndex:tempIndex][@"PlantCharacteristicValue"]};
        
        completion(dict, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}


@end

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
