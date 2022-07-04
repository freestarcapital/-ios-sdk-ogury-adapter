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

- (BOOL)determineSizeIsAdaptive:(GADAdSize)adSize {
    return ([self isAdaptiveEnabled]
            && self.freestarAdSize == FreestarBanner320x50)
            && (adSize.size.width != 320 || adSize.size.height != 50);
}

-(void)loadBannerAd {
    [self loadInlineInviewAd];
}

- (void)loadInlineInviewAd {
    GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers =
        @[GADSimulatorID, @"2077ef9a63d2b398840261c8221a0c9a"];
    
    self.ad = [[GAMBannerView alloc] initWithAdSize:self.requestedSize];
    if ([self isAdaptiveEnabled]
        && [self determineSizeIsAdaptive:self.ad.adSize]) {
        // GAM supports multi-size requests
        self.ad.validAdSizes = @[NSValueFromGADAdSize(self.requestedSize), NSValueFromGADAdSize(GADAdSizeBanner)];
    }
        
    self.ad.adUnitID = [self.mPartner adunitId];    
    self.ad.rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    
    if ([[FreestarInternal privacySettings] coppaApplies]) {
        [GADMobileAds.sharedInstance.requestConfiguration tagForChildDirectedTreatment:YES];
    }
    
    self.ad.delegate = self;
    
    GAMRequest *request = [[GAMRequest alloc] init];
    if (self.customTargeting) {
        request.customTargeting = self.customTargeting;
    }
    [self.ad loadRequest:request];
}


#pragma mark - showing

- (void)showAd {
    if (self.ad) {
        // Place the ad view onto the screen.
        [self.container placeAdContent:self.ad];
    }
}

#pragma mark - GADBannerViewDelegate

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
