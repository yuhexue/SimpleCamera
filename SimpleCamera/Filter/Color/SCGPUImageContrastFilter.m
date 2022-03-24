//
//  SCGPUImageContrastFilter.m
//  SimpleCam
//
//  Created by maxslma on 2022/3/20.
//

#import "SCGPUImageContrastFilter.h"

static CGFloat const kMAXContrast = 2.0f;
static CGFloat const kMinContrast = 0.0f;

NSString * const kSCGPUImageContrastFilterShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;

 uniform sampler2D inputImageTexture;
 uniform lowp float contrast;

 void main() {
   lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
   gl_FragColor = vec4(((textureColor.rgb - vec3(0.5)) * contrast + vec3(0.5)), textureColor.a);
 }
);

@implementation SCGPUImageContrastFilter

- (id)init {
    self = [super initWithFragmentShaderFromString:kSCGPUImageContrastFilterShaderString];
    self.ratio = 0.5f;
    return self;
}

- (void)setRatio:(CGFloat)ratio {
    [super setRatio:ratio];
    
    self.contrast = ratio * (kMAXContrast - kMinContrast) + kMinContrast;
}

- (void)setContrast:(CGFloat)contrast {
    contrast = MIN(contrast, kMAXContrast);
    contrast = MAX(contrast, kMinContrast);
    
    _contrast = contrast;
    [self setFloat:contrast forUniformName:@"contrast"];
}

@end
