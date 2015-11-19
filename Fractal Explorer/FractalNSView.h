//
//  FractalNSView.h
//  Fractal Explorer
//
//  Created by Jeffrey Peck on 11/18/15.
//  Copyright © 2015 Chaim Peck. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FractalNSView : NSView {
@private
    NSTrackingArea * trackingArea;

    int maxIterations;
    float xScale, yScale, xOffset, yOffset;
}

@end
