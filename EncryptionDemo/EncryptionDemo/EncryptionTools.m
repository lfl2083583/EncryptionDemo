//
//  EncryptionTools.m
//  EncryptionDemo
//
//  Created by jt on 2021/8/26.
//

#import "EncryptionTools.h"


@interface EncryptionTools()
    @property (nonatomic, assign) int keySize;
    @property (nonatomic, assign) int blockSize;
    @end

@implementation EncryptionTools
    
+ (instancetype)sharedEncryptionTools {
    static EncryptionTools *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.algorithm = kCCAlgorithmAES;
    });
    
    return instance;
}
    
- (void)setAlgorithm:(uint32_t)algorithm {
    _algorithm = algorithm;
    switch (algorithm) {
        case kCCAlgorithmAES:
        self.keySize = kCCKeySizeAES128;
        self.blockSize = kCCBlockSizeAES128;
        break;
        case kCCAlgorithmDES:
        self.keySize = kCCKeySizeDES;
        self.blockSize = kCCBlockSizeDES;
        break;
        default:
        break;
    }
}
    
- (NSString *)encryptString:(NSString *)string keyString:(NSString *)keyString iv:(NSData *)iv {
    
    
    // 设置秘钥
    NSData *keyData = [keyString dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t cKey[self.keySize];
    bzero(cKey, sizeof(cKey));
    [keyData getBytes:cKey length:self.keySize];
    
    // 设置iv
    uint8_t cIv[self.blockSize];
    bzero(cIv, self.blockSize);
    int option = 0;
    if (iv) {
        [iv getBytes:cIv length:self.blockSize];
        option = kCCOptionPKCS7Padding;
    } else {
        /**
         kCCOptionPKCS7Padding | kCCOptionECBMode  ECB 的模式
         kCCOptionPKCS7Padding                     CBC 的加密
         */
        option = kCCOptionPKCS7Padding | kCCOptionECBMode;
    }
    
    // 设置输出缓冲区
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    size_t bufferSize = [data length] + self.blockSize;
    void *buffer = malloc(bufferSize);
    
    // 开始加密
    size_t encryptedSize = 0;
    //加密解密都是它 -- CCCrypt
    
    /**
     1.kCCEncrypt 加密/kCCDecrypt解密
     2.加密算法
     3.加密选项  ECB/CBC
     4.KEY 的地址
     5.KEY 的长度
     6.iv 初始化向量
     7.加密的数据(地址)
     8.加密的数据长度
     9.密文的内存地址
     10.密文缓冲区的大小
     11.加密结果大小
     */
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          self.algorithm,
                                          option,
                                          cKey,
                                          self.keySize,
                                          cIv,
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &encryptedSize);
    
    NSData *result = nil;
    if (cryptStatus == kCCSuccess) {
        result = [NSData dataWithBytesNoCopy:buffer length:encryptedSize];
    } else {
        free(buffer);
        NSLog(@"[错误] 加密失败|状态编码: %d", cryptStatus);
    }
    
    return [result base64EncodedStringWithOptions:0];
}
    
- (NSString *)decryptString:(NSString *)string keyString:(NSString *)keyString iv:(NSData *)iv {
    
    // 设置秘钥
    NSData *keyData = [keyString dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t cKey[self.keySize];
    bzero(cKey, sizeof(cKey));
    [keyData getBytes:cKey length:self.keySize];
    
    // 设置iv
    uint8_t cIv[self.blockSize];
    bzero(cIv, self.blockSize);
    int option = 0;
    if (iv) {
        [iv getBytes:cIv length:self.blockSize];
        option = kCCOptionPKCS7Padding;
    } else {
        option = kCCOptionPKCS7Padding | kCCOptionECBMode;
    }
    
    // 设置输出缓冲区
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:0];
    size_t bufferSize = [data length] + self.blockSize;
    void *buffer = malloc(bufferSize);
    
    // 开始解密
    size_t decryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          self.algorithm,
                                          option,
                                          cKey,
                                          self.keySize,
                                          cIv,
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &decryptedSize);
    
    NSData *result = nil;
    if (cryptStatus == kCCSuccess) {
        result = [NSData dataWithBytesNoCopy:buffer length:decryptedSize];
    } else {
        free(buffer);
        NSLog(@"[错误] 解密失败|状态编码: %d", cryptStatus);
    }
    
    return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
}
    
    @end
