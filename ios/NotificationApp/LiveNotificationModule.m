#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(LiveNotificationModule, NSObject)

RCT_EXTERN_METHOD(requestPermissions:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(sendStandardNotification:(NSString *)title
                  body:(NSString *)body
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(startLiveActivity:(NSString *)scenarioType
                  title:(NSString *)title
                  status:(NSString *)status
                  subtitle:(NSString *)subtitle
                  timeRange:(NSString *)timeRange
                  currentStep:(nonnull NSNumber *)currentStep
                  totalSteps:(nonnull NSNumber *)totalSteps
                  badgeText:(NSString *)badgeText
                  accentColor:(NSString *)accentColor
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(updateLiveActivity:(NSString *)status
                  subtitle:(NSString *)subtitle
                  timeRange:(NSString *)timeRange
                  currentStep:(nonnull NSNumber *)currentStep
                  badgeText:(NSString *)badgeText
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(endLiveActivity:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

@end
