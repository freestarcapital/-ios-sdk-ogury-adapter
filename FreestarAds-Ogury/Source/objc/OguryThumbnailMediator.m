//
//  OguryThumbnailMediator.m
//  FreestarAds-Ogury
//
//  Created by Carlos Alcala on 8/08/22.
//

#import <UIKit/UIKit.h>
#import <OgurySdk/Ogury.h>
#import <OguryAds/OguryAds.h>
#import <OguryChoiceManager/OguryChoiceManager.h>

@interface OguryThumbnailMediator()<OguryThumbnailAdDelegate, FSTRMediatorEnabling>

@property (nonatomic, strong) OguryThumbnailAd *ad;

@end

@implementation OguryThumbnailMediator

- (BOOL)isEnabledForMediatorFormat:(FSTRMediatorFormatType)type {
    switch (type) {
        case FSTRMediatorFormatTypeThumbnail:
        //case FSTRMediatorFormatTypeInline:
            return YES;
        default:
            return NO;
    }
}

- (BOOL)canShowThumbnailAd {
    return YES;
}

//- (BOOL)canShowInlineInviewAd {
//    return YES;
//}

- (BOOL)isAdaptiveEnabled {
    return [Freestar adaptiveThumbnailEnabled];
}

-(void)loadThumbnailAd {
    [self.thumbnailAd load];
}

- (void)loadInlineInviewAd {
    FSTRLog(@"OGURY: loadThumbnailAd");
    FSTRLog(@"OGURY: adunitId %@", [self.mPartner adunitId]);

    if ([self.mPartner adunitId] == nil) {
        [self partnerAdLoadFailed:@"adunitId is nil"];
        return;
    }

    self.ad = [[OguryThumbnailAd alloc] initWithAdUnitId:[self.mPartner adunitId]];
 //   self.ad.delegate = self;
//    [self.ad loadWithSize:self.requestedSize];
    self.ad.OguryThumbnailAdDelegate = self;
    [self.ad load:CGSizeMake(maxWidth, maxHeight)];
}

- (void)oguryAdsThumbnailAdAdLoaded {
    [self.ad show:CGPointMake(leftMargin, topMargin)];
}

#pragma mark - showing

- (void)showAd {
    if (self.ad) {
        FSTRLog(@"OGURY: showAd - placeAdContent");

        self.ad.frame = [self frameFromSize:self.requestedSize];
        [self.container placeAdContent:self.ad];
    }
}

//- (CGRect)frameFromSize:(OguryAdsBannerSize*)size {
//    return CGRectMake(0, 0, (CGFloat)size.getSize.width, (CGFloat)size.getSize.height);
//}

#pragma mark - OguryBannerAdDelegate

- (void)didLoadOguryThumbnailAd:(OguryThumbnailAd *)thumbnail {
    FSTRLog(@"OGURY: didLoadOguryThumbnailAd");

    self.ad = banner;
    [self partnerAdLoaded];
    [self.ad show:CGPointMake(leftMargin, topMargin)];
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

//#pragma mark - Helper Mediator Functions
//- (BOOL)supportsBanner:(FreestarBannerAdSize)adSize {
//    self.freestarAdSize = adSize;
//    switch(adSize){
//        case FreestarBanner320x50:
//            self.requestedSize = [OguryAdsBannerSize small_banner_320x50];
//            return YES;
//        case FreestarBanner300x250:
//            self.requestedSize = [OguryAdsBannerSize mpu_300x250];
//            return YES;
//        case FreestarBanner728x90:
//        default:
//            return NO;
//    }
//}

@end

