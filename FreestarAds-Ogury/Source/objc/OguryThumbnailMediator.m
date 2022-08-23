//
//  OguryThumbnailMediator.m
//  FreestarAds-Ogury
//
//  Created by Carlos Alcala on 8/08/22.
//

#import "OguryThumbnailMediator.h"
#import <UIKit/UIKit.h>
#import <OguryChoiceManager/OguryChoiceManager.h>
#import <OguryAds/OguryAds.h>

@interface OguryThumbnailMediator()<OguryThumbnailAdDelegate, FSTRMediatorEnabling>

@property (nonatomic, strong) OguryThumbnailAd *thumbnail;
@property CGSize requestedSize;
@property CGPoint startPoint;
@property(nonatomic, assign) FreestarThumbnailAdSize freestarAdSize;

@end

@implementation OguryThumbnailMediator

- (BOOL)isEnabledForMediatorFormat:(FSTRMediatorFormatType)type {
    switch (type) {
        case FSTRMediatorFormatTypeThumbnail:
            return YES;
        default:
            return NO;
    }
}

- (BOOL)canShowThumbnailAd {
    return YES;
}

-(void)loadThumbnailAd {
    FSTRLog(@"OGURY: loadThumbnailAd");
    FSTRLog(@"OGURY: adunitId %@", [self.mPartner adunitId]);

    if ([self.mPartner adunitId] == nil) {
        [self partnerAdLoadFailed:@"adunitId is nil"];
        return;
    }

    self.startPoint = CGPointMake(100, 500);
    self.thumbnail = [[OguryThumbnailAd alloc] initWithAdUnitId:[self.mPartner adunitId]];
    self.thumbnail.delegate = self;

    [self.thumbnail setWhitelistBundleIdentifiers:[Freestar getWhitelistBundleIdentifiers]];
    [self.thumbnail setBlacklistViewControllers:[Freestar getBlacklistViewControllers]];

    [self.thumbnail load];
}

#pragma mark - showing

- (void)showAd {
    FSTRLog(@"OGURY: showAd");

    if ([self.thumbnail isLoaded]) {
        [self.thumbnail show:self.startPoint];
    }
}

#pragma mark - OguryAds Delegate

- (void)didLoadOguryThumbnailAd:(OguryThumbnailAd *)thumbnail {
    FSTRLog(@"OGURY: didLoadOguryThumbnailAd");

    self.thumbnail = thumbnail;
    [self partnerAdLoaded];
}

- (void)didDisplayOguryThumbnailAd:(OguryThumbnailAd *)thumbnail {
    FSTRLog(@"OGURY: didDisplayOguryBannerAd");
    [self partnerAdShown];
}

- (void)didClickOguryThumbnailAd:(OguryThumbnailAd *)thumbnail {
    FSTRLog(@"OGURY: didClickOguryThumbnailAd");
    [self partnerAdClicked];
}

- (void)didCloseOguryThumbnailAd:(OguryThumbnailAd *)thumbnail {
    FSTRLog(@"OGURY: didCloseOguryThumbnailAd");
    [self partnerAdDone];
}

- (void)didFailOguryThumbnailAdWithError:(OguryError *)error forAd:(OguryThumbnailAd *)thumbnail {
    FSTRLog(@"OGURY: didFailOguryThumbnailAdWithError %@", [error localizedDescription]);

   [self partnerAdLoadFailed:[NSString stringWithFormat:@"%ld", (long)error.code]];
}

- (void)didTriggerImpressionOguryThumbnailAd:(OguryThumbnailAd *)thumbnail {
    FSTRLog(@"OGURY: didTriggerImpressionOguryThumbnailAd");
}

#pragma mark - Helper Mediator Functions
- (BOOL)supportsThumbnail:(FreestarThumbnailAdSize)adSize {
    self.freestarAdSize = adSize;
    switch(adSize){
        case FreestarThumbnail180x180:
            self.requestedSize = CGSizeMake(180, 180);
            return YES;
        default:
            return NO;
    }
}

@end
