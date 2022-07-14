//
//  OguryInterstitialMediator.m
//  FreestarAds-Ogury
//
//  Created by Carlos Alcala on 7/13/22.
//

#import "OguryInterstitialMediator.h"
#import <OgurySdk/Ogury.h>
#import <OguryAds/OguryAds.h>
#import <UIKit/UIKit.h>
#import <OguryChoiceManager/OguryChoiceManager.h>

@interface OguryInterstitialMediator()<OguryInterstitialAdDelegate, FSTRMediatorEnabling>

@property (nonatomic, strong) OguryInterstitialAd *interstitialAd;

@end

@implementation OguryInterstitialMediator

- (void)resetInterstitialAd {
    [self resetInterstitialAd];
    self.interstitialAd = nil;
}

- (BOOL)canShowInterstitialAd {
    return YES;
}

- (NSString*)placementId {
    return self.mPartner.placement_id;
}

- (void)loadInterstitialAd {
    FSTRLog(@"OGURY: loadInterstitialAd");
    [self resetInterstitialAd];

    self.interstitialAd = [[OguryInterstitialAd alloc] initWithAdUnitId:[self placementId]];
    [self.interstitialAd load];
    self.interstitialAd.delegate = self;
}

#pragma mark - showing

- (void)showAd {
    if ([self.interstitialAd isLoaded]) {
        FSTRLog(@"OGURY: showAd");
        [self.interstitialAd showAdInViewController:self.presenter];
    } else {
        [self partnerAdShowFailed:@"OGURY: No interstitial ad available to show."];
    }
}

#pragma mark - OguryInterstitialAdDelegate

- (void)didLoadOguryInterstitialAd:(OguryInterstitialAd *)interstitial {
    FSTRLog(@"OGURY: didLoadOguryInterstitialAd");
    [self partnerAdLoaded];
}

- (void)didClickOguryInterstitialAd:(OguryInterstitialAd *)interstitial {
    FSTRLog(@"OGURY: didClickOguryInterstitialAd");
    [self partnerAdClicked];
}
- (void)didCloseOguryInterstitialAd:(OguryInterstitialAd *)interstitial {
    FSTRLog(@"OGURY: didCloseOguryInterstitialAd");
}

- (void)didDisplayOguryInterstitialAd:(OguryInterstitialAd *)interstitial {
    FSTRLog(@"OGURY: didDisplayOguryInterstitialAd");
    [self partnerAdShown];
}

- (void)didFailOguryInterstitialAdWithError:(OguryError *)error forAd:(OguryInterstitialAd *)interstitial {
    FSTRLog(@"OGURY: didFailOguryInterstitialAdWithError %@", [error localizedDescription]);
    [self partnerAdLoadFailed:[NSString stringWithFormat:@"%ld", (long)error.code]];
}

- (void)didTriggerImpressionOguryInterstitialAd:(OguryInterstitialAd *)interstitial {
    FSTRLog(@"OGURY: didTriggerImpressionOguryInterstitialAd");
}

- (UIViewController *)presentingViewControllerForOguryAdsInterstitialAd:(OguryInterstitialAd*)interstitial {
    return self.presenter;
}

@end
