//
//  SKYView.m
//  Skycons
//
//  Created by Zach Waugh on 6/17/13.
//  Copyright (c) 2013 Zach Waugh. All rights reserved.
//

#import "SKYIconView.h"

#define STROKE 0.08
#define TWO_PI M_PI * 2.0
#define TWO_OVER_SQRT_2 2.0 / sqrt(2)

typedef struct {
  CGFloat start;
  CGFloat end;
} SKYWindOffset;

static const CGFloat WIND_PATHS[2][128] = {
  {
     -0.7500, -0.1800, -0.7219, -0.1527, -0.6971, -0.1225,
     -0.6739, -0.0910, -0.6516, -0.0588, -0.6298, -0.0262,
     -0.6083,  0.0065, -0.5868,  0.0396, -0.5643,  0.0731,
     -0.5372,  0.1041, -0.5033,  0.1259, -0.4662,  0.1406,
     -0.4275,  0.1493, -0.3881,  0.1530, -0.3487,  0.1526,
     -0.3095,  0.1488, -0.2708,  0.1421, -0.2319,  0.1342,
     -0.1943,  0.1217, -0.1600,  0.1025, -0.1290,  0.0785,
     -0.1012,  0.0509, -0.0764,  0.0206, -0.0547, -0.0120,
     -0.0378, -0.0472, -0.0324, -0.0857, -0.0389, -0.1241,
     -0.0546, -0.1599, -0.0814, -0.1876, -0.1193, -0.1964,
     -0.1582, -0.1935, -0.1931, -0.1769, -0.2157, -0.1453,
     -0.2290, -0.1085, -0.2327, -0.0697, -0.2240, -0.0317,
     -0.2064,  0.0033, -0.1853,  0.0362, -0.1613,  0.0672,
     -0.1350,  0.0961, -0.1051,  0.1213, -0.0706,  0.1397,
     -0.0332,  0.1512,  0.0053,  0.1580,  0.0442,  0.1624,
     0.0833,  0.1636,  0.1224,  0.1615,  0.1613,  0.1565,
     0.1999,  0.1500,  0.2378,  0.1402,  0.2749,  0.1279,
     0.3118,  0.1147,  0.3487,  0.1015,  0.3858,  0.0892,
     0.4236,  0.0787,  0.4621,  0.0715,  0.5012,  0.0702,
     0.5398,  0.0766,  0.5768,  0.0890,  0.6123,  0.1055,
     0.6466,  0.1244,  0.6805,  0.1440,  0.7147,  0.1630,
     0.7500,  0.1800
  },
  {
     -0.7500,  0.0000, -0.7033,  0.0195, -0.6569,  0.0399,
     -0.6104,  0.0600, -0.5634,  0.0789, -0.5155,  0.0954,
     -0.4667,  0.1089, -0.4174,  0.1206, -0.3676,  0.1299,
     -0.3174,  0.1365, -0.2669,  0.1398, -0.2162,  0.1391,
     -0.1658,  0.1347, -0.1157,  0.1271, -0.0661,  0.1169,
     -0.0170,  0.1046,  0.0316,  0.0903,  0.0791,  0.0728,
     0.1259,  0.0534,  0.1723,  0.0331,  0.2188,  0.0129,
     0.2656, -0.0064,  0.3122, -0.0263,  0.3586, -0.0466,
     0.4052, -0.0665,  0.4525, -0.0847,  0.5007, -0.1002,
     0.5497, -0.1130,  0.5991, -0.1240,  0.6491, -0.1325,
     0.6994, -0.1380,  0.7500, -0.1400
  }
};

static const SKYWindOffset WIND_OFFSETS[] = { (SKYWindOffset){0.36, 0.11}, (SKYWindOffset){0.56, 0.16} };

@interface SKYIconView ()

@property (strong) NSTimer *timer;

@end

@implementation SKYIconView

