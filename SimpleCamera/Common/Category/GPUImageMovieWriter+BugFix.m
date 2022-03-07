//
//  GPUImageMovieWriter+BugFix.m
//  SimpleCamera
//
//  Created by maxslma on 2022/3/7.
//

#import "GPUImageMovieWriter+BugFix.h"
#import "SCGPUImageMovieWriter.h"
#import <RSSwizzle/RSSwizzle.h>
#import <objc/runtime.h>

@implementation GPUImageMovieWriter (BugFix)

/**
 修复GPUImageMovieWriter 保存存在黑屏的问题：
 1，在不修改源码的基础上，在 SCGPUImageMovieWriter 上修改，SCGPUImageMovieWriter 的修改方式参考链接：https://www.jianshu.com/p/443e8ea7b0c5
 2，通过方法交换，修改 GPUImageMovieWriter 的 initWithMovieURL:size:fileType:outputSettings: 方法，
 将此方法创建的对象的 isa 指针，指向 SCGPUImageMovieWriter，则之后这些对象调用的方法是修复后的方法。
 */
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RSSwizzleInstanceMethod([self class],
                                @selector(initWithMovieURL:size:fileType:outputSettings:),
                                RSSWReturnType(id),
                                RSSWArguments(NSURL *newMovieURL, CGSize newSize, NSString *newFileType, NSDictionary *outputSettings),
                                RSSWReplacement({
            id obj = RSSWCallOriginal(newMovieURL, newSize, newFileType, outputSettings);
            object_setClass(obj, [SCGPUImageMovieWriter class]);
            return obj;

        }), RSSwizzleModeAlways, NULL);
    });
}
@end
