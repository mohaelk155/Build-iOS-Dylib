#import "EncryptedStrings.h"
#import <CommonCrypto/CommonCrypto.h>
#import <objc/runtime.h>

// Datos encriptados (generados con Python)
static const unsigned char encrypted_sharedClient[] = { 0xD9, 0x79, 0xBD, 0xE9, 0x23, 0x69, 0x89, 0xE7, 0x3B, 0x7A, 0x88, 0xCA, 0x0B, 0xBB, 0xE4, 0x7F, 0x7C, 0xA0, 0xE0, 0x38, 0x53, 0x9C, 0xDC, 0x08 };
static const unsigned char encrypted_paidExecuted[] = { 0xDA, 0x70, 0xB5, 0xFF, 0x7C, 0x2D, 0xAD, 0xDD, 0x17, 0x5A, 0x91, 0xD7, 0x0F, 0xB1, 0xFF, 0x7F, 0x32, 0xA2, 0xED, 0x27, 0x5A, 0x9F, 0xD9, 0x04, 0x49, 0xC9, 0x3D, 0x7D, 0xB3, 0xE0, 0x24, 0x66, 0xAB, 0xC5, 0x13, 0x12 };
static const unsigned char encrypted_startInit[] = { 0xD9, 0x65, 0xBD, 0xE9, 0x32, 0x37, 0xA1, 0xD9, 0x1B, 0x4D, 0xDE, 0x83, 0x0B, 0xBF, 0xF5, 0x3C, 0x6F, 0xB5, 0xED, 0x2F, 0x59 };
static const unsigned char encrypted_setToken[] = { 0xD9, 0x74, 0xA8, 0xCF, 0x29, 0x66, 0xAD, 0xD9, 0x48, 0x19, 0xC1, 0xD0 };
static const unsigned char encrypted_hideUI[] = { 0xC2, 0x78, 0xB8, 0xFE, 0x13, 0x44, 0xF2, 0x97, 0x57, 0x5D };
static const unsigned char encrypted_strictMode[] = { 0xD9, 0x65, 0xAE, 0xF2, 0x25, 0x79, 0x85, 0xD8, 0x16, 0x5C, 0xDE, 0x83, 0x4B, 0xB1 };
static const unsigned char encrypted_silentMode[] = { 0xD9, 0x78, 0xB0, 0xFE, 0x28, 0x79, 0x85, 0xD8, 0x16, 0x5C, 0xDE, 0x83, 0x4B, 0xB1 };
static const unsigned char encrypted_getPackage[] = { 0xCD, 0x74, 0xA8, 0xCB, 0x27, 0x6E, 0xA3, 0xD6, 0x15, 0x5C, 0xA0, 0xC2, 0x1A, 0xB4, 0xC7, 0x36, 0x6E, 0xA9, 0xC7, 0x2E, 0x4F, 0xC7, 0x98, 0x42, 0x51, 0xC9, 0x79, 0x2D, 0xFE, 0xDC, 0x05, 0x5C };
static const unsigned char encrypted_getKey[] = { 0xE3, 0x7F, 0xAA, 0xFA, 0x2A, 0x64, 0xAC };
static const unsigned char encrypted_getExpiry[] = { 0x98, 0x28, 0xE5, 0xA2, 0x6B, 0x3C, 0xFA, 0x9A, 0x46, 0x09 };
static const unsigned char encrypted_getUDID[] = { 0xC6, 0x78, 0xEB, 0xEC, 0x27, 0x66, 0xFF, 0x81, 0x40, 0x56, 0xD7 };
static const unsigned char encrypted_getDevice[] = { 0xCD, 0x74, 0xA8, 0xDF, 0x23, 0x7B, 0xA1, 0xD4, 0x17, 0x74, 0x8B, 0xC7, 0x0B, 0xB9, 0xB0, 0x72, 0x24, 0xE1, 0xA9, 0x38 };
static const unsigned char encrypted_getIP[] = { 0x9B, 0x23, 0xEB, 0xB5, 0x76, 0x23, 0xF8, 0x99, 0x43 };
static const unsigned char encrypted_getPackageName[] = { 0xC9, 0x7E, 0xB1, 0xB5, 0x22, 0x79, 0xBB, 0x99, 0x14, 0x4B, 0x81, 0xC6, 0x08, 0xBC, 0xE2, 0x3A, 0x6E, 0xA9 };
static const unsigned char encrypted_swizzlePrefix[] = { 0xF9, 0x66, 0xB5, 0xE1, 0x3C, 0x61, 0xAD, 0x8D, 0x52, 0x1C, 0x97 };
static const unsigned char encrypted_noSwizzle[] = { 0xE4, 0x7E, 0xFC, 0xE8, 0x31, 0x64, 0xB2, 0xCD, 0x1E, 0x5C, 0xDE, 0x83, 0x4B, 0xA6 };
static const unsigned char encrypted_swizzleComplete[] = { 0xF9, 0x66, 0xB5, 0xE1, 0x3C, 0x61, 0xAD, 0x97, 0x11, 0x56, 0x89, 0xD3, 0x02, 0xB0, 0xE4, 0x3E, 0x7E, 0xAE, 0xB6, 0x6B, 0x13, 0x99, 0x98, 0x0A, 0xCB, 0x9D, 0x3B, 0x77, 0xB1, 0xF6 };
static const unsigned char encrypted_apiClientNotFound[] = { 0xE4, 0x7E, 0xFC, 0xE8, 0x23, 0x2D, 0xAD, 0xD9, 0x11, 0x56, 0x8A, 0xD7, 0x1C, 0x26, 0xB0, 0x1E, 0x4A, 0x88, 0xCF, 0x27, 0x5F, 0x98, 0xD6, 0x13 };
static const unsigned char encrypted_dylibLoaded[] = { 0xEE, 0x68, 0xB0, 0xF2, 0x24, 0x2D, 0xAB, 0xD6, 0x00, 0x5E, 0x85, 0xC7, 0x01, 0xEF, 0xB0, 0x39, 0x7B, 0xAD, 0xFF, 0x2E, 0x57, 0xDD, 0xF9, 0x37, 0x6B, 0xAA, 0x38, 0x7A, 0xBB, 0xEB, 0x34 };

