//
//  SCGPUImageContrastFilter.m
//  SimpleCam
//
//  Created by maxslma on 2022/3/20.
//

#import "SCGPUImageContrastFilter.h"

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
    self.contrast = 0.5;
    return self;
}

- (void)setContrast:(CGFloat)contrast {
    _contrast = contrast;

    [self setFloat:MAX(contrast, 1.0) forUniformName:@"contrast"];
}

@end
