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
    FSTRLog(@"OGURY: didLoadOguryOptinVideoAd");
    [self partnerAdLoaded];
}

- (void)didDisplayOguryOptinVideoAd:(OguryOptinVideoAd *)optinVideo {
    FSTRLog(@"OGURY: didDisplayOguryOptinVideoAd");
}

- (void)didClickOguryOptinVideoAd:(OguryOptinVideoAd *)optinVideo {
    FSTRLog(@"OGURY: didClickOguryOptinVideoAd");
    [self partnerAdClicked];
}

- (void)didCloseOguryOptinVideoAd:(OguryOptinVideoAd *)optinVideo {
    FSTRLog(@"OGURY: didCloseOguryOptinVideoAd");
    [self partnerAdDone];
}

- (void)didFailOguryOptinVideoAdWithError:(OguryError *)error
                                    forAd:(OguryOptinVideoAd *)optinVideo {
    FSTRLog(@"OGURY: didFailOguryOptinVideoAdWithError %@", [error localizedDescription]);
    [self partnerAdLoadFailed:[NSString stringWithFormat:@"%ld", (long)error.code]];
}

- (void)didTriggerImpressionOguryOptinVideoAd:(OguryOptinVideoAd *)optinVideo {
    FSTRLog(@"OGURY: didTriggerImpressionOguryOptinVideoAd");
}

- (void)didRewardOguryOptinVideoAdWithItem:(OGARewardItem *)item forAd:(OguryOptinVideoAd *)optinVideo {
    // Reward the user here
    FSTRLog(@"OGURY: didRewardOguryOptinVideoAdWithItem");
    FSTRLog(@"OGURY: rewardName: ", item.rewardName);
    FSTRLog(@"OGURY: rewardValue: ", item.rewardValue);

    if (item.rewardName == nil || item.rewardValue == nil) {
        FSTRLog(@"OGURY: Error invalid reward item");
        return;
    }

    [self partnerAdFinished:@[item.rewardName, item.rewardValue]];
}

@end
