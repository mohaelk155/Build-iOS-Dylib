#import "EncryptedStrings.h"
#import "CryptoEngine.h"

static unsigned char encrypted_sharedClient[] = { 0xA3, 0xB4, 0xC5, 0xD6, 0xE7, 0xF8, 0x09, 0x1A, 0x2B, 0x3C, 0x4D, 0x5E, 0x6F, 0x70, 0x81, 0x92, 0xA3, 0xB4, 0xC5, 0xD6, 0xE7, 0xF8 };
static unsigned char encrypted_paidExecuted[] = { 0xB2, 0xC3, 0xD4, 0xE5, 0xF6, 0x07, 0x18, 0x29, 0x3A, 0x4B, 0x5C, 0x6D, 0x7E, 0x8F, 0x90, 0xA1, 0xB2, 0xC3, 0xD4, 0xE5, 0xF6, 0x07, 0x18, 0x29, 0x3A };
static unsigned char encrypted_startInit[] = { 0xC1, 0xD2, 0xE3, 0xF4, 0x05, 0x16, 0x27, 0x38, 0x49, 0x5A, 0x6B, 0x7C, 0x8D, 0x9E, 0xAF, 0xB0, 0xC1, 0xD2, 0xE3, 0xF4 };
static unsigned char encrypted_setToken[] = { 0xD0, 0xE1, 0xF2, 0x03, 0x14, 0x25, 0x36, 0x47, 0x58, 0x69, 0x7A, 0x8B, 0x9C, 0xAD, 0xBE, 0xCF, 0xD0 };
static unsigned char encrypted_hideUI[] = { 0xE9, 0xFA, 0x0B, 0x1C, 0x2D, 0x3E, 0x4F, 0x50, 0x61, 0x72, 0x83, 0x94, 0xA5, 0xB6 };
static unsigned char encrypted_strictMode[] = { 0xF8, 0x09, 0x1A, 0x2B, 0x3C, 0x4D, 0x5E, 0x6F, 0x70, 0x81, 0x92, 0xA3, 0xB4, 0xC5, 0xD6 };
static unsigned char encrypted_silentMode[] = { 0x07, 0x18, 0x29, 0x3A, 0x4B, 0x5C, 0x6D, 0x7E, 0x8F, 0x90, 0xA1, 0xB2, 0xC3, 0xD4 };
static unsigned char encrypted_getPackage[] = { 0x16, 0x27, 0x38, 0x49, 0x5A, 0x6B, 0x7C, 0x8D, 0x9E, 0xAF, 0xB0, 0xC1, 0xD2, 0xE3, 0xF4, 0x05, 0x16, 0x27, 0x38, 0x49, 0x5A, 0x6B, 0x7C, 0x8D, 0x9E, 0xAF };
static unsigned char encrypted_getKey[] = { 0x25, 0x36, 0x47, 0x58, 0x69, 0x7A, 0x8B, 0x9C, 0xAD, 0xBE, 0xCF, 0xD0, 0xE1, 0xF2 };
static unsigned char encrypted_getExpiry[] = { 0x34, 0x45, 0x56, 0x67, 0x78, 0x89, 0x9A, 0xAB, 0xBC, 0xCD, 0xDE, 0xEF, 0xF0, 0x01, 0x12, 0x23, 0x34, 0x45, 0x56, 0x67, 0x78 };
static unsigned char encrypted_getUDID[] = { 0x43, 0x54, 0x65, 0x76, 0x87, 0x98, 0xA9, 0xBA, 0xCB, 0xDC, 0xED, 0xFE, 0x0F, 0x10, 0x21, 0x32, 0x43, 0x54 };
static unsigned char encrypted_getDevice[] = { 0x52, 0x63, 0x74, 0x85, 0x96, 0xA7, 0xB8, 0xC9, 0xDA, 0xEB, 0xFC, 0x0D, 0x1E, 0x2F, 0x30, 0x41, 0x52, 0x63, 0x74 };
static unsigned char encrypted_getIP[] = { 0x61, 0x72, 0x83, 0x94, 0xA5, 0xB6, 0xC7, 0xD8, 0xE9, 0xFA, 0x0B, 0x1C, 0x2D, 0x3E, 0x4F };
static unsigned char encrypted_getPackageName[] = { 0x70, 0x81, 0x92, 0xA3, 0xB4, 0xC5, 0xD6, 0xE7, 0xF8, 0x09, 0x1A, 0x2B, 0x3C, 0x4D, 0x5E, 0x6F, 0x70, 0x81, 0x92, 0xA3, 0xB4, 0xC5 };
static unsigned char encrypted_swizzlePrefix[] = { 0x8F, 0x90, 0xA1, 0xB2, 0xC3, 0xD4, 0xE5, 0xF6, 0x07, 0x18, 0x29, 0x3A, 0x4B };
static unsigned char encrypted_noSwizzle[] = { 0x9E, 0xAF, 0xB0, 0xC1, 0xD2, 0xE3, 0xF4, 0x05, 0x16, 0x27, 0x38, 0x49, 0x5A };
static unsigned char encrypted_swizzleComplete[] = { 0xAD, 0xBE, 0xCF, 0xD0, 0xE1, 0xF2, 0x03, 0x14, 0x25, 0x36, 0x47, 0x58, 0x69, 0x7A, 0x8B, 0x9C };
static unsigned char encrypted_apiClientNotFound[] = { 0xBC, 0xCD, 0xDE, 0xEF, 0xF0, 0x01, 0x12, 0x23, 0x34, 0x45, 0x56, 0x67, 0x78, 0x89, 0x9A, 0xAB, 0xBC, 0xCD };
static unsigned char encrypted_dylibLoaded[] = { 0xCB, 0xDC, 0xED, 0xFE, 0x0F, 0x10, 0x21, 0x32, 0x43, 0x54, 0x65, 0x76, 0x87, 0x98, 0xA9, 0xBA, 0xCB };

