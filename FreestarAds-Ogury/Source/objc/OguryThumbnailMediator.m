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
//@property(nonatomic, assign) FreestarThumbnailAdSize AdSize;

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
    [self.ad load];
}

- (void)loadInlineInviewAd {
    FSTRLog(@"OGURY: loadThumbnailAd");
    FSTRLog(@"OGURY: adunitId %@", [self.mPartner adunitId]);

    if ([self.mPartner adunitId] == nil) {
        [self partnerAdLoadFailed:@"adunitId is nil"];
        return;
    }

    self.ad = [[OguryThumbnailAd alloc] initWithAdUnitId:[self.mPartner adunitId]];
    self.ad.delegate = self;
    [self.ad load:self.requestedSize];
}

- (void)oguryAdsThumbnailAdAdLoaded {
    //TODO: setup: leftMargin, topMargin
    [self.ad show:CGPointMake(0, 0)];
}

#pragma mark - showing

- (void)showAd {
    if (self.ad) {
        FSTRLog(@"OGURY: showAd - placeAdContent");

        self.ad.frame = [self frameFromSize:self.requestedSize];
        [self.container placeAdContent:self.ad];
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
- (BOOL)supportsBanner:(FreestarBannerAdSize)adSize {
    self.ad = adSize;
    switch(adSize){
        case FreestarThumbnail180x180:
            self.requestedSize = CGSizeMake(180, 180);
            return YES;
        default:
            return NO;
    }
}

@end

