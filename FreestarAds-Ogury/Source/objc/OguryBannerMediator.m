//
//  OguryBannerMediator.m
//  FreestarAds-Ogury
//
//  Created by Carlos Alcala on 7/04/22.
//

#import "OguryBannerMediator.h"
#import <FreestarAds/FreestarAds.h>
#import <MobileAds/GoogleMobileAds.h>

@interface OguryBannerMediator () <GADBannerViewDelegate, FSTRMediatorEnabling>

@property GAMBannerView *ad;
@property (nonatomic, strong) OguryBannerAd *ad;
@property GADAdSize requestedSize;
@property(nonatomic, assign) FreestarBannerAdSize freestarAdSize;
@property CGFloat requestedWidth;

@end

@implementation GoogleBannerMediator

- (BOOL)isEnabledForMediatorFormat:(FSTRMediatorFormatType)type {
    switch (type) {
        case FSTRMediatorFormatTypeBanner:
        case FSTRMediatorFormatTypeInline:        
            return YES;
        default:
            return NO;
    }
}

- (BOOL)canShowInlineInviewAd {
    return YES;
}

- (BOOL)canShowBannerAd {
    return YES;
}

- (BOOL)isAdaptiveEnabled {
    return [Freestar adaptiveBannerEnabled];
}

-(void)loadBannerAd {

    self.ad = [[OguryBannerAd alloc] initWithAdUnitId:@"AD_UNIT_ID"];

    [self.ad loadWithSize:[OguryAdsBannerSize small_banner_320x50]];

//    [self.ad loadWithSize:OguryAdsBannerSize];

    self.ad.delegate = self;
}


#pragma mark - showing

- (void)showAd {
    if (self.ad) {
        // Place the ad view onto the screen.
        [self.container placeAdContent:self.ad];

//        [yourView addSubview:bannerAd];
    }
}

#pragma mark - GADBannerViewDelegate

- (void)didLoadOguryBannerAd:(OguryBannerAd *)banner {
    [self.view addSubview:banner];

    [self partnerAdLoaded];
}

/// Tells the delegate an ad request loaded an ad.
- (void)bannerViewDidReceiveAd:(GADBannerView *)adView {
    FSTRLog(@"adViewDidReceiveAd");
    [self partnerAdLoaded];
}

/// Tells the delegate an ad request failed.
- (void)bannerView:(GADBannerView *)adView didFailToReceiveAdWithError:(NSError *)error {
    FSTRLog(@"adView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
    
   [self partnerAdLoadFailed:[NSString stringWithFormat:@"%ld", (long)error.code]];
}

/// Tells the delegate that a full-screen view will be presented in response
/// to the user clicking on an ad.
- (void)bannerViewWillPresentScreen:(GADBannerView *)adView {
    FSTRLog(@"adViewWillPresentScreen");
    [self partnerAdClicked];
}

/// Tells the delegate that the full-screen view will be dismissed.
- (void)bannerViewWillDismissScreen:(GADBannerView *)adView {
    FSTRLog(@"adViewWillDismissScreen");
}

/// Tells the delegate that the full-screen view has been dismissed.
- (void)bannerViewDidDismissScreen:(GADBannerView *)adView {
    FSTRLog(@"adViewDidDismissScreen");
}

/// Tells the delegate that a user click will open another app (such as
/// the App Store), backgrounding the current app.
- (void)bannerViewWillLeaveApplication:(GADBannerView *)adView {
    FSTRLog(@"adViewWillLeaveApplication");
}

-(BOOL)supportsBanner:(FreestarBannerAdSize)adSize {
    self.freestarAdSize = adSize;
    switch(adSize){
        case FreestarBanner320x50:
            if ([self isAdaptiveEnabled]) {
                self.requestedSize =
                    GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(self.requestedWidth);
            } else {
                self.requestedSize = GADAdSizeBanner;
            }
            return YES;
        case FreestarBanner300x250:
            self.requestedSize = GADAdSizeMediumRectangle;
            return YES;
        case FreestarBanner728x90:
            self.requestedSize = GADAdSizeLeaderboard;
            return YES;
        default:
            return NO;
    }
}

-(void)setAdjustableBannerWidth:(CGFloat)width {
    //default to screenwide ads
    self.requestedWidth = (width && width != 0.0) ? width : UIApplication.sharedApplication.keyWindow.bounds.size.width;
}

- (void)didChangeMediatorStatus:(FSTRMediatorStatus)newStatus {
    switch (newStatus) {
        case FSTRMediatorStatusAuctionWinner:
            if ([self determineSizeIsAdaptive:self.ad.adSize]) {
                // banner creative is adaptive
                [self setAdaptiveBanner:YES];
            }
            break;
        case FSTRMediatorStatusInitial:
        default:
            break;
    }
}

@end