- (id)initWithFrame:(NSRect)frame
{
  self = [super initWithFrame:frame];
  if (!self) return nil;
  
  _type = SKYClearDay;
  _color = [NSColor blackColor];
  _timer = [NSTimer scheduledTimerWithTimeInterval:1 / 60.0 target:self selector:@selector(update:) userInfo:nil repeats:YES];
  
  return self;
}

- (void)setColor:(NSColor *)color
{
  _color = color;
  [self setNeedsDisplay:YES];
}

- (void)setType:(SKYIconType)type
{
  _type = type;
  [self setNeedsDisplay:YES];
}

- (BOOL)isFlipped
{
  return YES;
}

#pragma mark - Control

- (void)play
{
  self.timer = [NSTimer scheduledTimerWithTimeInterval:1 / 30.0 target:self selector:@selector(update:) userInfo:nil repeats:YES];
}

- (void)pause
{
  [self.timer invalidate];
  self.timer = nil;
}

- (void)update:(NSTimer *)timer
{
  [self setNeedsDisplay:YES];
}

#pragma mark - Drawing

- (void)drawRect:(NSRect)dirtyRect
{
  CGContextRef ctx = [NSGraphicsContext currentContext].graphicsPort;
  double time = [[NSDate date] timeIntervalSince1970] * 1000;
  CGColorRef color = self.color.CGColor;
  
  switch (self.type) {
    case SKYClearDay:
      [self drawClearDayInContext:ctx time:time color:color];
      break;
    case SKYClearNight:
      [self drawClearNightInContext:ctx time:time color:color];
      break;
    case SKYPartlyCloudyDay:
      [self drawPartlyCloudyDayInContext:ctx time:time color:color];
      break;
    case SKYPartlyCloudyNight:
      [self drawPartlyCloudyNightInContext:ctx time:time color:color];
      break;
    case SKYCloudy:
      [self drawCloudyInContext:ctx time:time color:color];
      break;
    case SKYRain:
      [self drawRainInContext:ctx time:time color:color];
      break;
    case SKYSleet:
      [self drawSleetInContext:ctx time:time color:color];
      break;
    case SKYSnow:
      [self drawSnowInContext:ctx time:time color:color];
      break;
    case SKYWind:
      [self drawWindInContext:ctx time:time color:color];
      break;
    case SKYFog:
      [self drawFogInContext:ctx time:time color:color];
      break;
    default:
      break;
  }
}

#pragma mark - Icons

- (void)drawClearDayInContext:(CGContextRef)ctx time:(CGFloat)time color:(CGColorRef)color
{
  CGFloat w = self.bounds.size.width,
  h = self.bounds.size.height,
  s = MIN(w, h);
  
  sun(ctx, time, w * 0.5, h * 0.5, s, s * STROKE, color);
}

- (void)drawClearNightInContext:(CGContextRef)ctx time:(CGFloat)time color:(CGColorRef)color
{
  CGFloat w = self.bounds.size.width,
  h = self.bounds.size.height,
  s = MIN(w, h);
  
  moon(ctx, time, w * 0.5, h * 0.5, s, s * STROKE, color);
}

- (void)drawPartlyCloudyDayInContext:(CGContextRef)ctx time:(CGFloat)time color:(CGColorRef)color
{
  CGFloat w = self.bounds.size.width,
  h = self.bounds.size.height,
  s = MIN(w, h);
  
  sun(ctx, time, w * 0.625, h * 0.375, s * 0.75, s * STROKE, color);
  cloud(ctx, time, w * 0.375, h * 0.625, s * 0.75, s * STROKE, color);
}

- (void)drawPartlyCloudyNightInContext:(CGContextRef)ctx time:(CGFloat)time color:(CGColorRef)color
{
  CGFloat w = self.bounds.size.width,
  h = self.bounds.size.height,
  s = MIN(w, h);
  
  moon(ctx, time, w * 0.625, h * 0.375, s * 0.75, s * STROKE, color);
  cloud(ctx, time, w * 0.375, h * 0.625, s * 0.75, s * STROKE, color);
}

