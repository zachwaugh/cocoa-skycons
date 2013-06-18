//
//  SKYBackgroundView.m
//  Skycons
//
//  Created by Zach Waugh on 6/17/13.
//  Copyright (c) 2013 Zach Waugh. All rights reserved.
//

#import "SKYBackgroundView.h"

@implementation SKYBackgroundView

- (BOOL)isFlipped
{
  return YES;
}

- (void)drawRect:(NSRect)dirtyRect
{
  [[NSColor orangeColor] set];
  NSRectFill(self.bounds);
}

@end
