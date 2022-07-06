//
// Copyright (c) 2020 Ogury Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OguryCore/OguryPersistentEventBus.h>

NS_ASSUME_NONNULL_BEGIN

@interface OGAInternal : NSObject

+ (instancetype)shared;

- (void)startWithAssetKey:(NSString * _Nullable)assetKey eventBus:(OguryPersistentEventBus * _Nullable)eventBus;

- (NSString *)getVersion;

- (NSString *)getBuildVersion;

- (void)defineSDKType:(NSUInteger)sdkType;

- (void)defineMediationName:(NSString *)mediationName;

@end

NS_ASSUME_NONNULL_END
