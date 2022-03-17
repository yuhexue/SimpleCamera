//
//  SCGPUImageBaseFilter.m
//  SimpleCam
//
//  Created by maxslma on 2022/1/6.
//

#import "SCGPUImageBaseFilter.h"

@implementation SCGPUImageBaseFilter

- (id)initWithVertexShaderFromString:(NSString *)vertexShaderString
            fragmentShaderFromString:(NSString *)fragmentShaderString {
    self = [super initWithVertexShaderFromString:vertexShaderString
                        fragmentShaderFromString:fragmentShaderString];
    self.timeUniform = [filterProgram uniformIndex:@"time"];
    self.time = 0.0f;
    self.facesPoints = 0;
    
    return self;
}

- (void)setTime:(CGFloat)time {
    _time = time;
    
    [self setFloat:time forUniform:self.timeUniform program:filterProgram];
}

@end
