#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(LiveNotificationModule, NSObject)

RCT_EXTERN_METHOD(requestPermissions:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(sendStandardNotification:(NSString *)title
                  body:(NSString *)body
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(startLiveActivity:(NSString *)restaurantName
                  status:(NSString *)status
                  timeRange:(NSString *)timeRange
                  step:(nonnull NSNumber *)step
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(updateLiveActivity:(NSString *)status
                  timeRange:(NSString *)timeRange
                  step:(nonnull NSNumber *)step
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(endLiveActivity:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

@end
