//
//  ViewController.m
//  EncryptionDemo
//
//  Created by jt on 2021/8/26.
//

#import "ViewController.h"
#import "EncryptionTools.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self aesEncrptionTest];
    [self desEncrptionTest];

}

- (void)aesEncrptionTest {
    [EncryptionTools sharedEncryptionTools].algorithm = kCCAlgorithmAES;
    
    // ECB模式
    NSString * encString = [[EncryptionTools sharedEncryptionTools] encryptString:@"something" keyString:EncryptionKey iv:nil];
    
    NSString * decStr = [[EncryptionTools sharedEncryptionTools] decryptString:encString keyString:EncryptionKey iv:nil];
    
    // CBC模式
//    uint8_t iv[8] = {1,2,3,4,5,6};
//    NSData * ivData = [NSData dataWithBytes:iv length:sizeof(iv)];
  
    
//    NSString * encString = [[EncryptionTools sharedEncryptionTools] encryptString:@"something" keyString:EncryptionKey iv:ivData];
//
//    NSString * decStr = [[EncryptionTools sharedEncryptionTools] decryptString:encString keyString:EncryptionKey iv:ivData];
    
    NSLog(@"AES测试 \n明文----%@  \n密文 ----%@ \n解密后 ----%@", @"something", encString, decStr);
    
}

- (void)desEncrptionTest {
    [EncryptionTools sharedEncryptionTools].algorithm = kCCAlgorithmDES;
    
    // ECB模式
    NSString * encString = [[EncryptionTools sharedEncryptionTools] encryptString:@"something" keyString:EncryptionKey iv:nil];
    
    NSString * decStr = [[EncryptionTools sharedEncryptionTools] decryptString:encString keyString:EncryptionKey iv:nil];
    
    
    // CBC模式
//    uint8_t iv[8] = {1,2,3,4,5,6};
//    NSData * ivData = [NSData dataWithBytes:iv length:sizeof(iv)];
//
    
//    NSString * encString = [[EncryptionTools sharedEncryptionTools] encryptString:@"something" keyString:EncryptionKey iv:ivData];
//
//    NSString * decStr = [[EncryptionTools sharedEncryptionTools] decryptString:encString keyString:EncryptionKey iv:ivData];
    
    
    NSLog(@"DES测试 \n明文----%@  \n密文 ----%@ \n解密后 ----%@", @"something", encString, decStr);
    
}

@end
