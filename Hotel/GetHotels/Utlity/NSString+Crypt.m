//
//  constants.h
//  BeilySportsCRM
//
//  Created by Ziyao Yang on 8/5/15.
//  Copyright (c) 2015 Pro. All rights reserved.
//

#include <Openssl/opensslv.h>
#include <Openssl/rsa.h>
#include <Openssl/evp.h>
#include <Openssl/bn.h>

#import "NSString+Crypt.h"
#import "NSData+Base64.h"
#import "BasicEncodingRules.h"
#import "Utilities.h"

static SecKeyRef publicKey;
static SecKeyRef privateKey;
static NSData *publicTag;
static NSData *privateTag;

const size_t BUFFER_SIZE = 64;
const size_t CIPHER_BUFFER_SIZE = 1024;
const uint32_t PADDING = kSecPaddingNone;
static const UInt8 publicKeyIdentifier[] = "com.beily.sample.publickey";
static const UInt8 privateKeyIdentifier[] = "com.beily.sample.privatekey";

@implementation NSString (URL)

- (RSA *)rsaFromExponent:(NSString *)exponent modulus:(NSString *)modulus
{
    RSA *rsa_pub = RSA_new();
    
    const char *N = [modulus UTF8String];
    const char *E = [exponent UTF8String];
    
    if (!BN_hex2bn(&rsa_pub->n, N))
    {
        // TODO
    }
    printf("N: %s\n", N);
    printf("n: %s\n", BN_bn2dec(rsa_pub->n));
    
    if (!BN_hex2bn(&rsa_pub->e, E))
    {
        // TODO
    }
    printf("E: %s\n", E);
    printf("e: %s\n", BN_bn2dec(rsa_pub->e));
    
    return rsa_pub;
}

+ (NSString *)cleanString:(NSString *)input
{
    NSString *output = input;
    output = [output stringByReplacingOccurrencesOfString:@"<" withString:@""];
    output = [output stringByReplacingOccurrencesOfString:@">" withString:@""];
    output = [output stringByReplacingOccurrencesOfString:@" " withString:@""];
    return output;
}

+ (NSString *)encryptWithPublicKeyFromModulusAndExponent:(const char *)data modulus:(NSString *)mod exponent:(NSString *)exp
{
    NSLog(@"mod = %@ \n exp = %@", mod, exp);
    
    NSData *exponentData = [NSData dataWithBase64EncodedString:exp];
    NSData *modulusData = [NSData dataWithBase64EncodedString:mod];
    
    NSString *exponentHex = [NSString cleanString:[exponentData description]];
    NSString *modulusHex = [NSString cleanString:[modulusData description]];
    
    const char *modulus_in_hex = [modulusHex UTF8String] ;
    const char *xponent_in_hex = [exponentHex UTF8String];
    
    BIGNUM *xponent = NULL;
    BIGNUM *modulus = NULL;
    
    BN_hex2bn(&xponent, xponent_in_hex);
    BN_hex2bn(&modulus, modulus_in_hex);
    
    RSA *rsa = RSA_new();
    rsa->e = xponent;
    rsa->n = modulus;
    rsa->iqmp = NULL;
    rsa->d = NULL;
    rsa->p = NULL;
    rsa->q = NULL;
    
    const int rsa_length = RSA_size(rsa);
    unsigned char *encoded[rsa_length];
    
    int encrypt_len = RSA_public_encrypt(
                                         (int)strlen(data),
                                         (const unsigned char *)data,
                                         (unsigned char *)encoded,
                                         rsa,
                                         RSA_PKCS1_PADDING
                                         );
    
    NSString* ret = nil;
    if (encrypt_len <= 0) {
        NSLog(@"ERROR encrypt");
    } else {
        NSData *cipherData = [NSData dataWithBytes:(const void *)encoded length:rsa_length];
        NSString *cipherDataB64 = [cipherData base64EncodedString];
        NSLog(@"user encrypted b64: %@", cipherDataB64);
        ret = cipherDataB64;
        
    }
    
    RSA_free(rsa);
    
    return ret;
}

