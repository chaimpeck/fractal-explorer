//
//  FractalNSView.m
//  Fractal Explorer
//
//  Created by Jeffrey Peck on 11/18/15.
//  Copyright © 2015 Chaim Peck. All rights reserved.
//

#import "FractalNSView.h"

@implementation FractalNSView

- (void) awakeFromNib {
    maxIterations = 1000;
    
    xScale = 3.5f;
    yScale = 2.5f;
    xOffset = -1.0f;
    yOffset = 0.0f;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    /* To create the bitmap bit-by-bit, create a new NSBitmapImageRep object with the parameters you want and manipulate the pixels directly. You can use the bitmapData method to get the raw pixel buffer. NSBitmapImageRep also defines methods for getting and setting individual pixel values. This technique is the most labor intensive but gives you the most control over the bitmap contents. For example, you might use it if you want to decode the raw image data yourself and transfer it to the bitmap image representation.
     
        - https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CocoaDrawingGuide/Images/Images.html#//apple_ref/doc/uid/TP40003290-CH208-BCICHFGA
    */
    
    NSBitmapImageRep *fractalImageRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:dirtyRect];
    
    NSLog(@"About to update %fx%f rect at point %fx%f", dirtyRect.size.width, dirtyRect.size.height, dirtyRect.origin.x, dirtyRect.origin.y);
    
    NSInteger maxWidth = self.bounds.size.width;
    NSInteger maxHeight = self.bounds.size.height;
    NSInteger xDrawOrigin = dirtyRect.origin.x;
    NSInteger yDrawOrigin = dirtyRect.origin.y;
    NSInteger drawWidth = dirtyRect.size.width;
    NSInteger drawHeight = dirtyRect.size.height;
    
    NSInteger px, py;
    
    // Generate a color for each number of iterations
    NSUInteger colors[maxIterations][3];
    
    for (int i = 0; i < maxIterations; i++) {
        if (i % 3 == 0) {
            colors[i][0] = 255.0 - round(255.0 * i/maxIterations/3);
            colors[i][1] = 1;
            colors[i][2] = 1;
        }
        else if (i % 3 == 1) {
            colors[i][0] = 1;
            colors[i][1] = 255.0 - round(255.0 * i/maxIterations/3);
            colors[i][2] = 1;
        }
        else {
            colors[i][0] = 1;
            colors[i][1] = 1;
            colors[i][2] = 255.0 - round(255.0 * i/maxIterations/3);
        }
    }
    
    NSUInteger black[3] = {0, 0, 0};
    
    // Draw fractal
    double x0, y0, x, y, xtemp = 0.0;
    
    int iteration;
    
    for (py = yDrawOrigin; py < drawHeight; py++) {
        for (px = xDrawOrigin; px < drawWidth; px++) {
            
            x0 = ((xScale * (px - (maxWidth / 2))) / (maxWidth)) + xOffset;
            y0 = ((yScale * (py - (maxHeight / 2))) / (maxHeight)) + yOffset;
            
            x = 0.f;
            y = 0.f;
            
            iteration = 0;
            
            while ((((x * x) + (y * y)) <= 4.0f) && (iteration < maxIterations))
            {
                xtemp = ((x * x) - (y * y)) + x0;
                y = ((2.0f * x) * y) + y0;
                x = xtemp;
                iteration += 1;
            }
            
            if (iteration < maxIterations) {
                [fractalImageRep setPixel:colors[iteration] atX:px y:py];
            }
            else {
                [fractalImageRep setPixel:black atX:px y:py];
            }
        }
    }
    
    [NSGraphicsContext saveGraphicsState];
    
    [fractalImageRep drawInRect:dirtyRect];
    
    [NSGraphicsContext restoreGraphicsState];
    
}

- (void)mouseEntered:(NSEvent *)event
{
    [super mouseEntered:event];
    [[NSCursor crosshairCursor] set];
}

- (void)mouseExited:(NSEvent *)event
{
    [super mouseExited:event];
    [[NSCursor arrowCursor] set];
}

- (void)mouseDown:(NSEvent *)event
{
    [super mouseDown:event];
}

- (void)mouseUp:(NSEvent *)event
{
    [super mouseUp:event];
    
    NSPoint magnificationCenter = NSMakePoint(event.locationInWindow.x - self.frame.origin.x,
                                              event.locationInWindow.y - self.frame.origin.y);
    
    
    NSLog(@"Old X Offset: %f", xOffset);
    
    xOffset += (xScale * magnificationCenter.x / self.bounds.size.width) - (xScale / 2);
    yOffset -= (yScale * magnificationCenter.y / self.bounds.size.height) - (yScale / 2);
    
    NSLog(@"New X Offset: %f", xOffset);
    
    xScale /= 2;
    yScale /= 2;
    
    [self setNeedsDisplay:YES];
    
    NSLog(@"%@", NSStringFromPoint(magnificationCenter));
}

- (void)updateTrackingAreas
{
    if(trackingArea != nil) {
        [self removeTrackingArea:trackingArea];
    }
    
    int opts = (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways);
    trackingArea = [ [NSTrackingArea alloc] initWithRect:[self bounds]
                                                 options:opts
                                                   owner:self
                                                userInfo:nil];
    [self addTrackingArea:trackingArea];
}


@end