static NSData* decryptData(const unsigned char* data, size_t len) {
    NSString *key = @"MySecretKey12345";
    NSString *iv = @"InitVector123456";
    
    NSData *keyData = [[key dataUsingEncoding:NSUTF8StringEncoding] SHA256Hash];
    NSData *ivData = [[iv dataUsingEncoding:NSUTF8StringEncoding] MD5Sum];
    
    NSData *encryptedData = [NSData dataWithBytes:data length:len];
    
    NSData *decrypted = [encryptedData decryptedDataUsingAlgorithm:kCCAlgorithmAES128
                                                               key:keyData
                                              initializationVector:ivData
                                                           options:kCCOptionPKCS7Padding
                                                             error:nil];
    return decrypted;
}

@implementation EncryptedStrings

+ (NSString*)getSharedClient {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = decryptData(encrypted_sharedClient, sizeof(encrypted_sharedClient));
        cached = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    });
    return cached;
}

+ (NSString*)getPaidExecuted {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = decryptData(encrypted_paidExecuted, sizeof(encrypted_paidExecuted));
        cached = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    });
    return cached;
}

+ (NSString*)getStartInit {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = decryptData(encrypted_startInit, sizeof(encrypted_startInit));
        cached = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    });
    return cached;
}

+ (NSString*)getSetToken {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = decryptData(encrypted_setToken, sizeof(encrypted_setToken));
        cached = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    });
    return cached;
}

+ (NSString*)getHideUI {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = decryptData(encrypted_hideUI, sizeof(encrypted_hideUI));
        cached = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    });
    return cached;
}

+ (NSString*)getStrictMode {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = decryptData(encrypted_strictMode, sizeof(encrypted_strictMode));
        cached = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    });
    return cached;
}

+ (NSString*)getSilentMode {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = decryptData(encrypted_silentMode, sizeof(encrypted_silentMode));
        cached = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    });
    return cached;
}

+ (NSString*)getGetPackage {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = decryptData(encrypted_getPackage, sizeof(encrypted_getPackage));
        cached = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    });
    return cached;
}

+ (NSString*)getGetKey {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = decryptData(encrypted_getKey, sizeof(encrypted_getKey));
        cached = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    });
    return cached;
}

+ (NSString*)getGetExpiry {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = decryptData(encrypted_getExpiry, sizeof(encrypted_getExpiry));
        cached = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    });
    return cached;
}

+ (NSString*)getGetUDID {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = decryptData(encrypted_getUDID, sizeof(encrypted_getUDID));
        cached = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    });
    return cached;
}

+ (NSString*)getGetDevice {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = decryptData(encrypted_getDevice, sizeof(encrypted_getDevice));
        cached = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    });
    return cached;
}

+ (NSString*)getGetIP {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = decryptData(encrypted_getIP, sizeof(encrypted_getIP));
        cached = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    });
    return cached;
}

+ (NSString*)getGetPackageName {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = decryptData(encrypted_getPackageName, sizeof(encrypted_getPackageName));
        cached = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    });
    return cached;
}

+ (NSString*)getSwizzlePrefix {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = decryptData(encrypted_swizzlePrefix, sizeof(encrypted_swizzlePrefix));
        cached = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    });
    return cached;
}

+ (NSString*)getNoSwizzle {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = decryptData(encrypted_noSwizzle, sizeof(encrypted_noSwizzle));
        cached = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    });
    return cached;
}

+ (NSString*)getSwizzleComplete {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = decryptData(encrypted_swizzleComplete, sizeof(encrypted_swizzleComplete));
        cached = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    });
    return cached;
}

+ (NSString*)getAPIClientNotFound {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = decryptData(encrypted_apiClientNotFound, sizeof(encrypted_apiClientNotFound));
        cached = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    });
    return cached;
}

+ (NSString*)getDylibLoaded {
    static NSString *cached = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = decryptData(encrypted_dylibLoaded, sizeof(encrypted_dylibLoaded));
        cached = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    });
    return cached;
}

@end