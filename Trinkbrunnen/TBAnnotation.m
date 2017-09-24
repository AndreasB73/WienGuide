//
//  TBAnnotation.m
//  Trinkbrunnen
//
//  Created by Andreas Bachmaier on 22.11.13.
//
//

#import "TBAnnotation.h"

@implementation TBAnnotation

@synthesize title = _title;
@synthesize description = _description;
@synthesize coordinate = _coordinate;
@synthesize subtitle = _subtitle;

- (id)initWithTitle:(NSString *)title andCoordinate:(CLLocationCoordinate2D)coordinate andSubtitle:(NSString *)description
{
	self = [super init];
	self.title = title;
	self.coordinate = coordinate;
    self.description = description;
	return self;
}

@end