- (void)drawCloudyInContext:(CGContextRef)ctx time:(CGFloat)time color:(CGColorRef)color
{
  CGFloat w = self.bounds.size.width,
  h = self.bounds.size.height,
  s = MIN(w, h);

  cloud(ctx, time, w * 0.5, h * 0.5, s, s * STROKE, color);
}

- (void)drawRainInContext:(CGContextRef)ctx time:(CGFloat)time color:(CGColorRef)color
{
  CGFloat w = self.bounds.size.width,
  h = self.bounds.size.height,
  s = MIN(w, h);
  
  rain(ctx, time, w * 0.5, h * 0.37, s * 0.9, s * STROKE, color);
  cloud(ctx, time, w * 0.5, h * 0.37, s * 0.9, s * STROKE, color);
}

- (void)drawSleetInContext:(CGContextRef)ctx time:(CGFloat)time color:(CGColorRef)color
{
  CGFloat w = self.bounds.size.width,
  h = self.bounds.size.height,
  s = MIN(w, h);
  
  sleet(ctx, time, w * 0.5, h * 0.37, s * 0.9, s * STROKE, color);
  cloud(ctx, time, w * 0.5, h * 0.37, s * 0.9, s * STROKE, color);
}

- (void)drawSnowInContext:(CGContextRef)ctx time:(CGFloat)time color:(CGColorRef)color
{
  CGFloat w = self.bounds.size.width,
  h = self.bounds.size.height,
  s = MIN(w, h);
  
  snow(ctx, time, w * 0.5, h * 0.37, s * 0.9, s * STROKE, color);
  cloud(ctx, time, w * 0.5, h * 0.37, s * 0.9, s * STROKE, color);
}

- (void)drawWindInContext:(CGContextRef)ctx time:(CGFloat)time color:(CGColorRef)color
{
  CGFloat w = self.bounds.size.width,
  h = self.bounds.size.height,
  s = MIN(w, h);
  
  swoosh(ctx, time, w * 0.5, h * 0.5, s, s * STROKE, 0, 2, color);
  swoosh(ctx, time, w * 0.5, h * 0.5, s, s * STROKE, 1, 2, color);
}

- (void)drawFogInContext:(CGContextRef)ctx time:(CGFloat)time color:(CGColorRef)color
{
  CGFloat w = self.bounds.size.width,
  h = self.bounds.size.height,
  s = MIN(w, h),
  k = s * STROKE;
  
  fogbank(ctx, time, w * 0.5, h * 0.32, s * 0.75, k, color);
  
  time /= 5000;
  
  CGFloat a = cos((time) * TWO_PI) * s * 0.02,
  b = cos((time + 0.25) * TWO_PI) * s * 0.02,
  c = cos((time + 0.50) * TWO_PI) * s * 0.02,
  d = cos((time + 0.75) * TWO_PI) * s * 0.02,
  n = h * 0.936,
  e = floor(n - k * 0.5) + 0.5,
  f = floor(n - k * 2.5) + 0.5;
  
  CGContextSetStrokeColorWithColor(ctx, color);
  CGContextSetLineWidth(ctx, k);
  CGContextSetLineCap(ctx, kCGLineCapRound);
  CGContextSetLineJoin(ctx, kCGLineJoinRound);
  
  line(ctx, a + w * 0.2 + k * 0.5, e, b + w * 0.8 - k * 0.5, e);
  line(ctx, c + w * 0.2 + k * 0.5, f, d + w * 0.8 - k * 0.5, f);
}

#pragma mark - Basic shapes

void puff(CGContextRef ctx, CGFloat t, CGFloat cx, CGFloat cy, CGFloat rx, CGFloat ry, CGFloat rmin, CGFloat rmax)
{
  CGFloat  c = cos(t * TWO_PI),
  s = sin(t * TWO_PI);
  
  rmax -= rmin;
  
  circle(ctx, cx - s * rx, cy + c * ry + rmax * 0.5, rmin + (1 - c * 0.5) * rmax);
}

