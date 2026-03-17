#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

@interface CryptoEngine : NSObject
+ (NSData *)decryptData:(NSData *)encryptedData;
+ (NSString *)decryptString:(NSData *)encryptedData;
+ (NSString *)quickDecrypt:(unsigned char *)data length:(int)len;
+ (void)secureWipe:(void *)ptr length:(size_t)len;
@end