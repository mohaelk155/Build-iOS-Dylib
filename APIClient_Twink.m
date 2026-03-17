#import "APIClient_Twink.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import "EncryptedStrings.h"
#import "AntiDebug.h"

// ============================================
// UTILITY: Mostrar notificación flotante
// ============================================

@interface FIXToast : NSObject
+ (void)show:(NSString *)message;
@end

@implementation FIXToast

+ (void)show:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    keyWindow = scene.windows.firstObject;
                    break;
                }
            }
        } else {
            keyWindow = [UIApplication sharedApplication].keyWindow;
        }
        
        if (!keyWindow) return;
        
        UIView *toast = [[UIView alloc] initWithFrame:CGRectMake(20, 100, keyWindow.bounds.size.width - 40, 60)];
        toast.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.9];
        toast.layer.cornerRadius = 12;
        toast.layer.borderWidth = 2;
        toast.layer.borderColor = [UIColor systemGreenColor].CGColor;
        toast.alpha = 0;
        toast.tag = 9999;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, toast.bounds.size.width - 20, 60)];
        label.text = message;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 3;
        [toast addSubview:label];
        
        [[keyWindow viewWithTag:9999] removeFromSuperview];
        [keyWindow addSubview:toast];
        
        [UIView animateWithDuration:0.3 animations:^{
            toast.alpha = 1.0;
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.3 animations:^{
                    toast.alpha = 0;
                } completion:^(BOOL finished) {
                    [toast removeFromSuperview];
                }];
            });
        }];
    });
}

@end

// ============================================
// PARTE 1: FALSEAR APICLIENT (CON STRINGS ENCRIPTADOS)
// ============================================

@implementation APIClient_Twink

static APIClient_Twink *sharedInstance = nil;
static dispatch_once_t onceToken;

+ (instancetype)sharedAPIClient {
    [AntiDebug applyAllProtections];
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[APIClient_Twink alloc] init];
    });
    
    [FIXToast show:[EncryptedStrings getSharedClient]];
    return sharedInstance;
}

- (void)paid:(void (^)(void))execute {
    [FIXToast show:[EncryptedStrings getPaidExecuted]];
    if (execute) execute();
}

- (void)start:(void (^)(void))onStart init:(void (^)(void))init {
    [FIXToast show:[EncryptedStrings getStartInit]];
    if (onStart) onStart();
    if (init) init();
}

- (void)setToken:(NSString*)token {
    NSString *msg = [NSString stringWithFormat:[EncryptedStrings getSetToken], token];
    [FIXToast show:msg];
}

- (void)hideUI:(BOOL)isHide {
    NSString *msg = [NSString stringWithFormat:[EncryptedStrings getHideUI], isHide];
    [FIXToast show:msg];
}

- (void)strictMode:(BOOL)isStrictMode {
    NSString *msg = [NSString stringWithFormat:[EncryptedStrings getStrictMode], isStrictMode];
    [FIXToast show:msg];
}

- (void)silentMode:(BOOL)isSilentMode {
    NSString *msg = [NSString stringWithFormat:[EncryptedStrings getSilentMode], isSilentMode];
    [FIXToast show:msg];
}

- (id)getPackageDataWithKey:(NSString*)key {
    NSString *msg = [NSString stringWithFormat:[EncryptedStrings getGetPackage], key];
    [FIXToast show:msg];
    return @YES;
}

- (NSString*)getKey {
    [FIXToast show:[EncryptedStrings getGetKey]];
    return [EncryptedStrings getGetKey];
}

- (NSString*)getExpiryDate {
    [FIXToast show:[EncryptedStrings getGetExpiry]];
    return [EncryptedStrings getGetExpiry];
}

- (NSString*)getUDID {
    [FIXToast show:[EncryptedStrings getGetUDID]];
    return [EncryptedStrings getGetUDID];
}

- (NSString*)getDeviceModel {
    NSString *model = [UIDevice currentDevice].model;
    NSString *msg = [NSString stringWithFormat:[EncryptedStrings getGetDevice], model];
    [FIXToast show:msg];
    return model;
}

- (NSString*)getLoginIP {
    [FIXToast show:[EncryptedStrings getGetIP]];
    return [EncryptedStrings getGetIP];
}

- (NSString*)getPackageName {
    [FIXToast show:[EncryptedStrings getGetPackageName]];
    return [EncryptedStrings getGetPackageName];
}

@end

// ============================================
// PARTE 2: BLOQUEAR TELEGRAM (SILENCIOSO)
// ============================================

@interface UIApplication (TelegramFix)
@end

