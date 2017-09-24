//
//  UIView+Extensions.h
//  Trinkbrunnen
//
//  Created by Bachmaier Andreas on 21.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extensions)

- (void) enableRoundRectsWithValue:(float)nValue borderWith:(float)nWidth borderColor:(UIColor *)nColor;
- (void) enableRoundRectsWithValue:(float)nValue;
- (void) enableRoundRects;

@end
