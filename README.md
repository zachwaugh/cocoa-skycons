This is a port of the animated HTML5 canvas weather icons - [Skycons](http://darkskyapp.github.io/skycons/) from [forecast.io](http://forecast.io) - to Objective-C/Cocoa. The goal is to work natively on both Mac and iOS exactly as the original canvas version.

This was a weekend hack just to see how easily it could be ported to another platform. Right now, it's pretty much a direct port from JavaScript, without any attempts to make it more Cocoa-like. That can be done after it's working.

## Usage

Create a `SKYIconView`, specify the type, and use it as you would any other NSView/UIView. It will animate by default, but you can disable that with `[icon pause]`.

```
SKYIconView *icon = [[SKYIconView alloc] initWithFrame:frame];
icon.type = SKYRain;
[view addSubview:icon];
```

I'm on the fence about whether each icon type should be a subclass, that probably makes more sense in Objective-C, but this method has the benefit of being able to easily update what the icon is if conditions change.

## Status

This is in the early stages. Currently, mostly works on Mac, but is broken on iOS. Known issues:

- Doesn't work correctly on iOS
- The clouds should be rendered only as an outline, not filled in
- There is a bug in the leaf animation

## Screenshots

![Skycons Mac](http://cl.ly/image/0s3h1t3F1W40/Image%202013-06-18%20at%2010.34.33%20AM.png)

## License

This is released into the public domain, same as the originals.