void puffs(CGContextRef ctx, CGFloat t, CGFloat cx, CGFloat cy, CGFloat rx, CGFloat ry, CGFloat rmin, CGFloat rmax)
{
  CGFloat  i;
  
  for(i = 5; i--; ) {
    puff(ctx, t + i / 5, cx, cy, rx, ry, rmin, rmax);
  }
}

void cloud(CGContextRef ctx, CGFloat t, CGFloat cx, CGFloat cy, CGFloat cw, CGFloat s, CGColorRef color)
{
  t /= 30000;
  
  CGFloat a = cw * 0.21,
  b = cw * 0.12,
  c = cw * 0.24,
  d = cw * 0.28;
  
  CGContextSetFillColorWithColor(ctx, color);
  puffs(ctx, t, cx, cy, a, b, c, d);
  CGContextSetBlendMode(ctx, kCGBlendModeDestinationOut);
  puffs(ctx, t, cx, cy, a, b, c - s, d - s);
  CGContextSetBlendMode(ctx, kCGBlendModeSourceOut);
}

void sun(CGContextRef ctx, CGFloat t, CGFloat cx, CGFloat cy, CGFloat cw, CGFloat s, CGColorRef color)
{
  t /= 120000;
  
  CGFloat a = cw * 0.25 - s * 0.5,
  b = cw * 0.32 + s * 0.5,
  c = cw * 0.50 - s * 0.5,
  i, p, cosine, sine;
  
  CGContextSetStrokeColorWithColor(ctx, color);
  CGContextSetLineWidth(ctx, s);
  CGContextSetLineCap(ctx, kCGLineCapRound);
  CGContextSetLineJoin(ctx, kCGLineJoinRound);
  
  CGContextBeginPath(ctx);
  CGContextAddArc(ctx, cx, cy, a, 0, TWO_PI, 0);
  CGContextStrokePath(ctx);
  
  for (i = 8; i--; ) {
    p = (t + i / 8) * (TWO_PI);
    cosine = cos(p);
    sine = sin(p);
    line(ctx, cx + cosine * b, cy + sine * b, cx + cosine * c, cy + sine * c);
  }
}

void moon(CGContextRef ctx, CGFloat t, CGFloat cx, CGFloat cy, CGFloat cw, CGFloat s, CGColorRef color)
{
  t /= 15000;
  
  CGFloat a = cw * 0.29 - s * 0.5,
  b = cw * 0.05,
  c = cos(t * TWO_PI),
  p = c * TWO_PI / -16;
  
  CGContextSetStrokeColorWithColor(ctx, color);
  CGContextSetLineWidth(ctx, s);
  CGContextSetLineCap(ctx, kCGLineCapRound);
  CGContextSetLineJoin(ctx, kCGLineJoinRound);
  
  cx += c * b;
  
  CGContextBeginPath(ctx);
  CGContextAddArc(ctx, cx, cy, a, p + TWO_PI / 8, p + TWO_PI * 7 / 8, 0);
  CGContextAddArc(ctx, cx + cos(p) * a * TWO_OVER_SQRT_2, cy + sin(p) * a * TWO_OVER_SQRT_2, a, p + TWO_PI * 5 / 8, p + TWO_PI * 3 / 8, 1);
  CGContextClosePath(ctx);
  CGContextStrokePath(ctx);
}

void rain(CGContextRef ctx, CGFloat t, CGFloat cx, CGFloat cy, CGFloat cw, CGFloat s, CGColorRef color)
{
  t /= 1350;
  
  CGFloat a = cw * 0.16,
  b = TWO_PI * 11 / 12,
  c = TWO_PI *  7 / 12,
  i, p, x, y;
  
  CGContextSetFillColorWithColor(ctx, color);
  
  for (i = 4; i--; ) {
    p = (int)(t + i / 4) % 1;
    x = cx + ((i - 1.5) / 1.5) * (i == 1 || i == 2 ? -1 : 1) * a;
    y = cy + p * p * cw;
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, x, y - s * 1.5);
    CGContextAddArc(ctx, x, y, s * 0.75, b, c, false);
    CGContextFillPath(ctx);
  }
}

