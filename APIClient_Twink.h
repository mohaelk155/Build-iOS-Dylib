#import <Foundation/Foundation.h>

@interface APIClient_Twink : NSObject
+ (instancetype)sharedAPIClient;
- (void)paid:(void (^)(void))execute;
- (void)start:(void (^)(void))onStart init:(void (^)(void))init;
- (void)setToken:(NSString*)token;
- (void)hideUI:(BOOL)isHide;
- (void)strictMode:(BOOL)isStrictMode;
- (void)silentMode:(BOOL)isSilentMode;
- (id)getPackageDataWithKey:(NSString*)key;
- (NSString*)getKey;
- (NSString*)getExpiryDate;
- (NSString*)getUDID;
- (NSString*)getDeviceModel;
- (NSString*)getLoginIP;
- (NSString*)getPackageName;
@end