#import <Foundation/Foundation.h>

@interface EncryptedStrings : NSObject

+ (NSString*)getSharedClient;
+ (NSString*)getPaidExecuted;
+ (NSString*)getStartInit;
+ (NSString*)getSetToken;
+ (NSString*)getHideUI;
+ (NSString*)getStrictMode;
+ (NSString*)getSilentMode;
+ (NSString*)getGetPackage;
+ (NSString*)getGetKey;
+ (NSString*)getGetExpiry;
+ (NSString*)getGetUDID;
+ (NSString*)getGetDevice;
+ (NSString*)getGetIP;
+ (NSString*)getGetPackageName;
+ (NSString*)getSwizzlePrefix;
+ (NSString*)getNoSwizzle;
+ (NSString*)getSwizzleComplete;
+ (NSString*)getAPIClientNotFound;
+ (NSString*)getDylibLoaded;

@end