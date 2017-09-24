//
//  TBKMLParser.h
//  Trinkbrunnen
//
//  Created by Andreas Bachmaier on 04.10.12.
//
//

#import "KMLParser.h"

@interface KMLPlacemark (Extensions) <NSCoding>

- (void)encodeWithCoder:(NSCoder *)encoder;
- (id)initWithCoder:(NSCoder *)decoder;

@end

@interface MKPointAnnotation (Extensions) <NSCoding>

- (void)encodeWithCoder:(NSCoder *)encoder;
- (id)initWithCoder:(NSCoder *)decoder;

@end
