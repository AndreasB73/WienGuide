//
//  UIView+Extensions.m
//  Trinkbrunnen
//
//  Created by Bachmaier Andreas on 21.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIView+Extensions.h"
#import "QuartzCore/QuartzCore.h"

@implementation UIView (Extensions)

- (void) enableRoundRectsWithValue:(float)nValue 
                        borderWith:(float)nWidth 
                       borderColor:(UIColor *)nColor
{
    [self enableRoundRectsWithValue:nValue];
    self.layer.borderWidth = nWidth;
    self.layer.borderColor = nColor.CGColor;
}

- (void) enableRoundRectsWithValue:(float)nValue
{
    self.layer.masksToBounds = true;
    self.layer.cornerRadius = nValue;
}

- (void) enableRoundRects
{
    [self enableRoundRectsWithValue:5];
}
@end
