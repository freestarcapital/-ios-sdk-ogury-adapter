//
//  OguryRewardMediator.m
//  FreestarAds-Ogury
//
//  Created by Carlos Alcala on 7/20/22.
//

#import "OguryRewardMediator.h"
#import <OgurySdk/Ogury.h>
#import <OguryAds/OguryAds.h>
#import <UIKit/UIKit.h>
#import <OguryChoiceManager/OguryChoiceManager.h>

@interface OguryRewardMediator() <OguryOptinVideoAdDelegate>

@property (nonatomic, strong) OguryOptinVideoAd *optinVideoAd;

@end

@implementation OguryRewardMediator

- (void)resetRewardAd {
    self.rewardAd = nil;
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

    self.rewardAd = [[OguryRewardAd alloc] initWithAdUnitId:[self placementId]];
    [self.rewardAd load];
    self.rewardAd.delegate = self;
}

#pragma mark - showing

- (void)showAd {
    if ([self.rewardAd isLoaded]) {
        FSTRLog(@"OGURY: showAd");
        [self.rewardAd showAdInViewController:self.presenter];
    } else {
        [self partnerAdShowFailed:@"OGURY: No reward ad available to show."];
    }
}

#pragma mark - OguryOptinVideoAdDelegate

- (void)didLoadOguryRewardAd:(OguryRewardAd *)reward {
    FSTRLog(@"OGURY: didLoadOguryRewardAd");
    [self partnerAdLoaded];
}

- (void)didClickOguryRewardAd:(OguryRewardAd *)reward {
    FSTRLog(@"OGURY: didClickOguryRewardAd");
    [self partnerAdClicked];
}
- (void)didCloseOguryRewardAd:(OguryRewardAd *)reward {
    FSTRLog(@"OGURY: didCloseOguryRewardAd");
}

- (void)didDisplayOguryRewardAd:(OguryRewardAd *)reward {
    FSTRLog(@"OGURY: didDisplayOguryRewardAd");
    [self partnerAdShown];
}

- (void)didFailOguryRewardAdWithError:(OguryError *)error forAd:(OguryRewardAd *)reward {
    FSTRLog(@"OGURY: didFailOguryRewardAdWithError %@", [error localizedDescription]);
    [self partnerAdLoadFailed:[NSString stringWithFormat:@"%ld", (long)error.code]];
}

- (void)didTriggerImpressionOguryRewardAd:(OguryRewardAd *)reward {
    FSTRLog(@"OGURY: didTriggerImpressionOguryRewardAd");
}

- (UIViewController *)presentingViewControllerForOguryAdsRewardAd:(OguryRewardAd*)reward {
    return self.presenter;
}

@end
