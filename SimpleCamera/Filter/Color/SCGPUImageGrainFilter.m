//
//  SCGPUImageGrainFilter.m
//  SimpleCam
//
//  Created by maxslma on 2022/3/20.
//

#import "SCGPUImageGrainFilter.h"

NSString * const kSCGPUImageGrainFilterShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;

 /// 调节胶片颗粒感
 uniform lowp float grain;

 void main() {
   lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
   float noise = (fract(sin(dot(textureCoordinate, vec2(12.9898, 78.233) * 2.0)) * 43758.5453));
   gl_FragColor = textureColor - noise * grain;
//   gl_FragColor = vec4((textureColor.rgb + vec3(noise * grain)), textureColor.a);
 }

);

@implementation SCGPUImageGrainFilter

//- (id)init {
//    self = [super initWithFragmentShaderFromString:kSCGPUImageGrainFilterShaderString];
//    self.grain = 0.5;
//    return self;
//}
//
//- (void)setGrain:(CGFloat)grain {
//    _grain = grain;
//
//    [self setFloat:MAX(grain, 1.0) forUniformName:@"grain"];
//}

@end
