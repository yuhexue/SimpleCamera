//
//  SCGPUImageBrightnessFilter.m
//  SimpleCam
//
//  Created by maxslma on 2022/3/20.
//

#import "SCGPUImageBrightnessFilter.h"

NSString * const kSCGPUImageBrightnessFilterShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;

 uniform sampler2D inputImageTexture;
 uniform lowp float brightness;

 void main() {
   lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
   gl_FragColor = vec4((textureColor.rgb + vec3(brightness)), textureColor.a);
 }
);

@implementation SCGPUImageBrightnessFilter

- (id)init {
    self = [super initWithFragmentShaderFromString:kSCGPUImageBrightnessFilterShaderString];
    self.brightness = 0;
    return self;
}

- (void)setBrightness:(CGFloat)brightness {
    _brightness = brightness;

//    [self setFloat:MAX(brightness, 1.0) forUniformName:@"brightness"];
    [self setFloat:brightness forUniformName:@"brightness"];
    
}

@end
