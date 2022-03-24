//
//  SCGPUImageGrainFilter.m
//  SimpleCam
//
//  Created by maxslma on 2022/3/20.
//

#import "SCGPUImageGrainFilter.h"

static CGFloat const kMAXGrain = 0.5f;
static CGFloat const kMinGrain = 0.0f;

NSString * const kSCGPUImageGrainFilterShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;

 /// 调节胶片颗粒感
 uniform lowp float grain;

 void main() {
   lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
   lowp float noise = fract(sin(dot(textureCoordinate, vec2(12.9898, 78.233) * 2.0)) * 43758.5453);
   gl_FragColor = vec4((textureColor.rgb + vec3(grain * noise)), textureColor.a);
 }

);

@implementation SCGPUImageGrainFilter

- (id)init {
    self = [super initWithFragmentShaderFromString:kSCGPUImageGrainFilterShaderString];
    self.ratio = 0.5f;
    return self;
}

- (void)setRatio:(CGFloat)ratio {
    [super setRatio:ratio];
    
    self.grain = ratio * (kMAXGrain - kMinGrain) + kMinGrain;
}

- (void)setGrain:(CGFloat)grain {
    grain = MIN(grain, kMAXGrain);
    grain = MAX(grain, kMinGrain);
    
    _grain = grain;
    [self setFloat:grain forUniformName:@"grain"];
}

@end
