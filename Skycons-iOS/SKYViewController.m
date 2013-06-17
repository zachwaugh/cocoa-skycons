//
//  SKYViewController.m
//  Skycons-iOS
//
//  Created by Zach Waugh on 6/17/13.
//  Copyright (c) 2013 Zach Waugh. All rights reserved.
//

#import "SKYViewController.h"
#import "SKYIconView.h"

#define ICON_SIZE 96
#define PADDING 20

@interface SKYViewController ()

@property (strong) NSMutableArray *icons;

@end

@implementation SKYViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.icons = [[NSMutableArray alloc] init];
  NSArray *types = @[@(SKYClearDay), @(SKYClearNight), @(SKYPartlyCloudyDay), @(SKYPartlyCloudyNight), @(SKYCloudy), @(SKYRain), @(SKYSleet), @(SKYSnow), @(SKYWind), @(SKYFog)];
  
  UIView *container = self.view;
  CGRect frame = CGRectMake(PADDING, PADDING, ICON_SIZE, ICON_SIZE);
  
  for (int i = 1; i <= types.count; i++) {
    SKYIconType type = [types[i - 1] integerValue];
    SKYIconView *icon = [[SKYIconView alloc] initWithFrame:frame];
    icon.type = type;
    [container addSubview:icon];
    [self.icons addObject:icon];
    
    frame.origin.x += ICON_SIZE + PADDING;
    
    // Move to another row
    if (CGRectGetMaxX(frame) > CGRectGetMaxX(container.bounds)) {
      frame.origin.y += ICON_SIZE + PADDING;
      frame.origin.x = PADDING;
    }
  }
}


@end