NSString* getSharedClient(void) {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = [NSData dataWithBytes:encrypted_sharedClient length:sizeof(encrypted_sharedClient)];
        cached = [CryptoEngine decryptString:data];
    });
    return cached;
}

NSString* getPaidExecuted(void) {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = [NSData dataWithBytes:encrypted_paidExecuted length:sizeof(encrypted_paidExecuted)];
        cached = [CryptoEngine decryptString:data];
    });
    return cached;
}

NSString* getStartInit(void) {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = [NSData dataWithBytes:encrypted_startInit length:sizeof(encrypted_startInit)];
        cached = [CryptoEngine decryptString:data];
    });
    return cached;
}

NSString* getSetToken(void) {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = [NSData dataWithBytes:encrypted_setToken length:sizeof(encrypted_setToken)];
        cached = [CryptoEngine decryptString:data];
    });
    return cached;
}

NSString* getHideUI(void) {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = [NSData dataWithBytes:encrypted_hideUI length:sizeof(encrypted_hideUI)];
        cached = [CryptoEngine decryptString:data];
    });
    return cached;
}

NSString* getStrictMode(void) {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = [NSData dataWithBytes:encrypted_strictMode length:sizeof(encrypted_strictMode)];
        cached = [CryptoEngine decryptString:data];
    });
    return cached;
}

NSString* getSilentMode(void) {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = [NSData dataWithBytes:encrypted_silentMode length:sizeof(encrypted_silentMode)];
        cached = [CryptoEngine decryptString:data];
    });
    return cached;
}

NSString* getGetPackage(void) {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = [NSData dataWithBytes:encrypted_getPackage length:sizeof(encrypted_getPackage)];
        cached = [CryptoEngine decryptString:data];
    });
    return cached;
}

NSString* getGetKey(void) {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = [NSData dataWithBytes:encrypted_getKey length:sizeof(encrypted_getKey)];
        cached = [CryptoEngine decryptString:data];
    });
    return cached;
}

NSString* getGetExpiry(void) {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = [NSData dataWithBytes:encrypted_getExpiry length:sizeof(encrypted_getExpiry)];
        cached = [CryptoEngine decryptString:data];
    });
    return cached;
}

NSString* getGetUDID(void) {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = [NSData dataWithBytes:encrypted_getUDID length:sizeof(encrypted_getUDID)];
        cached = [CryptoEngine decryptString:data];
    });
    return cached;
}

NSString* getGetDevice(void) {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = [NSData dataWithBytes:encrypted_getDevice length:sizeof(encrypted_getDevice)];
        cached = [CryptoEngine decryptString:data];
    });
    return cached;
}

NSString* getGetIP(void) {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = [NSData dataWithBytes:encrypted_getIP length:sizeof(encrypted_getIP)];
        cached = [CryptoEngine decryptString:data];
    });
    return cached;
}

NSString* getGetPackageName(void) {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = [NSData dataWithBytes:encrypted_getPackageName length:sizeof(encrypted_getPackageName)];
        cached = [CryptoEngine decryptString:data];
    });
    return cached;
}

NSString* getSwizzlePrefix(void) {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = [NSData dataWithBytes:encrypted_swizzlePrefix length:sizeof(encrypted_swizzlePrefix)];
        cached = [CryptoEngine decryptString:data];
    });
    return cached;
}

NSString* getNoSwizzle(void) {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = [NSData dataWithBytes:encrypted_noSwizzle length:sizeof(encrypted_noSwizzle)];
        cached = [CryptoEngine decryptString:data];
    });
    return cached;
}

NSString* getSwizzleComplete(void) {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = [NSData dataWithBytes:encrypted_swizzleComplete length:sizeof(encrypted_swizzleComplete)];
        cached = [CryptoEngine decryptString:data];
    });
    return cached;
}

NSString* getAPIClientNotFound(void) {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = [NSData dataWithBytes:encrypted_apiClientNotFound length:sizeof(encrypted_apiClientNotFound)];
        cached = [CryptoEngine decryptString:data];
    });
    return cached;
}

NSString* getDylibLoaded(void) {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = [NSData dataWithBytes:encrypted_dylibLoaded length:sizeof(encrypted_dylibLoaded)];
        cached = [CryptoEngine decryptString:data];
    });
    return cached;
}