void sleet(CGContextRef ctx, CGFloat t, CGFloat cx, CGFloat cy, CGFloat cw, CGFloat s, CGColorRef color)
{
  t /= 750;
  
  CGFloat a = cw * 0.1875,
  b = TWO_PI * 11 / 12,
  c = TWO_PI *  7 / 12,
  i, p, x, y;
  
  CGContextSetStrokeColorWithColor(ctx, color);
  CGContextSetLineWidth(ctx, s * 0.5);
  CGContextSetLineCap(ctx, kCGLineCapRound);
  CGContextSetLineJoin(ctx, kCGLineJoinRound);

  for (i = 4; i--; ) {
    p = (int)(t + i / 4) % 1;
    x = floor(cx + ((i - 1.5) / 1.5) * (i == 1 || i == 2 ? -1 : 1) * a) + 0.5;
    y = cy + p * cw;
    line(ctx, x, y - s * 1.5, x, y + s * 1.5);
  }
}

void snow(CGContextRef ctx, CGFloat t, CGFloat cx, CGFloat cy, CGFloat cw, CGFloat s, CGColorRef color)
{
  t /= 3000;
  
  CGFloat a  = cw * 0.16,
  b  = s * 0.75,
  u  = t * TWO_PI * 0.7,
  ux = cos(u) * b,
  uy = sin(u) * b,
  v  = u + TWO_PI / 3,
  vx = cos(v) * b,
  vy = sin(v) * b,
  w  = u + TWO_PI * 2 / 3,
  wx = cos(w) * b,
  wy = sin(w) * b,
  i, p, x, y;
  
  CGContextSetStrokeColorWithColor(ctx, color);
  CGContextSetLineWidth(ctx, s * 0.5);
  CGContextSetLineCap(ctx, kCGLineCapRound);
  CGContextSetLineJoin(ctx, kCGLineJoinRound);
  
  for (i = 4; i--; ) {
    p = (int)(t + i / 4) % 1;
    x = cx + sin((p + i / 4) * TWO_PI) * a;
    y = cy + p * cw;
    
    line(ctx, x - ux, y - uy, x + ux, y + uy);
    line(ctx, x - vx, y - vy, x + vx, y + vy);
    line(ctx, x - wx, y - wy, x + wx, y + wy);
  }
}

void fogbank(CGContextRef ctx, CGFloat t, CGFloat cx, CGFloat cy, CGFloat cw, CGFloat s, CGColorRef color) {
  t /= 30000;
  
  CGFloat a = cw * 0.21,
  b = cw * 0.06,
  c = cw * 0.21,
  d = cw * 0.28;
  
  CGContextSetFillColorWithColor(ctx, color);
  puffs(ctx, t, cx, cy, a, b, c, d);

  CGContextSetBlendMode(ctx, kCGBlendModeDestinationOut);
  puffs(ctx, t, cx, cy, a, b, c - s, d - s);
  CGContextSetBlendMode(ctx, kCGBlendModeSourceOut);
}

void leaf(CGContextRef ctx, CGFloat t, CGFloat x, CGFloat y, CGFloat cw, CGFloat s, CGColorRef color)
{
  CGFloat a = cw / 8,
  b = a / 3,
  c = 2 * b,
  d = ((int)t % 1) * TWO_PI,
  e = cos(d),
  f = sin(d);
  
  CGContextSetFillColorWithColor(ctx, color);
  CGContextSetStrokeColorWithColor(ctx, color);
  CGContextSetLineWidth(ctx, s);
  CGContextSetLineCap(ctx, kCGLineCapRound);
  CGContextSetLineJoin(ctx, kCGLineJoinRound);;
  
  CGContextBeginPath(ctx);
  CGContextAddArc(ctx, x, y, a, d, d + M_PI, 0);
  CGContextAddArc(ctx, x - b * e, y - b * f, c, d + M_PI, d, false);
  CGContextAddArc(ctx, x + c * e, y + c * f, b, d + M_PI, d, true );
  CGContextSetBlendMode(ctx, kCGBlendModeDestinationOut);
  CGContextFillPath(ctx);
  CGContextSetBlendMode(ctx, kCGBlendModeSourceAtop);
  CGContextStrokePath(ctx);
}

