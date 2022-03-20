//
//  SCGPUImageSaturationFilter.m
//  SimpleCam
//
//  Created by maxslma on 2022/3/20.
//

#import "SCGPUImageSaturationFilter.h"

NSString * const kSCGPUImageSaturationFilterShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;

 uniform sampler2D inputImageTexture;
 uniform lowp float saturation;

 const mediump vec3 luminanceWeighting = vec3(0.2125, 0.7154, 0.0721);

 void main() {
   lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
   lowp float luminance = dot(textureColor.rgb, luminanceWeighting);
   lowp vec3 greyScaleColor = vec3(luminance);
   gl_FragColor = vec4(mix(greyScaleColor, textureColor.rgb, saturation), textureColor.a);
 }

);

@implementation SCGPUImageSaturationFilter

- (id)init {
    self = [super initWithFragmentShaderFromString:kSCGPUImageSaturationFilterShaderString];
    self.saturation = 1.0;
    return self;
}

- (void)setSaturation:(CGFloat)saturation {
    _saturation = saturation;

    [self setFloat:MAX(saturation, 1.0) forUniformName:@"saturation"];
}

@end
