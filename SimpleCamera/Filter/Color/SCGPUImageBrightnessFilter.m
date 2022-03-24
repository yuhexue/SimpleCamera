//
//  SCGPUImageBrightnessFilter.m
//  SimpleCam
//
//  Created by maxslma on 2022/3/20.
//

#import "SCGPUImageBrightnessFilter.h"

static CGFloat const kMAXBrightness = 1.0f;
static CGFloat const kMinBrightness = -1.0f;

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
    self.ratio = 0.5f;
    return self;
}


- (void)setRatio:(CGFloat)ratio {
    [super setRatio:ratio];
    
    self.brightness = ratio * (kMAXBrightness - kMinBrightness) + kMinBrightness;
}

- (void)setBrightness:(CGFloat)brightness {
    brightness = MIN(brightness, kMAXBrightness);
    brightness = MAX(brightness, kMinBrightness);
    
    _brightness = brightness;
    [self setFloat:brightness forUniformName:@"brightness"];
}

@end
