#import <Foundation/Foundation.h>

@interface AntiDebug : NSObject
+ (void)applyAllProtections;
+ (BOOL)isDebuggerAttached;
+ (void)ptraceDenyAttach;
+ (void)detectFrida;
+ (void)checkIntegrity;
@end