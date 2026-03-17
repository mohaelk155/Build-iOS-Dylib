#import "CryptoEngine.h"
#import <mach/mach.h>

static unsigned char _obfuscated_key[] = {
    0x4D, 0x79, 0x53, 0x65, 0x63, 0x72, 0x65, 0x74,
    0x4B, 0x65, 0x79, 0x31, 0x32, 0x33, 0x34, 0x35,
    0x36, 0x37, 0x38, 0x39, 0x30, 0x31, 0x32, 0x33,
    0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x30, 0x31
};

static unsigned char _obfuscated_iv[] = {
    0x49, 0x6E, 0x69, 0x74, 0x56, 0x65, 0x63, 0x74,
    0x6F, 0x72, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36
};

static NSData* getRealKey(void) {
    static unsigned char key[32];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        for(int i = 0; i < 32; i++) {
            key[i] = _obfuscated_key[i] ^ 0xAA;
            key[i] ^= (i * 0xBB) & 0xFF;
        }
    });
    return [NSData dataWithBytes:key length:32];
}

static NSData* getRealIV(void) {
    static unsigned char iv[16];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        for(int i = 0; i < 16; i++) {
            iv[i] = _obfuscated_iv[i] ^ 0xBB;
            iv[i] ^= (i * 0xCC) & 0xFF;
        }
    });
    return [NSData dataWithBytes:iv length:16];
}

@implementation CryptoEngine

+ (NSData *)decryptData:(NSData *)encryptedData {
    if (!encryptedData || encryptedData.length == 0) return nil;
    
    NSData *key = getRealKey();
    NSData *iv = getRealIV();
    
    size_t outLength;
    NSMutableData *decryptedData = [NSMutableData dataWithLength:encryptedData.length + kCCBlockSizeAES128];
    
    CCCryptorStatus status = CCCrypt(kCCDecrypt,
                                     kCCAlgorithmAES128,
                                     kCCOptionPKCS7Padding,
                                     key.bytes, key.length,
                                     iv.bytes,
                                     encryptedData.bytes, encryptedData.length,
                                     decryptedData.mutableBytes, decryptedData.length,
                                     &outLength);
    
    if (status == kCCSuccess) {
        decryptedData.length = outLength;
        return decryptedData;
    }
    
    return nil;
}

+ (NSString *)decryptString:(NSData *)encryptedData {
    NSData *decrypted = [self decryptData:encryptedData];
    if (decrypted) {
        return [[NSString alloc] initWithData:decrypted encoding:NSUTF8StringEncoding];
    }
    return nil;
}

+ (NSString *)quickDecrypt:(unsigned char *)data length:(int)len {
    NSData *encrypted = [NSData dataWithBytes:data length:len];
    return [self decryptString:encrypted];
}

+ (void)secureWipe:(void *)ptr length:(size_t)len {
    if (!ptr || len == 0) return;
    
    volatile unsigned char *p = (volatile unsigned char *)ptr;
    for(int pass = 0; pass < 3; pass++) {
        for(size_t i = 0; i < len; i++) {
            p[i] = (arc4random() & 0xFF);
        }
        __asm__ volatile("" : : "r"(p) : "memory");
    }
}

@end