+ (SecKeyRef)getKeyRefWithModulusAndExponent
{
    NSMutableArray *testArray = [[NSMutableArray alloc] init];
    [testArray addObject:[Utilities getUserDefaults:@"EXPONENT"]];
    [testArray addObject:[Utilities getUserDefaults:@"MODULUS"]];
    NSData *testPubKey = [testArray berData];
    return [NSString addPeerPublicKey:@"com.beilywx.publicKey" keyBits:testPubKey];
}

+ (SecKeyRef)getKeyRefWithPersistentKeyRef:(CFTypeRef)persistentRef {
    OSStatus sanityCheck = noErr;
    SecKeyRef keyRef = NULL;
    
    NSMutableDictionary * queryKey = [[NSMutableDictionary alloc] init];
    
    // Set the SecKeyRef query dictionary.
    [ queryKey setObject:(__bridge id)persistentRef forKey:(__bridge id)kSecValuePersistentRef];
    [queryKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    
    // Get the persistent key reference.
    sanityCheck = SecItemCopyMatching((__bridge CFDictionaryRef)queryKey, (CFTypeRef *)&keyRef);
#if !__has_feature(objc_arc)
    [queryKey release];
#endif
    return keyRef;
}

+ (SecKeyRef)addPeerPublicKey:(NSString *)peerName keyBits:(NSData *)publicK {
    OSStatus sanityCheck = noErr;
    SecKeyRef peerKeyRef = NULL;
    CFTypeRef persistPeer = NULL;
    
    NSData * peerTag = [[NSData alloc] initWithBytes:(const void *)[peerName UTF8String] length:[peerName length]];
    NSMutableDictionary * peerPublicKeyAttr = [[NSMutableDictionary alloc] init];
    
    [peerPublicKeyAttr setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [peerPublicKeyAttr setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [peerPublicKeyAttr setObject:peerTag forKey:(__bridge id)kSecAttrApplicationTag];
    [peerPublicKeyAttr setObject:publicK forKey:(__bridge id)kSecValueData];
    [peerPublicKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnPersistentRef];
    
    sanityCheck = SecItemAdd((__bridge CFDictionaryRef) peerPublicKeyAttr, (CFTypeRef *)&persistPeer);
    
    if (persistPeer) {
        peerKeyRef = [NSString getKeyRefWithPersistentKeyRef:persistPeer];
    } else {
        [peerPublicKeyAttr removeObjectForKey:(__bridge id)kSecValueData];
        [peerPublicKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
        // Let's retry a different way.
        sanityCheck = SecItemCopyMatching((__bridge CFDictionaryRef) peerPublicKeyAttr, (CFTypeRef *)&peerKeyRef);
    }
#if !__has_feature(objc_arc)
    [peerTag release];
    [peerPublicKeyAttr release];
#endif
    if (persistPeer) CFRelease(persistPeer);
    return peerKeyRef;
}

+ (void)encryptWithPublicKey:(uint8_t *)plainBuffer publicKey:(SecKeyRef)keyRef
{
    NSLog(@"== encryptWithPublicKey()");
    
    OSStatus status = noErr;
    
    NSLog(@"** original plain text 0: %s", plainBuffer);
    
    size_t plainBufferSize = strlen((char *)plainBuffer);
    size_t cipherBufferSize = CIPHER_BUFFER_SIZE;
    
    uint8_t * cipherBuffer = (uint8_t *)calloc(CIPHER_BUFFER_SIZE, sizeof(uint8_t));
    
    status = SecKeyEncrypt(keyRef,
                           PADDING,
                           plainBuffer,
                           plainBufferSize,
                           &cipherBuffer[0],
                           &cipherBufferSize
                           );
    NSLog(@"encryption result code: %d (size: %lu)", (int)status, cipherBufferSize);
    
}

- (void)encryptWithPublicKey:(uint8_t *)plainBuffer cipherBuffer:(uint8_t *)cipherBuffer
{
    NSLog(@"== encryptWithPublicKey()");
    
    OSStatus status = noErr;
    
    NSLog(@"** original plain text 0: %s", plainBuffer);
    
    size_t plainBufferSize = strlen((char *)plainBuffer);
    size_t cipherBufferSize = CIPHER_BUFFER_SIZE;
    
    NSLog(@"SecKeyGetBlockSize() public = %lu", SecKeyGetBlockSize([self getPublicKeyRef]));

    status = SecKeyEncrypt([self getPublicKeyRef],
                           PADDING,
                           plainBuffer,
                           plainBufferSize,
                           &cipherBuffer[0],
                           &cipherBufferSize
                           );
    NSLog(@"encryption result code: %d (size: %lu)", (int)status, cipherBufferSize);
    
}

- (void)decryptWithPrivateKey:(uint8_t *)cipherBuffer plainBuffer:(uint8_t *)plainBuffer
{
    OSStatus status = noErr;
    
    size_t cipherBufferSize = strlen((char *)cipherBuffer);
    
    NSLog(@"decryptWithPrivateKey: length of buffer: %lu", BUFFER_SIZE);
    NSLog(@"decryptWithPrivateKey: length of input: %lu", cipherBufferSize);
    
    // DECRYPTION
    size_t plainBufferSize = BUFFER_SIZE;
    
    //  Error handling
    status = SecKeyDecrypt([self getPrivateKeyRef],
                           PADDING,
                           &cipherBuffer[0],
                           cipherBufferSize,
                           &plainBuffer[0],
                           &plainBufferSize
                           );
    NSLog(@"decryption result code: %d (size: %lu)", (int)status, plainBufferSize);
    NSLog(@"FINAL decrypted text: %s", plainBuffer);
    
}

- (void)testAsymmetricEncryptionAndDecryption {
//    privateTag = [[NSData alloc] initWithBytes:privateKeyIdentifier length:sizeof(privateKeyIdentifier)];
//    publicTag = [[NSData alloc] initWithBytes:publicKeyIdentifier length:sizeof(publicKeyIdentifier)];
    
    uint8_t *plainBuffer;
    uint8_t *cipherBuffer;
    uint8_t *decryptedBuffer;
    
    const char inputString[] = "Hello world.";
    unsigned long len = strlen(inputString);
    
    if (len > BUFFER_SIZE) len = BUFFER_SIZE - 1;
    
    plainBuffer = (uint8_t *)calloc(BUFFER_SIZE, sizeof(uint8_t));
    cipherBuffer = (uint8_t *)calloc(CIPHER_BUFFER_SIZE, sizeof(uint8_t));
    decryptedBuffer = (uint8_t *)calloc(BUFFER_SIZE, sizeof(uint8_t));
    
    strncpy( (char *)plainBuffer, inputString, len);
    
    NSLog(@"init() plainBuffer: %s", plainBuffer);
    
    [self encryptWithPublicKey:(UInt8 *)plainBuffer cipherBuffer:cipherBuffer];
    NSLog(@"encrypted data: %s", cipherBuffer);
    
    [self decryptWithPrivateKey:cipherBuffer plainBuffer:decryptedBuffer];
    NSLog(@"decrypted data: %s", decryptedBuffer);
    
    free(plainBuffer);
    free(cipherBuffer);
    free(decryptedBuffer);
}

- (NSString *)getEncryption {
    uint8_t *plainBuffer;
    uint8_t *cipherBuffer;
    
    const char inputString[] = "Hello world.";
    unsigned long len = strlen(inputString);
    
    if (len > BUFFER_SIZE) len = BUFFER_SIZE - 1;
    
    plainBuffer = (uint8_t *)calloc(BUFFER_SIZE, sizeof(uint8_t));
    cipherBuffer = (uint8_t *)calloc(CIPHER_BUFFER_SIZE, sizeof(uint8_t));
    
    strncpy( (char *)plainBuffer, inputString, len);
    
    NSLog(@"init() plainBuffer: %s", plainBuffer);
    
    [self encryptWithPublicKey:(UInt8 *)plainBuffer cipherBuffer:cipherBuffer];
    NSLog(@"encrypted data: %s", cipherBuffer);
    NSString *target = [NSString stringWithFormat:@"%s", cipherBuffer];
    
    free(plainBuffer);
    free(cipherBuffer);
    
    return target;
}

- (void)getDecryption:(NSString *)target {
    uint8_t *cipherBuffer;
    uint8_t *decryptedBuffer;
    
    //cipherBuffer = (uint8_t *)calloc(CIPHER_BUFFER_SIZE, sizeof(uint8_t));
    decryptedBuffer = (uint8_t *)calloc(BUFFER_SIZE, sizeof(uint8_t));
    
    NSData *targetData = [target dataUsingEncoding:NSUTF8StringEncoding];
    const void *bytes = [targetData bytes];
//    int length = (int)[targetData length];
    
    cipherBuffer = malloc(CIPHER_BUFFER_SIZE);
    memcpy(cipherBuffer, bytes, CIPHER_BUFFER_SIZE);
    //Easy way
    //cipherBuffer = (uint8_t*)bytes;
    
    NSLog(@"raw = %@", target);
    NSLog(@"uint8_t = %s", cipherBuffer);
    
    [self decryptWithPrivateKey:cipherBuffer plainBuffer:decryptedBuffer];
    NSLog(@"decrypted data: %s", decryptedBuffer);
    
    free(cipherBuffer);
    free(decryptedBuffer);
}

- (void)generateKeyPair:(NSUInteger)keySize {
    privateTag = [[NSData alloc] initWithBytes:privateKeyIdentifier length:sizeof(privateKeyIdentifier)];
    publicTag = [[NSData alloc] initWithBytes:publicKeyIdentifier length:sizeof(publicKeyIdentifier)];
    
    OSStatus sanityCheck = noErr;
    publicKey = NULL;
    privateKey = NULL;
    
    // Container dictionaries.
    NSMutableDictionary * privateKeyAttr = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * publicKeyAttr = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * keyPairAttr = [[NSMutableDictionary alloc] init];
    
    // Set top level dictionary for the keypair.
    [keyPairAttr setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [keyPairAttr setObject:[NSNumber numberWithUnsignedInteger:keySize] forKey:(__bridge id)kSecAttrKeySizeInBits];
    
    // Set the private key dictionary.
    [privateKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecAttrIsPermanent];
    [privateKeyAttr setObject:privateTag forKey:(__bridge id)kSecAttrApplicationTag];
    // See SecKey.h to set other flag values.
    
    // Set the public key dictionary.
    [publicKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecAttrIsPermanent];
    [publicKeyAttr setObject:publicTag forKey:(__bridge id)kSecAttrApplicationTag];
    // See SecKey.h to set other flag values.
    
    // Set attributes to top level dictionary.
    [keyPairAttr setObject:privateKeyAttr forKey:(__bridge id)kSecPrivateKeyAttrs];
    [keyPairAttr setObject:publicKeyAttr forKey:(__bridge id)kSecPublicKeyAttrs];
    
    // SecKeyGeneratePair returns the SecKeyRefs just for educational purposes.
    sanityCheck = SecKeyGeneratePair((__bridge CFDictionaryRef)keyPairAttr, &publicKey, &privateKey);
    
    if(sanityCheck == noErr  && publicKey != NULL && privateKey != NULL)
    {
        NSLog(@"Successful");
    }
}

- (NSData *)getPublicKeyBitsFromKey {
    OSStatus sanityCheck = noErr;
    NSData * publicKeyBits = nil;
    
    NSMutableDictionary * queryPublicKey = [[NSMutableDictionary alloc] init];
    
    // Set the public key query dictionary.
    [queryPublicKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [queryPublicKey setObject:publicTag forKey:(__bridge id)kSecAttrApplicationTag];
    [queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [queryPublicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnData];
    
    // Get the key bits.
    CFTypeRef pk;
    sanityCheck = SecItemCopyMatching((__bridge_retained CFDictionaryRef)queryPublicKey, &pk);
    if (sanityCheck != noErr)
    {
        publicKeyBits = nil;
    }
    publicKeyBits = (__bridge_transfer NSData*)pk;
    //NSLog(@"public bits %@",publicKeyBits);
    
    return publicKeyBits;
}

- (NSString *)getbase64PublicKey {
    NSString *returnValue = @"";
    NSData *pubKey = [self getPublicKeyBitsFromKey];
    returnValue = [pubKey base64EncodedString];
    
    return returnValue;
}

- (SecKeyRef)getPrivateKeyRef {
    /*
    OSStatus resultCode = noErr;
    SecKeyRef privateKeyReference = NULL;
    //    NSData *privateTag = [NSData dataWithBytes:@"ABCD" length:strlen((const char *)@"ABCD")];
    if (privateKey == NULL) {
        [self generateKeyPair:1024];
        
        NSMutableDictionary * queryPrivateKey = [[NSMutableDictionary alloc] init];
        
        // Set the private key query dictionary.
        [queryPrivateKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
        [queryPrivateKey setObject:privateTag forKey:(__bridge id)kSecAttrApplicationTag];
        [queryPrivateKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
        [queryPrivateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
        
        // Get the key.
        resultCode = SecItemCopyMatching((__bridge CFDictionaryRef)queryPrivateKey, (CFTypeRef *)&privateKeyReference);
        NSLog(@"getPrivateKey: result code: %d", (int)resultCode);
        
        if(resultCode != noErr)
        {
            privateKeyReference = NULL;
        }
    } else {
        privateKeyReference = privateKey;
    }
    
    return privateKeyReference;
    */
    OSStatus resultCode = noErr;
    SecKeyRef privateKeyReference = NULL;
    //    NSData *privateTag = [NSData dataWithBytes:@"ABCD" length:strlen((const char *)@"ABCD")];
    if (privateKey == NULL) {
        [self generateKeyPair:1024];
    }
    NSMutableDictionary * queryPrivateKey = [[NSMutableDictionary alloc] init];
    
    // Set the private key query dictionary.
    [queryPrivateKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [queryPrivateKey setObject:privateTag forKey:(__bridge id)kSecAttrApplicationTag];
    [queryPrivateKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [queryPrivateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    
    // Get the key.
    resultCode = SecItemCopyMatching((__bridge CFDictionaryRef)queryPrivateKey, (CFTypeRef *)&privateKeyReference);
    NSLog(@"getPrivateKey: result code: %d", (int)resultCode);
    
    if(resultCode != noErr)
    {
        privateKeyReference = NULL;
    }
    
    return privateKeyReference;
}

- (SecKeyRef)getPublicKeyRef {
    
    OSStatus sanityCheck = noErr;
    SecKeyRef publicKeyReference = NULL;
    
    if (publicKeyReference == NULL) {
        [self generateKeyPair:1024];
        NSMutableDictionary *queryPublicKey = [[NSMutableDictionary alloc] init];
        
        // Set the public key query dictionary.
        [queryPublicKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
        [queryPublicKey setObject:publicTag forKey:(__bridge id)kSecAttrApplicationTag];
        [queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
        [queryPublicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
        
        
        // Get the key.
        sanityCheck = SecItemCopyMatching((__bridge CFDictionaryRef)queryPublicKey, (CFTypeRef *)&publicKeyReference);
        
        
        if (sanityCheck != noErr)
        {
            publicKeyReference = NULL;
        }
        
        
    } else { publicKeyReference = publicKey; }
    
    return publicKeyReference;
}

- (void)createSecKeyRefByPublicKey:(CFDataRef)data
{
    SecCertificateRef   cert    = NULL;
    SecPolicyRef        policy  = NULL;
    
    cert = SecCertificateCreateWithData(kCFAllocatorDefault, data);
    policy = SecPolicyCreateBasicX509();
    
    
    OSStatus        status      = noErr;
    SecKeyRef       *publicKey  = NULL;
    SecTrustRef     trust       = NULL;
    SecTrustResultType  trustType   = kSecTrustResultInvalid;
    
    if (cert != NULL){
        SecCertificateRef   certArray[1] = {cert};
        CFArrayRef certs = CFArrayCreate(kCFAllocatorDefault, (void *)certArray, 1, NULL);
        status = SecTrustCreateWithCertificates(certs, policy, &trust);
        
        if (status == errSecSuccess){
            status = SecTrustEvaluate(trust, &trustType);
            
            // Evaulate the trust.
            switch (trustType) {
                case kSecTrustResultInvalid:
                case kSecTrustResultDeny:
                case kSecTrustResultUnspecified:
                case kSecTrustResultFatalTrustFailure:
                case kSecTrustResultOtherError:
                    break;
                case kSecTrustResultRecoverableTrustFailure:
                    *publicKey = SecTrustCopyPublicKey(trust);
                    break;
                case kSecTrustResultProceed:
                    *publicKey = SecTrustCopyPublicKey(trust);
                    break;
            }
            
        }
    }
    
}

static NSString * AFBase64EncodedStringFromString(NSString *string) {
    NSData *data = [NSData dataWithBytes:[string UTF8String] length:[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger length = [data length];
    NSMutableData *mutableData = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    
    uint8_t *input = (uint8_t *)[data bytes];
    uint8_t *output = (uint8_t *)[mutableData mutableBytes];
    
    for (NSUInteger i = 0; i < length; i += 3) {
        NSUInteger value = 0;
        for (NSUInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        static uint8_t const kAFBase64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        
        NSUInteger idx = (i / 3) * 4;
        output[idx + 0] = kAFBase64EncodingTable[(value >> 18) & 0x3F];
        output[idx + 1] = kAFBase64EncodingTable[(value >> 12) & 0x3F];
        output[idx + 2] = (i + 1) < length ? kAFBase64EncodingTable[(value >> 6)  & 0x3F] : '=';
        output[idx + 3] = (i + 2) < length ? kAFBase64EncodingTable[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:mutableData encoding:NSASCIIStringEncoding];
}



- (NSString*)base64
{
    return AFBase64EncodedStringFromString(self);
}

+ (NSString *)stringWithMD5OfFile: (NSString *) path {
	NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath: path];
	if (handle == nil) {
		return nil;
	}
    
	CC_MD5_CTX md5;
	CC_MD5_Init (&md5);
    
	BOOL done = NO;
    
	while (!done) {
		NSData *fileData = [[NSData alloc] initWithData: [handle readDataOfLength: 4096]];
		CC_MD5_Update (&md5, [fileData bytes], (CC_LONG)[fileData length]);
        
		if ([fileData length] == 0) {
			done = YES;
		}
	}
    
	unsigned char digest[CC_MD5_DIGEST_LENGTH];
	CC_MD5_Final (digest, &md5);
	NSString *s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
				   digest[0],  digest[1],
				   digest[2],  digest[3],
				   digest[4],  digest[5],
				   digest[6],  digest[7],
				   digest[8],  digest[9],
				   digest[10], digest[11],
				   digest[12], digest[13],
				   digest[14], digest[15]];
	return s;
}

- (NSString *)getMD5_32BitString {
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( data.bytes, (int)data.length, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}

- (NSString *)hexadecimalString
{
    /* Returns hexadecimal string of NSData. Empty string if data is empty.   */
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    
    if (!dataBuffer)
    {
        return [NSString string];
    }
    
    NSUInteger          dataLength  = [self length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
    {
        [hexString appendFormat:@"%02x", (unsigned int)dataBuffer[i]];
    }
    
    return [NSString stringWithString:hexString];
}

- (NSString *)URLEncodedString
{
    __autoreleasing NSString *encodedString;
    NSString *originalString = (NSString *)self;
//    encodedString = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)originalString, NULL, (CFStringRef)@":!*();@/&?#[]+$,='%’\"", kCFStringEncodingUTF8);
    encodedString = [originalString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@":!*();@/&?#[]+$,='%’\""]];
    return encodedString;
}

- (NSString *)URLDecodedString
{
    __autoreleasing NSString *decodedString;
    NSString *originalString = (NSString *)self;
//    decodedString = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)originalString, CFSTR(""), kCFStringEncodingUTF8);
    decodedString = [originalString stringByRemovingPercentEncoding];
    return decodedString;
}


- (NSData *)stringasdata:(NSString *)command {
    command = [command stringByReplacingOccurrencesOfString:@" " withString:@""];
    command = [command stringByReplacingOccurrencesOfString:@"<" withString:@""];
    command = [command stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSLog(@"command= %@",command);
    NSMutableData *commandToSend= [[NSMutableData alloc] init]; unsigned char whole_byte;
    int len = (int)[command length];
    int n = len/2;
    char byte_chars[3] = {'\0','\0','\0'}; int i;
    for (i=0; i < n; i++) {
        byte_chars[0] = [command characterAtIndex:i*2]; byte_chars[1] = [command         characterAtIndex:i*2+1]; whole_byte = strtol(byte_chars, NULL, 16); [commandToSend appendBytes:&whole_byte length:1];
    }
    
    return commandToSend;     
}
/*
- (NSData *)getPublicKeyExp
{
    //NSData *pk = [self getPublicKeyBits:@"RSA Public Key"];
    NSData *pk = [self getPublicKeyBitsFromKey];
    //NSData *pk = [self generateKeyPair:1024];
    if (pk == NULL) return NULL;
    
    int iterator = 0;
    
    iterator++; // TYPE - bit stream - mod + exp
    [self derEncodingGetSizeFrom:pk at:&iterator]; // Total size
    
    iterator++; // TYPE - bit stream mod
    int mod_size = [self derEncodingGetSizeFrom:pk at:&iterator];
    iterator += mod_size;
    
    iterator++; // TYPE - bit stream exp
    int exp_size = [self derEncodingGetSizeFrom:pk at:&iterator];
    
    return [pk subdataWithRange:NSMakeRange(iterator, exp_size)];
    return pk;
}


- (NSData *)getPublicKeyMod
{
    //NSData* pk = [self getPublicKeyBits:@"RSA Public Key"];
    NSData * pk = [self getPublicKeyBitsFromKey];
    //NSData *pk = [self generateKeyPair:1024];
    if (pk == NULL) return NULL;
    
    int iterator = 0;
    
    iterator++; // TYPE - bit stream - mod + exp
    [self derEncodingGetSizeFrom:pk at:&iterator]; // Total size
    
    iterator++; // TYPE - bit stream mod
    int mod_size = [self derEncodingGetSizeFrom:pk at:&iterator];
    
    return [pk subdataWithRange:NSMakeRange(iterator, mod_size)];
    return pk;
    //NSLog(@"public size: %lu",(unsigned long)pk.length);
}

- (int)derEncodingGetSizeFrom:(NSData *)buf at:(int *)iterator
{
    const uint8_t* data = [buf bytes];
    int itr = *iterator;
    int num_bytes = 1;
    int ret = 0;
    
    if (data[itr] > 0x80) {
        num_bytes = data[itr] - 0x80;
        itr++;
    }
    
    for (int i = 0 ; i < num_bytes; i++)
        ret = (ret * 0x100) + data[itr + i];
    
    *iterator = itr + num_bytes;
    return ret;
}
*/
@end