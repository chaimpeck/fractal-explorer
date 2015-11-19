//
//  AppDelegate.h
//  Fractal Explorer
//
//  Created by Jeffrey Peck on 11/18/15.
//  Copyright © 2015 Chaim Peck. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FractalNSView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet FractalNSView *fractalNSView;

@end

