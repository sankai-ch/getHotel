//
//  constants.h
//  BeilySportsCRM
//
//  Created by Ziyao Yang on 8/5/15.
//  Copyright (c) 2015 Pro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <Security/Security.h>

@interface NSString (Crypt)

+ (NSString *)stringWithMD5OfFile: (NSString *) path;
//MD5最佳方法
- (NSString *)getMD5_32BitString;
- (NSString *)base64;

- (NSString *)hexadecimalString;
- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

- (void)encryptWithPublicKey:(uint8_t *)plainBuffer cipherBuffer:(uint8_t *)cipherBuffer;
- (void)decryptWithPrivateKey:(uint8_t *)cipherBuffer plainBuffer:(uint8_t *)plainBuffer;
- (SecKeyRef)getPublicKeyRef;
- (SecKeyRef)getPrivateKeyRef;
- (void)testAsymmetricEncryptionAndDecryption;
- (void)generateKeyPair:(NSUInteger)keySize;
+ (SecKeyRef)getKeyRefWithModulusAndExponent;
+ (void)encryptWithPublicKey:(uint8_t *)plainBuffer publicKey:(SecKeyRef)keyRef;
+ (NSString*)encryptWithPublicKeyFromModulusAndExponent:(const char*) data modulus:(NSString*)mod exponent:(NSString*)exp;
- (NSData *)getPublicKeyBitsFromKey;
- (NSString *)getbase64PublicKey;

//- (NSData *)getPublicKeyExp;
//- (NSData *)getPublicKeyMod;

- (NSString *)getEncryption;
- (void)getDecryption:(NSString *)target;

@end