@implementation UIApplication (TelegramFix)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleTelegramMethods];
    });
}

+ (void)swizzleTelegramMethods {
    Class class = [UIApplication class];
    
    // canOpenURL:
    SEL canOpenURLSel = @selector(canOpenURL:);
    Method canOpenURLOriginal = class_getInstanceMethod(class, canOpenURLSel);
    
    IMP canOpenURLNew = imp_implementationWithBlock(^BOOL(id self, NSURL *url) {
        NSString *urlString = url.absoluteString;
        
        if ([urlString containsString:@"t.me"] ||
            [urlString containsString:@"telegram"] ||
            [urlString containsString:@"tg://"]) {
            
            return NO;  // BLOQUEADO SILENCIOSO
        }
        
        return ((BOOL(*)(id, SEL, NSURL*))objc_msgSend)(self, canOpenURLSel, url);
    });
    
    method_setImplementation(canOpenURLOriginal, canOpenURLNew);
    
    // openURL: (iOS 9)
    SEL openURLSel = @selector(openURL:);
    Method openURLOriginal = class_getInstanceMethod(class, openURLSel);
    
    IMP openURLNew = imp_implementationWithBlock(^BOOL(id self, NSURL *url) {
        NSString *urlString = url.absoluteString;
        
        if ([urlString containsString:@"t.me"] ||
            [urlString containsString:@"telegram"] ||
            [urlString containsString:@"tg://"]) {
            
            return NO;  // BLOQUEADO SILENCIOSO
        }
        
        return ((BOOL(*)(id, SEL, NSURL*))objc_msgSend)(self, openURLSel, url);
    });
    
    method_setImplementation(openURLOriginal, openURLNew);
    
    // openURL:options:completionHandler: (iOS 10+)
    SEL openURLOptionsSel = @selector(openURL:options:completionHandler:);
    Method openURLOptionsOriginal = class_getInstanceMethod(class, openURLOptionsSel);
    
    IMP openURLOptionsNew = imp_implementationWithBlock(^(id self, NSURL *url, NSDictionary *options, void (^completion)(BOOL)) {
        NSString *urlString = url.absoluteString;
        
        if ([urlString containsString:@"t.me"] ||
            [urlString containsString:@"telegram"] ||
            [urlString containsString:@"tg://"]) {
            
            if (completion) {
                completion(NO);
            }
            return;
        }
        
        ((void(*)(id, SEL, NSURL*, NSDictionary*, void (^)(BOOL)))objc_msgSend)(
            self, openURLOptionsSel, url, options, completion);
    });
    
    method_setImplementation(openURLOptionsOriginal, openURLOptionsNew);
}

@end

// ============================================
// PARTE 3: SWIZZLING DE APICLIENT
// ============================================

static NSArray *methodNamesToSwizzle() {
    return @[
        @"sharedAPIClient",
        @"paid:",
        @"start:init:",
        @"setToken:",
        @"hideUI:",
        @"strictMode:",
        @"silentMode:",
        @"getPackageDataWithKey:",
        @"getKey",
        @"getExpiryDate",
        @"getUDID",
        @"getDeviceModel",
        @"getLoginIP",
        @"getPackageName"
    ];
}

__attribute__((constructor))
static void initialize() {
    [AntiDebug applyAllProtections];
    
    Class originalClass = objc_getClass("APIClient");
    Class twinkClass = [APIClient_Twink class];
    
    if (!originalClass) {
        [FIXToast show:[EncryptedStrings getAPIClientNotFound]];
        return;
    }
    
    int successCount = 0;
    for (NSString *methodName in methodNamesToSwizzle()) {
        SEL selector = NSSelectorFromString(methodName);
        
        Method originalMethod = NULL;
        Method twinkMethod = NULL;
        
        if ([methodName isEqualToString:@"sharedAPIClient"]) {
            originalMethod = class_getClassMethod(originalClass, selector);
            twinkMethod = class_getClassMethod(twinkClass, selector);
        } else {
            originalMethod = class_getInstanceMethod(originalClass, selector);
            twinkMethod = class_getInstanceMethod(twinkClass, selector);
        }
        
        if (originalMethod && twinkMethod) {
            method_exchangeImplementations(originalMethod, twinkMethod);
            successCount++;
            [FIXToast show:[NSString stringWithFormat:[EncryptedStrings getSwizzlePrefix], methodName]];
        }
    }
    
    [FIXToast show:[NSString stringWithFormat:[EncryptedStrings getSwizzleComplete], successCount]];
}// Forzar nueva compilación - Tue Mar 17 15:20:00 CET 2026
