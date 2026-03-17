#import "APIClient_Twink.h"
#import "FIXToast.h"
#import "EncryptedStrings.h"
#import "AntiDebug.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

static APIClient_Twink *sharedInstance = nil;
static dispatch_once_t onceToken;

@implementation APIClient_Twink

+ (instancetype)sharedAPIClient {
    [AntiDebug applyAllProtections];
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[APIClient_Twink alloc] init];
    });
    
    [FIXToast show:getSharedClient()];
    return sharedInstance;
}

- (void)paid:(void (^)(void))execute {
    [FIXToast show:getPaidExecuted()];
    if (execute) execute();
}

- (void)start:(void (^)(void))onStart init:(void (^)(void))init {
    [FIXToast show:getStartInit()];
    if (onStart) onStart();
    if (init) init();
}

- (void)setToken:(NSString*)token {
    NSString *msg = [NSString stringWithFormat:getSetToken(), token];
    [FIXToast show:msg];
}

- (void)hideUI:(BOOL)isHide {
    NSString *msg = [NSString stringWithFormat:getHideUI(), isHide];
    [FIXToast show:msg];
}

- (void)strictMode:(BOOL)isStrictMode {
    NSString *msg = [NSString stringWithFormat:getStrictMode(), isStrictMode];
    [FIXToast show:msg];
}

- (void)silentMode:(BOOL)isSilentMode {
    NSString *msg = [NSString stringWithFormat:getSilentMode(), isSilentMode];
    [FIXToast show:msg];
}

- (id)getPackageDataWithKey:(NSString*)key {
    NSString *msg = [NSString stringWithFormat:getGetPackage(), key];
    [FIXToast show:msg];
    return @YES;
}

- (NSString*)getKey {
    [FIXToast show:getGetKey()];
    return @"Invalid";
}

- (NSString*)getExpiryDate {
    [FIXToast show:getGetExpiry()];
    return @"2999-12-40";
}

- (NSString*)getUDID {
    [FIXToast show:getGetUDID()];
    return @"li7wak762o3";
}

- (NSString*)getDeviceModel {
    NSString *model = [UIDevice currentDevice].model;
    NSString *msg = [NSString stringWithFormat:getGetDevice(), model];
    [FIXToast show:msg];
    return model;
}

- (NSString*)getLoginIP {
    [FIXToast show:getGetIP()];
    return @"127.0.0.1";
}

- (NSString*)getPackageName {
    [FIXToast show:getGetPackageName()];
    return @"com.dts.freefireth";
}

@end