//
//  MapController.m
//  Trinkbrunnen
//
//  Created by Andreas Bachmaier on 19.11.14.
//
//

#import "MapController.h"

#define SPAN 0.03f

@interface MapController()

@property (nonatomic) MKCoordinateRegion currentRegion;
@property (nonatomic) MKCoordinateSpan currentSpan;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation MapController

- (IBAction)goToVienna {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(48.2085f, 16.373f);
    [self setMapToCoordinate:coordinate];
}

- (instancetype)initWithContext:(id)context {
    self = [super init];
    
    if (self) {
        // Initialize variables here.
        // Configure interface objects here.
        
        _currentSpan = MKCoordinateSpanMake(SPAN, SPAN);
        [self setTitle:context];
        
    }
    
    return self;
}

- (void)willActivate {
    // This method is called when the controller is about to be visible to the wearer.
    //NSLog(@"%@ will activate", self);
    
    self.locationManager = [[CLLocationManager alloc] init];
    CLLocationCoordinate2D coordinate = self.locationManager.location.coordinate;
    if (coordinate.latitude == 0 && coordinate.longitude == 0)
        [self goToVienna];
    else
        [self setMapToCoordinate:coordinate];
    
    [self.map addAnnotation:coordinate withPinColor:WKInterfaceMapPinColorGreen];
}

- (void)didDeactivate {
    // This method is called when the controller is no longer visible.
    //NSLog(@"%@ did deactivate", self);
    self.locationManager = nil;
}

- (IBAction)zoomOut {
    MKCoordinateSpan span = MKCoordinateSpanMake(self.currentSpan.latitudeDelta * 2, self.currentSpan.longitudeDelta * 2);
    MKCoordinateRegion region = MKCoordinateRegionMake(self.currentRegion.center, span);
    
    self.currentSpan = span;
    [self.map setRegion:region];
}

- (IBAction)zoomIn {
    MKCoordinateSpan span = MKCoordinateSpanMake(self.currentSpan.latitudeDelta * 0.5f, self.currentSpan.longitudeDelta * 0.5f);
    MKCoordinateRegion region = MKCoordinateRegionMake(self.currentRegion.center, span);
    
    self.currentSpan = span;
    [self.map setRegion:region];
}

- (void)setMapToCoordinate:(CLLocationCoordinate2D)coordinate {
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, self.currentSpan);
    self.currentRegion = region;
    
    MKMapPoint newCenterPoint = MKMapPointForCoordinate(coordinate);
    
    [self.map setVisibleMapRect:MKMapRectMake(newCenterPoint.x, newCenterPoint.y, self.currentSpan.latitudeDelta, self.currentSpan.longitudeDelta)];
    [self.map setRegion:region];
}

@end
