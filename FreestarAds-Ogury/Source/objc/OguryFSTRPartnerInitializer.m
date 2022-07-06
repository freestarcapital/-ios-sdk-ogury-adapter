//
//  OguryFSTRPartnerInitializer.m
//  FreestarAds-Ogury
//
//  Created by Carlos Alcala on 7/04/22.
//

#import "OguryFSTRPartnerInitializer.h"

@implementation OguryFSTRPartnerInitializer

+ (instancetype)shared {
    static OguryFSTRPartnerInitializer *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[OguryFSTRPartnerInitializer alloc] init];
    });
    return instance;
}

- (void)runInitialization {
    // run partner initialization here
    FSTRLog(@"OGURY: Partner initialization.");

    OguryConfigurationBuilder *configurationBuilder = [[OguryConfigurationBuilder alloc] initWithAssetKey:@"OGY-773308830772"];
        [Ogury startWithConfiguration:[configurationBuilder build]];
//    NSError *error = [[NSError alloc] initWithDomain:@"com.ogury.native.error"
//                                                code:1
//                                            userInfo:@{ NSLocalizedDescriptionKey : @"Ogury partner failed to initialize."}];
    NSError *error = nil;
    if (error) {
        [self.delegate sdkInitialization:self completed:NO];
    } else {
        [self.delegate sdkInitialization:self completed:YES];
    }
}

@end
