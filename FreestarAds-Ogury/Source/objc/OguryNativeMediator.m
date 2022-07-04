//
//  OguryNativeMediator.m
//  FreestarAds-Ogury
//
//  Created by Carlos Alcala on 7/04/22.
//

#import "OguryNativeMediator.h"

@interface OguryNativeMediator()

@property FreestarNativeAdSize requestedSize;

@end

@implementation OguryNativeMediator

- (BOOL)canShowNativeAd {
    FSTRLog(@"OGURY: Can show native ad.");
    return YES;
}

- (void)loadNativeAd {
    // load native ad
    FSTRLog(@"OGURY: Loading native ad...");
    NSError *error = [[NSError alloc] initWithDomain:@"com.ogury.native.error"
                                                code:1
                                            userInfo:@{ NSLocalizedDescriptionKey : @"Native ad failed to load."}];
    const NSTimeInterval delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        if (error) {
            [self didFailToReceiveNativeAdWithError:error];
        } else {
            [self didReceiveNativeAd];
        }
        
    });
}

- (void)applyNativeTemplate:(FreestarNativeAdSize)adSize {
    // apply native template
    FSTRLog(@"OGURY: Apply size to native ad.");
    self.requestedSize = adSize;
}

- (UIView *)adViewFromTemplateNib {
    // load native template
    FSTRLog(@"OGURY: Return native template adview.");
    return nil;
}

- (void)showAd {
    // show ad
    FSTRLog(@"OGURY: Return native template adview.");
}

#pragma mark - Ogury native loader delegate

- (void)didReceiveNativeAd {
    // fill
    FSTRLog(@"OGURY: Native ad loaded.");
}

- (void)didFailToReceiveNativeAdWithError:(NSError*)error {
    // no fill
    FSTRLog(@"OGURY: %@", [error localizedDescription]);
}

@end