void swoosh(CGContextRef ctx, CGFloat t, CGFloat cx, CGFloat cy, CGFloat cw, CGFloat s, NSInteger index, CGFloat total, CGColorRef color)
{
  t /= 2500;
  
  SKYWindOffset windOffset = WIND_OFFSETS[index];
  
  NSInteger pathLength = sizeof(WIND_PATHS[index]) / sizeof(WIND_PATHS[index][0]);
  CGFloat *path = WIND_PATHS[index];
  
  NSInteger a = (int)(t + index - windOffset.start) % (int)total,
  c = (int)(t + index - windOffset.end) % (int)total,
  e = (int)(t + index) % (int)total,
  b, d, f, i;
  
  CGContextSetStrokeColorWithColor(ctx, color);
  CGContextSetLineWidth(ctx, s);
  CGContextSetLineCap(ctx, kCGLineCapRound);
  CGContextSetLineJoin(ctx, kCGLineJoinRound);
  
  if (a < 1) {
    CGContextBeginPath(ctx);
    
    a *= pathLength / 2 - 1;
    b  = floor(a);
    a -= b;
    b *= 2;
    b += 2;
    
    CGContextMoveToPoint(ctx, cx + (path[b - 2] * (1 - a) + path[b] * a) * cw, cy + (path[b - 1] * (1 - a) + path[b + 1] * a) * cw);
    
    if (c < 1) {
      c *= pathLength / 2 - 1;
      d  = floor(c);
      c -= d;
      d *= 2;
      d += 2;
      
      for (i = b; i != d; i += 2) {
        CGContextAddLineToPoint(ctx, cx + path[i] * cw, cy + path[i + 1] * cw);
      }
      
      CGContextAddLineToPoint(ctx, cx + (path[d - 2] * (1 - c) + path[d] * c) * cw, cy + (path[d - 1] * (1 - c) + path[d + 1] * c) * cw);
    }
    
    else {
      for (i = b; i != pathLength; i += 2) {
        CGContextAddLineToPoint(ctx, cx + path[i] * cw, cy + path[i + 1] * cw);
      }
    }

    CGContextStrokePath(ctx);
  } else if (c < 1) {
    CGContextBeginPath(ctx);
    
    c *= pathLength / 2 - 1;
    d  = floor(c);
    c -= d;
    d *= 2;
    d += 2;
    
    CGContextMoveToPoint(ctx, cx + path[0] * cw, cy + path[1] * cw);
    
    for (i = 2; i != d; i += 2) {
      CGContextAddLineToPoint(ctx, cx + path[i] * cw, cy + path[i + 1] * cw);
    }
    
    CGContextAddLineToPoint(ctx, cx + (path[d - 2] * (1 - c) + path[d] * c) * cw, cy + (path[d - 1] * (1 - c) + path[d + 1] * c) * cw);
    CGContextStrokePath(ctx);
  }
  
  if (e < 1) {
    e *= pathLength / 2 - 1;
    f  = floor(e);
    e -= f;
    f *= 2;
    f += 2;
    
    leaf(ctx, t, cx + (path[f - 2] * (1 - e) + path[f] * e) * cw, cy + (path[f - 1] * (1 - e) + path[f + 1] * e) * cw, cw, s, color);
  }
}

#pragma mark - Drawing primitives

void circle(CGContextRef ctx, CGFloat x, CGFloat y, CGFloat r)
{
  CGContextBeginPath(ctx);
  CGContextAddArc(ctx, x, y, r, 0, M_PI * 2.0, 0);
  CGContextFillPath(ctx);
}

void line(CGContextRef ctx, CGFloat ax, CGFloat ay, CGFloat bx, CGFloat by)
{
  CGContextBeginPath(ctx);
  CGContextMoveToPoint(ctx, ax, ay);
  CGContextAddLineToPoint(ctx, bx, by);
  CGContextStrokePath(ctx);
}

@end
