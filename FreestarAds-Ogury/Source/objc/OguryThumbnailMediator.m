//
//  OguryThumbnailMediator.m
//  FreestarAds-Ogury
//
//  Created by Carlos Alcala on 8/08/22.
//

#import "OguryThumbnailMediator.h"
#import <UIKit/UIKit.h>
#import <OgurySdk/Ogury.h>
#import <OguryAds/OguryAds.h>
#import <OguryChoiceManager/OguryChoiceManager.h>

@interface OguryThumbnailMediator()<OguryThumbnailAdDelegate, FSTRMediatorEnabling>

@property (nonatomic, strong) OguryThumbnailAd *ad;
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

    self.startPoint = CGPointMake(0, 0);

    self.ad = [[OguryThumbnailAd alloc] initWithAdUnitId:[self.mPartner adunitId]];
    self.ad.delegate = self;
    [self.ad load:self.requestedSize];
}

#pragma mark - showing

- (void)showAd {
    FSTRLog(@"OGURY: showAd");

    if ([self.ad isLoaded]) {
        [self.ad show:self.startPoint];
    }
}

#pragma mark - OguryBannerAdDelegate

- (void)didLoadOguryThumbnailAd:(OguryThumbnailAd *)thumbnail {
    FSTRLog(@"OGURY: didLoadOguryThumbnailAd");

    self.ad = thumbnail;
    [self partnerAdLoaded];
}

- (void)didClickOguryThumbnailAd:(OguryThumbnailAd *)thumbnail {
    FSTRLog(@"OGURY: didClickOguryThumbnailAd");
    [self partnerAdClicked];
}

- (void)didCloseOguryThumbnailAd:(OguryThumbnailAd *)thumbnail {
    FSTRLog(@"OGURY: didCloseOguryThumbnailAd");
    [self partnerAdDone];
}

- (void)didDisplayOguryThumbnailAd:(OguryThumbnailAd *)thumbnail {
    FSTRLog(@"OGURY: didDisplayOguryThumbnailAd");

    [self partnerAdShown];
}

- (void)didFailOguryThumbnailAdWithError:(OguryError *)error forAd:(OguryThumbnailAd *)thumbnail {
    FSTRLog(@"OGURY: didFailOguryThumbnailAdWithError %@", [error localizedDescription]);

   [self partnerAdLoadFailed:[NSString stringWithFormat:@"%ld", (long)error.code]];
}

- (void)didTriggerImpressionOguryThumbnailAd:(OguryThumbnailAd *)thumbnail {
    FSTRLog(@"OGURY: didTriggerImpressionOguryThumbnailAd");
}

- (UIViewController *)presentingViewControllerForOguryAdsBannerAd:(OguryBannerAd*)banner {
    FSTRLog(@"OGURY: presentingViewControllerForOguryAdsBannerAd");
    return self.presenter;
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

