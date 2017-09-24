//
//  TBAnnotation.h
//  Trinkbrunnen
//
//  Created by Andreas Bachmaier on 22.11.13.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface TBAnnotation : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (atomic, copy) NSString *description;
@property (nonatomic) CLLocationCoordinate2D coordinate;

- (id)initWithTitle:(NSString *)title
      andCoordinate:(CLLocationCoordinate2D)coordinate
        andSubtitle:(NSString *)description;

@end
