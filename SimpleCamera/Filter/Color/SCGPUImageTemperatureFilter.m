//
//  SCGPUImageTemperatureFilter.m
//  SimpleCam
//
//  Created by maxslma on 2022/3/20.
//

#import "SCGPUImageTemperatureFilter.h"

static CGFloat const kMAXTemperature = 8000.0f;
static CGFloat const kMinTemperature = 2000.0f;

NSString * const kSCGPUImageTemperatureFilterShaderString = SHADER_STRING
(
 uniform sampler2D inputImageTexture;
 varying highp vec2 textureCoordinate;

 uniform lowp float temperature;
 uniform lowp float tint;

 const lowp vec3 warmFilter = vec3(0.93, 0.54, 0.0);

 const mediump mat3 RGBtoYIQ = mat3(0.299, 0.587, 0.114, 0.596, -0.274, -0.322, 0.212, -0.523, 0.311);
 const mediump mat3 YIQtoRGB = mat3(1.0, 0.956, 0.621, 1.0, -0.272, -0.647, 1.0, -1.105, 1.702);

 void main() {
   lowp vec4 source = texture2D(inputImageTexture, textureCoordinate);
   mediump vec3 yiq = RGBtoYIQ * source.rgb;
   yiq.b = clamp(yiq.b + tint*0.5226*0.1, -0.5226, 0.5226);
   lowp vec3 rgb = YIQtoRGB * yiq;

   lowp vec3 processed = vec3(
           (rgb.r < 0.5 ? (2.0 * rgb.r * warmFilter.r) : (1.0 - 2.0 * (1.0 - rgb.r) * (1.0 - warmFilter.r))),
           (rgb.g < 0.5 ? (2.0 * rgb.g * warmFilter.g) : (1.0 - 2.0 * (1.0 - rgb.g) * (1.0 - warmFilter.g))),
           (rgb.b < 0.5 ? (2.0 * rgb.b * warmFilter.b) : (1.0 - 2.0 * (1.0 - rgb.b) * (1.0 - warmFilter.b)))
   );

   gl_FragColor = vec4(mix(rgb, processed, temperature), source.a);
 }
);

@implementation SCGPUImageTemperatureFilter

- (id)init {
    self = [super initWithFragmentShaderFromString:kSCGPUImageTemperatureFilterShaderString];
    self.ratio = 0.5f;
    return self;
}

- (void)setRatio:(CGFloat)ratio {
    [super setRatio:ratio];
    
    self.temperature = ratio * (kMAXTemperature - kMinTemperature) + kMinTemperature;
}

- (void)setTemperature:(CGFloat)temperature {
    temperature = MIN(temperature, kMAXTemperature);
    temperature = MAX(temperature, kMinTemperature);
    
    _temperature = temperature;
    [self setFloat:temperature forUniformName:@"temperature"];
}

- (void)setTint:(CGFloat)tint {
    _tint = tint;

    [self setFloat:MAX(tint, 1.0) forUniformName:@"tint"];
}

@end
