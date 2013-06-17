//
//  SKYView.m
//  Skycons
//
//  Created by Zach Waugh on 6/17/13.
//  Copyright (c) 2013 Zach Waugh. All rights reserved.
//

#import "SKYView.h"

#define STROKE 0.08
#define TWO_PI M_PI * 2.0
#define TWO_OVER_SQRT_2 2.0 / sqrt(2)

void sun(CGContextRef ctx, CGFloat t, CGFloat cx, CGFloat cy, CGFloat cw, CGFloat s, CGColorRef color);
void circle(CGContextRef ctx, CGFloat x, CGFloat y, CGFloat r);
void line(CGContextRef ctx, CGFloat ax, CGFloat ay, CGFloat bx, CGFloat by);

@implementation SKYView

- (id)initWithFrame:(NSRect)frame
{
  self = [super initWithFrame:frame];
  if (!self) return nil;
  
  _type = SKYClearDay;
  _color = [NSColor blackColor];
  
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
  
}

- (void)pause
{
  
}

#pragma mark - Drawing

- (void)drawRect:(NSRect)dirtyRect
{
  CGContextRef ctx = [NSGraphicsContext currentContext].graphicsPort;
  CGFloat time = [[NSDate date] timeIntervalSince1970];
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
    default:
      break;
  }
}

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

#pragma mark - Drawing shapes

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

void sun(CGContextRef ctx, CGFloat t, CGFloat cx, CGFloat cy, CGFloat cw, CGFloat s, CGColorRef color) {
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
  
  for(i = 8; i--; ) {
    p = (t + i / 8) * (TWO_PI);
    cosine = cos(p);
    sine = sin(p);
    line(ctx, cx + cosine * b, cy + sine * b, cx + cosine * c, cy + sine * c);
  }
}

void moon(CGContextRef ctx, CGFloat t, CGFloat cx, CGFloat cy, CGFloat cw, CGFloat s, CGColorRef color) {
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

//function rain(ctx, t, cx, cy, cw, s, color) {
//  t /= 1350;
//  
//  var a = cw * 0.16,
//  b = TWO_PI * 11 / 12,
//  c = TWO_PI *  7 / 12,
//  i, p, x, y;
//  
//  ctx.fillStyle = color;
//  
//  for(i = 4; i--; ) {
//    p = (t + i / 4) % 1;
//    x = cx + ((i - 1.5) / 1.5) * (i === 1 || i === 2 ? -1 : 1) * a;
//    y = cy + p * p * cw;
//    ctx.beginPath();
//    ctx.moveTo(x, y - s * 1.5);
//    ctx.arc(x, y, s * 0.75, b, c, false);
//    ctx.fill();
//  }
//}

//function sleet(ctx, t, cx, cy, cw, s, color) {
//  t /= 750;
//  
//  var a = cw * 0.1875,
//  b = TWO_PI * 11 / 12,
//  c = TWO_PI *  7 / 12,
//  i, p, x, y;
//  
//  ctx.strokeStyle = color;
//  ctx.lineWidth = s * 0.5;
//  ctx.lineCap = "round";
//  ctx.lineJoin = "round";
//  
//  for(i = 4; i--; ) {
//    p = (t + i / 4) % 1;
//    x = Math.floor(cx + ((i - 1.5) / 1.5) * (i === 1 || i === 2 ? -1 : 1) * a) + 0.5;
//    y = cy + p * cw;
//    line(ctx, x, y - s * 1.5, x, y + s * 1.5);
//  }
//}

//function snow(ctx, t, cx, cy, cw, s, color) {
//  t /= 3000;
//  
//  var a  = cw * 0.16,
//  b  = s * 0.75,
//  u  = t * TWO_PI * 0.7,
//  ux = Math.cos(u) * b,
//  uy = Math.sin(u) * b,
//  v  = u + TWO_PI / 3,
//  vx = Math.cos(v) * b,
//  vy = Math.sin(v) * b,
//  w  = u + TWO_PI * 2 / 3,
//  wx = Math.cos(w) * b,
//  wy = Math.sin(w) * b,
//  i, p, x, y;
//  
//  ctx.strokeStyle = color;
//  ctx.lineWidth = s * 0.5;
//  ctx.lineCap = "round";
//  ctx.lineJoin = "round";
//  
//  for(i = 4; i--; ) {
//    p = (t + i / 4) % 1;
//    x = cx + Math.sin((p + i / 4) * TWO_PI) * a;
//    y = cy + p * cw;
//    
//    line(ctx, x - ux, y - uy, x + ux, y + uy);
//    line(ctx, x - vx, y - vy, x + vx, y + vy);
//    line(ctx, x - wx, y - wy, x + wx, y + wy);
//  }
//}

//function fogbank(ctx, t, cx, cy, cw, s, color) {
//  t /= 30000;
//  
//  var a = cw * 0.21,
//  b = cw * 0.06,
//  c = cw * 0.21,
//  d = cw * 0.28;
//  
//  ctx.fillStyle = color;
//  puffs(ctx, t, cx, cy, a, b, c, d);
//  
//  ctx.globalCompositeOperation = 'destination-out';
//  puffs(ctx, t, cx, cy, a, b, c - s, d - s);
//  ctx.globalCompositeOperation = 'source-over';
//}

#pragma mark - Drawing pritives

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
