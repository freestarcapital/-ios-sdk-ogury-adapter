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

@property (nonatomic, strong) OguryInterstitialAd *ad;

@end

@implementation OguryInterstitialMediator

- (void)resetInterstitialAd {
    self.ad = nil;
}

- (BOOL)canShowInterstitialAd {
    return YES;
}

- (void)loadInterstitialAd {
    FSTRLog(@"OGURY: loadInterstitialAd");
    [self resetInterstitialAd];

    FSTRLog(@"OGURY: placement_id %@", self.mPartner.placement_id);
    FSTRLog(@"OGURY: adunitId %@", [self.mPartner adunitId]);

    self.ad = [[OguryInterstitialAd alloc] initWithAdUnitId:[self.mPartner adunitId]];
    self.ad.delegate = self;
    [self.ad load];
}

#pragma mark - showing

- (void)showAd {
    if ([self.ad isLoaded]) {
        FSTRLog(@"OGURY: showAd");
        [self.ad showAdInViewController:self.presenter];
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
