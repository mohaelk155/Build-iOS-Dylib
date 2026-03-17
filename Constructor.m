#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "APIClient_Twink.h"
#import "FIXToast.h"
#import "EncryptedStrings.h"
#import "AntiDebug.h"

static const char* methodNames[] = {
    "sharedAPIClient",
    "paid:",
    "start:init:",
    "setToken:",
    "hideUI:",
    "strictMode:",
    "silentMode:",
    "getPackageDataWithKey:",
    "getKey",
    "getExpiryDate",
    "getUDID",
    "getDeviceModel",
    "getLoginIP",
    "getPackageName"
};

static int methodCount = 14;

static void swizzleMethod(Class originalClass, Class twinkClass, const char* methodName, BOOL isClassMethod) {
    SEL selector = sel_registerName(methodName);
    
    Method originalMethod = isClassMethod ? 
        class_getClassMethod(originalClass, selector) :
        class_getInstanceMethod(originalClass, selector);
    
    Method twinkMethod = isClassMethod ?
        class_getClassMethod(twinkClass, selector) :
        class_getInstanceMethod(twinkClass, selector);
    
    if (originalMethod && twinkMethod) {
        method_exchangeImplementations(originalMethod, twinkMethod);
        
        NSString *msg = [NSString stringWithFormat:getSwizzlePrefix(), 
                        [NSString stringWithUTF8String:methodName]];
        [FIXToast show:msg];
    } else {
        NSString *msg = [NSString stringWithFormat:getNoSwizzle(), 
                        [NSString stringWithUTF8String:methodName]];
        [FIXToast show:msg];
    }
}

__attribute__((constructor))
static void initialize() {
    [AntiDebug applyAllProtections];
    
    usleep(arc4random() % 100000);
    
    Class originalClass = objc_getClass("APIClient");
    Class twinkClass = [APIClient_Twink class];
    
    if (!originalClass) {
        [FIXToast show:getAPIClientNotFound()];
        return;
    }
    
    int successCount = 0;
    for (int i = 0; i < methodCount; i++) {
        BOOL isClassMethod = (i == 0);
        
        @try {
            swizzleMethod(originalClass, twinkClass, methodNames[i], isClassMethod);
            successCount++;
        } @catch (NSException *e) {
        }
    }
    
    NSString *msg = [NSString stringWithFormat:getSwizzleComplete(), successCount];
    [FIXToast show:msg];
    
    volatile char *ptr = (char *)&initialize;
    for(int i = 0; i < 256; i++) {
        ptr[i] = arc4random() & 0xFF;
    }
}