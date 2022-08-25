//
//  OguryFSTRPartnerInitializer.m
//  FreestarAds-Ogury
//
//  Created by Carlos Alcala on 7/04/22.
//

#import "OguryFSTRPartnerInitializer.h"
#import <OguryAds/OguryAds.h>
#import <OguryChoiceManager/OguryChoiceManager.h>
#import <OgurySdk/Ogury.h>

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
    FSTRLog(@"OGURY: app_id: %@", [self.partners.firstObject app_id]);

    if (self.partners
        && self.partners.count > 0
        && [self.partners.firstObject app_id]) {

        OguryConfigurationBuilder *configurationBuilder = [[OguryConfigurationBuilder alloc] initWithAssetKey:[self.partners.firstObject app_id]];
        [Ogury startWithConfiguration:[configurationBuilder build]];

        [self.delegate sdkInitialization:self completed:YES];
    } else {
        [self.delegate sdkInitialization:self completed:NO];
    }
}

@end
