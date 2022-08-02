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

- (void)loadRewardAd {
    FSTRLog(@"OGURY: loadRewardAd");
    [self resetRewardAd];

    FSTRLog(@"OGURY: adunitId %@", [self.mPartner adunitId]);

    if ([self.mPartner adunitId] == nil) {
        [self partnerAdLoadFailed:@"adunitId is nil"];
        return;
    }

    self.ad = [[OguryOptinVideoAd alloc] initWithAdUnitId:[self.mPartner adunitId]];
    self.ad.delegate = self;
    [self.ad load];
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

- (void)didLoadOguryOptinVideoAd:(OguryOptinVideoAd *)optinVideo {
    FSTRLog(@"%s", __PRETTY_FUNCTION__);
    // implement your callback
}

- (void)didDisplayOguryOptinVideoAd:(OguryOptinVideoAd *)optinVideo {
    FSTRLog(@"%s", __PRETTY_FUNCTION__);
    // implement your callback
}

- (void)didClickOguryOptinVideoAd:(OguryOptinVideoAd *)optinVideo {
    FSTRLog(@"%s", __PRETTY_FUNCTION__);
    // implement your callback
}

- (void)didCloseOguryOptinVideoAd:(OguryOptinVideoAd *)optinVideo {
    FSTRLog(@"%s", __PRETTY_FUNCTION__);
    // implement your callback
}

- (void)didFailOguryOptinVideoAdWithError:(OguryError *)error
                                    forAd:(OguryOptinVideoAd *)optinVideo {
    FSTRLog(@"%s", __PRETTY_FUNCTION__);
    // implement your callback
}

- (void)didTriggerImpressionOguryOptinVideoAd:(OguryOptinVideoAd *)optinVideo {
    FSTRLog(@"%s", __PRETTY_FUNCTION__);
    // implement your callback
}

- (void)didRewardOguryOptinVideoAdWithItem:(OGARewardItem *)item forAd:(OguryOptinVideoAd *)optinVideo {
    // Reward the user here
    FSTRLog(@"OGURY: didRewardOguryOptinVideoAdWithItem");
    FSTRLog(@"OGURY: optinVideo: ", optinVideo);
    FSTRLog(@"OGURY: rewardName: ", item.rewardName);
    FSTRLog(@"OGURY: rewardValue: ", item.rewardValue);

    // potential crash issue
    [self partnerAdFinished:@[item.rewardName, item.rewardValue]];
    FSTRLog(@"");
}

#pragma mark - OguryOptinVideoAdDelegate - DEPRECATED???

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
    [self partnerAdDone];
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
