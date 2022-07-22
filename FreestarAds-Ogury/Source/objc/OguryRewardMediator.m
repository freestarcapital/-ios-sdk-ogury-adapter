//
//  OguryRewardMediator.m
//  FreestarAds-Ogury
//
//  Created by Carlos Alcala on 7/20/22.
//

#import "OguryRewardMediator.h"
#import <OgurySdk/Ogury.h>
#import <OguryAds/OguryAds.h>
#import <OguryChoiceManager/OguryChoiceManager.h>
#import <UIKit/UIKit.h>

@interface OguryRewardMediator() <OguryOptinVideoAdDelegate>

@property (nonatomic, strong) OguryOptinVideoAd *ad;

@end

@implementation OguryRewardMediator

- (void)resetRewardAd {
    self.ad = nil;
}

- (BOOL)canShowRewardAd {
    return YES;
}

- (NSString*)placementId {
    return self.mPartner.placement_id;
}

- (void)loadRewardAd {
    FSTRLog(@"OGURY: loadRewardAd");
    [self resetRewardAd];

    self.ad = [[OguryOptinVideoAd alloc] initWithAdUnitId:[self placementId]];
    [self.ad load];
    self.ad.delegate = self;
}

#pragma mark - showing

- (void)showAd {
    if ([self.ad isLoaded]) {
        FSTRLog(@"OGURY: showAd");
        [self.ad showAdInViewController:self.presenter];
    } else {
        [self partnerAdShowFailed:@"OGURY: No reward ad available to show."];
    }
}

#pragma mark - OguryOptinVideoAdDelegate

- (void)didLoadOguryRewardAd:(OguryOptinVideoAd *)reward {
    FSTRLog(@"OGURY: didLoadOguryRewardAd");
    [self partnerAdLoaded];
}

- (void)didClickOguryRewardAd:(OguryOptinVideoAd *)optinVideo {
    FSTRLog(@"OGURY: didClickOguryRewardAd");
    [self partnerAdClicked];
}
- (void)didCloseOguryRewardAd:(OguryOptinVideoAd *)optinVideo {
    FSTRLog(@"OGURY: didCloseOguryRewardAd");
}

- (void)didDisplayOguryRewardAd:(OguryOptinVideoAd *)optinVideo {
    FSTRLog(@"OGURY: didDisplayOguryRewardAd");
    [self partnerAdShown];
}

- (void)didFailOguryRewardAdWithError:(OguryError *)error forAd:(OguryOptinVideoAd *)optinVideo {
    FSTRLog(@"OGURY: didFailOguryRewardAdWithError %@", [error localizedDescription]);
    [self partnerAdLoadFailed:[NSString stringWithFormat:@"%ld", (long)error.code]];
}

- (void)didTriggerImpressionOguryRewardAd:(OguryOptinVideoAd *)optinVideo {
    FSTRLog(@"OGURY: didTriggerImpressionOguryRewardAd");
}

- (UIViewController *)presentingViewControllerForOguryAdsRewardAd:(OguryOptinVideoAd*)optinVideo {
    return self.presenter;
}

@end
