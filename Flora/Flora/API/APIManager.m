//
//  APIManager.m
//  Flora
//
//  Created by Kleo Ku on 6/30/22.
//

#import "APIManager.h"

@implementation APIManager

- (void)charSearch:(void(^)(NSArray *results, NSError *error))completion {
    NSString *url = @"https://plantsservices.sc.egov.usda.gov/api/CharacteristicsSearch";
    [self POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable response) {
        completion(response[@"PlantResults"], nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)plantProfile:(NSString *)symbol completion:(void (^)(NSDictionary *dict, NSError *error))completion {
    NSString *url = @"https://plantsservices.sc.egov.usda.gov/api/PlantProfile";
    NSDictionary *params = @{@"symbol": symbol};
    [self GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task,   _Nullable responseObject) {
        <#code#>
    } failure:<#^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)failure#>]
    
}

- (void)plantChars:(NSString *)plantId completion:(void (^)(NSArray *chars, NSError *error))completion {
    NSString *url = [@"https://plantsservices.sc.egov.usda.gov/api/PlantCharacteristics/" stringByAppendingString:plantId];
}

@end
