//
//  SCFileHelper.m
//  SimpleCamera
//
//  Created by maxslma on 2022/2/11.
//

#import "SCFileHelper.h"

@implementation SCFileHelper

#pragma mark - Public

+ (NSString *)temporaryDirectory {
    return NSTemporaryDirectory();
}

+ (NSString *)filePathInTmpWithName:(NSString *)name {
    return [[self temporaryDirectory] stringByAppendingPathComponent:name];
}

+ (NSString *)randomFilePathInTmpWithSuffix:(NSString *)suffix {
    long random = [[NSDate date] timeIntervalSince1970] * 1000;
    return [[self filePathInTmpWithName:[NSString stringWithFormat:@"%ld", random]] stringByAppendingString:suffix];
}

@end
