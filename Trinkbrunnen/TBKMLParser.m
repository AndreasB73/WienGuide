//
//  TBKMLParser.m
//  Trinkbrunnen
//
//  Created by Andreas Bachmaier on 04.10.12.
//
//

#import "TBKMLParser.h"

@implementation KMLPlacemark (Extensions)

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.placemarkDescription];
    [encoder encodeObject:self.point];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self.placemarkDescription = [decoder decodeObject];
    id <MKAnnotation> newPoint = [decoder decodeObject];
    [self.point setCoordinate:[newPoint coordinate]];
    
    return  self;
}

@end

@implementation MKPointAnnotation (Extensions)

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeDouble:self.coordinate.latitude forKey:@"latitude"];
    [encoder encodeDouble:self.coordinate.longitude forKey:@"longitude"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [decoder decodeDoubleForKey:@"latitude"];
    coordinate.longitude = [decoder decodeDoubleForKey:@"longitude"];
    self.coordinate = coordinate;
    
    return  self;
}

@end