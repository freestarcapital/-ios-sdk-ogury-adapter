//
//  Copyright © 2021 Ogury Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <OgurySdk/OguryConfiguration.h>
#import <OgurySdk/OguryConfigurationBuilder.h>

NS_ASSUME_NONNULL_BEGIN

@interface Ogury : NSObject

+ (void)startWithConfiguration:(OguryConfiguration *)configuration;

+ (NSString *)getSdkVersion;

@end

NS_ASSUME_NONNULL_END
