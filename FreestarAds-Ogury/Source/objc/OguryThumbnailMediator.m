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

@interface OguryThumbnailMediator()<OguryAdsThumbnailAdDelegate, FSTRMediatorEnabling>

@property (nonatomic, strong) OguryAdsThumbnailAd *thumbnail;
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
    self.thumbnail = [[OguryAdsThumbnailAd alloc]initWithAdUnitID:[self.mPartner adunitId]];
    self.thumbnail.thumbnailAdDelegate = self;

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

-(void)oguryAdsThumbnailAdAdAvailable {
    FSTRLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)oguryAdsThumbnailAdAdLoaded {
    FSTRLog(@"%s", __PRETTY_FUNCTION__);

    [self partnerAdLoaded];
}

- (void)oguryAdsThumbnailAdAdClosed {
    FSTRLog(@"%s", __PRETTY_FUNCTION__);

    [self partnerAdDone];
}

- (void)oguryAdsThumbnailAdAdDisplayed {
    FSTRLog(@"%s", __PRETTY_FUNCTION__);

    [self partnerAdShown];
}

- (void)oguryAdsThumbnailAdAdClicked {
    FSTRLog(@"%s", __PRETTY_FUNCTION__);

    [self partnerAdClicked];
}

- (void)oguryAdsThumbnailAdAdNotAvailable {
    FSTRLog(@"%s", __PRETTY_FUNCTION__);
    NSString *errorMsg = [NSString stringWithFormat:@"Error : oguryAdsThumbnailAdAdNotAvailable"];
    FSTRLog(@"OGURY: Error: %@", errorMsg);

    [self partnerAdLoadFailed:errorMsg];
}

- (void)oguryAdsThumbnailAdAdError:(OguryAdsErrorType)errorType {
    FSTRLog(@"%s", __PRETTY_FUNCTION__);
    NSString *errorMsg = [NSString stringWithFormat:@"Error : %ld", errorType];
    FSTRLog(@"OGURY: Error: %@", errorMsg);

    [self partnerAdLoadFailed:errorMsg];
}

-(void)oguryAdsThumbnailAdAdNotLoaded {
    FSTRLog(@"%s", __PRETTY_FUNCTION__);
    NSString *errorMsg = [NSString stringWithFormat:@"Error : oguryAdsThumbnailAdAdNotLoaded"];
    FSTRLog(@"OGURY: Error: %@", errorMsg);

    [self partnerAdLoadFailed:errorMsg];
}

-(void)oguryAdsThumbnailAdOnAdImpression {
    FSTRLog(@"%s", __PRETTY_FUNCTION__);

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

