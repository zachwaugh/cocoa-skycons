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

#pragma mark - Drawing shapes

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
