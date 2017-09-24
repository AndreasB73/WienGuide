//
//  TBModel.m
//  Trinkbrunnen
//
//  Created by Bachmaier Andreas on 14.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TBModel.h"
#import "TBKMLParser.h"
#import "TBKMLDescriptionParser.h"

@interface TBModel()

@property (strong, nonatomic) KMLParser *kml;

@end


@implementation TBModel

#define FAVOURITES_KEY  @"WienGuide.Favourites"

@synthesize kml = _kml;
@synthesize title = _title;
@synthesize annotationIcon = _annotationIcon;
@synthesize annotationImage = _annotationImage;
@synthesize selectedAnnotation = _selectedAnnotation;
@synthesize selectedKmlIndex = _selectedKmlIndex;
@synthesize currentLocation = _currentLocation;
@synthesize locationManager = _locationManager;
@synthesize selectedIndexPath = _selectedIndexPath;
@synthesize annotations;

+ (TBModel *) getInstance
{
    static TBModel *model;
    
    if (!model)
    {
        model = [[TBModel alloc] init];
        model.locationManager = [[CLLocationManager alloc] init];
        
        if ([model.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [model.locationManager requestWhenInUseAuthorization];
        }

        model.selectedIndexPath = nil;
        //NSLog(@"model Singleton angelegt!");
    }
    
    return model;
}


- (void) initKml
{
    self.kml = nil;
    
    switch (self.selectedKmlIndex)
    {
        case 0:
            [self initKmlWithString:@"http://data.wien.gv.at/daten/geo?version=1.3.0&service=WMS&request=GetMap&crs=EPSG:4326&bbox=48.10,16.16,48.34,16.59&width=1&height=1&layers=ogdwien:TRINKBRUNNENOGD&styles=&format=application/vnd.google-earth.kml+xml"];
            self.title = NSLocalizedString(@"Trinkbrunnen", nil);
            self.annotationIcon = [[NSURL alloc] initWithString:@"http://data.wien.gv.at/katalog/images/trinkbrunnen.png"];
            [self parseDescriptions:@"Trinkbrunnen"];
            break;
            
        case 1:
            [self initKmlWithString:@"http://data.wien.gv.at/daten/geo?version=1.3.0&service=WMS&request=GetMap&crs=EPSG:4326&bbox=48.10,16.16,48.34,16.59&width=1&height=1&layers=ogdwien:BADESTELLENOGD&styles=&format=application/vnd.google-earth.kml+xml"];
            self.title = NSLocalizedString(@"Badestellen", nil);
            self.annotationIcon = [[NSURL alloc] initWithString:@"http://data.wien.gv.at/katalog/images/badestelle.png"];
            [self parseDescriptions:@"Badestellen"];

            break;
            
        case 2:
            [self initKmlWithString:@"http://data.wien.gv.at/daten/geo?version=1.3.0&service=WMS&request=GetMap&crs=EPSG:4326&bbox=48.10,16.16,48.34,16.59&width=1&height=1&layers=ogdwien:SCHWIMMBADOGD&styles=&format=application/vnd.google-earth.kml+xml"];
            self.title = NSLocalizedString(@"Schwimmbäder", nil);
            self.annotationIcon = [[NSURL alloc] initWithString:@"http://data.wien.gv.at/katalog/images/schwimmbad.png"];
            [self parseDescriptions:@"Schwimmbäder"];

            break;
            
        case 3:
            [self initKmlWithString:@"http://maps.google.at/maps/ms?ie=UTF8&hl=de&t=h&source=embed&authuser=0&msa=0&output=kml&msid=215284772885912952964.0004a353f71fac8d7fdc1"];
            self.title = NSLocalizedString(@"FKK", nil);
            self.annotationIcon = [[NSURL alloc] initWithString:@"http://www.nudistenblog.net/nude_tafel_kl.jpg"];
            break;
            
        case 4:
            [self initKmlWithString:@"http://data.wien.gv.at/daten/geo?version=1.3.0&service=WMS&request=GetMap&crs=EPSG:4326&bbox=48.10,16.16,48.34,16.59&width=1&height=1&layers=ogdwien:WCANLAGEOGD&styles=&format=application/vnd.google-earth.kml+xml"];
            self.title = NSLocalizedString(@"WC", nil);
            self.annotationIcon = [[NSURL alloc] initWithString:@"http://data.wien.gv.at/katalog/images/oeffwcwartepersonal.png"];
            [self parseDescriptions:@"WC"];

            break;
            
        case 5:
            [self initKmlWithString:@"http://data.wien.gv.at/daten/geo?version=1.3.0&service=WMS&request=GetMap&crs=EPSG:4326&bbox=48.10,16.16,48.34,16.59&width=1&height=1&layers=ogdwien:DEFIBRILLATOROGD&styles=&format=application/vnd.google-earth.kml+xml"];
            self.title = NSLocalizedString(@"Defibrillator", nil);
            self.annotationIcon = [[NSURL alloc] initWithString:@"http://data.wien.gv.at/katalog/images/defibrillator.png"];
            [self parseDescriptions:@"Defibrillator"];
            break;
            
        case 10:
            [self initKmlWithString:@"http://www.freewave.at/hotspots.kml"];
            self.title = NSLocalizedString(@"Freewave", nil);
            self.annotationIcon = [[NSURL alloc] initWithString:@"http://www.bachmaier.cc/appicons/wlan.png"];
            break;
            
        case 11:
            [self initKmlWithString:@"http://data.wien.gv.at/daten/geo?version=1.3.0&service=WMS&request=GetMap&crs=EPSG:4326&bbox=48.10,16.16,48.34,16.59&width=1&height=1&layers=ogdwien:MULTIMEDIAOGD&styles=&format=application/vnd.google-earth.kml+xml"];
            self.title = NSLocalizedString(@"Multimedia-Stationen", nil);
            self.annotationIcon = [[NSURL alloc] initWithString:@"http://data.wien.gv.at/katalog/images/multimediastation.png"];
            [self parseDescriptions:@"Multimedia"];
            break;
  
        case 20: 
            [self initKmlWithString:@"http://data.wien.gv.at/daten/geo?version=1.3.0&service=WMS&request=GetMap&crs=EPSG:4326&bbox=48.10,16.16,48.34,16.59&width=1&height=1&layers=ogdwien:SPIELPLATZOGD&styles=&format=application/vnd.google-earth.kml+xml"];
            self.title = NSLocalizedString(@"Spielplätze", nil);
            self.annotationIcon = [[NSURL alloc] initWithString:@"http://data.wien.gv.at/katalog/images/spielplatzogd.png"];
            [self parseDescriptions:@"Spielplätze"];

            break;
            
        case 21:
            [self initKmlWithString:@"http://data.wien.gv.at/daten/geo?version=1.3.0&service=WMS&request=GetMap&crs=EPSG:4326&bbox=48.10,16.16,48.34,16.59&width=1&height=1&layers=ogdwien:SPORTSTAETTENOGD&styles=&format=application/vnd.google-earth.kml+xml"];
            self.title = NSLocalizedString(@"Sportstätten", nil);
            self.annotationIcon = [[NSURL alloc] initWithString:@"http://data.wien.gv.at/katalog/images/sportstaette-oeffentlich-outdoor.png"];
            [self parseDescriptions:@"Sportstätten"];
            break;
            
        case 22:
            [self initKmlWithString:@"http://data.wien.gv.at/daten/geo?version=1.3.0&service=WMS&request=GetMap&crs=EPSG:4326&bbox=48.10,16.16,48.34,16.59&width=1&height=1&layers=ogdwien:CITYBIKEOGD&styles=&format=application/vnd.google-earth.kml+xml"];
            self.title = NSLocalizedString(@"Citybikes", nil);
            self.annotationIcon = [[NSURL alloc] initWithString:@"http://data.wien.gv.at/katalog/images/citybike.png"];
            [self parseDescriptions:@"Citybikes"];
            break;
            
        case 30:
            [self initKmlWithString:@"http://www.cusoon.at/wien-tierparks.kml"];
            [self descriptionReplacement:@"/photos/" toString:@"http://www.cusoon.at/photos/"];
            self.title = NSLocalizedString(@"Tierparks", nil);
            self.annotationIcon = [[NSURL alloc] initWithString:@"http://www.cusoon.at/static/1193298402/images/icons/themen64/tierparks.png"];
            break;
        case 31:
            [self initKmlWithString:@"http://www.cusoon.at/wien-freizeitparks.kml"];
            [self descriptionReplacement:@"/photos/" toString:@"http://www.cusoon.at/photos/"];
            self.title = NSLocalizedString(@"Freizeitparks", nil);
            self.annotationIcon = [[NSURL alloc] initWithString:@"http://www.cusoon.at/static/1193298402/images/icons/themen64/freizeitparks.png"];
            break;
            
        case 40:
            [self initKmlWithString:@"http://data.wien.gv.at/daten/geo?version=1.3.0&service=WMS&request=GetMap&crs=EPSG:4326&bbox=48.10,16.16,48.34,16.59&width=1&height=1&layers=ogdwien:BURGSCHLOSSOGD&styles=&format=application/vnd.google-earth.kml+xml"];
            self.title = NSLocalizedString(@"Burgen & Schlösser", nil);
            self.annotationIcon = [[NSURL alloc] initWithString:@"http://data.wien.gv.at/katalog/images/burgschlossogdsichtbar.png"];
            [self parseDescriptions:@"Schloss"];
            break;
            
        case 41:
            [self initKmlWithString:@"http://data.wien.gv.at/daten/geo?version=1.3.0&service=WMS&request=GetMap&crs=EPSG:4326&bbox=48.10,16.16,48.34,16.59&width=1&height=1&layers=ogdwien:MUSEUMOGD&styles=&format=application/vnd.google-earth.kml+xml"];
            self.title = NSLocalizedString(@"Museen", nil);
            self.annotationIcon = [[NSURL alloc] initWithString:@"http://data.wien.gv.at/katalog/images/museum.png"];
            [self parseDescriptions:@"Museum"];
            break;
            
        case 50:
            //[self initKmlWithString:@"http://www.glotter.com/data/kml/data11.kml"];
            [self initKmlWithString:@"http://data.wien.gv.at/daten/geo?version=1.3.0&service=WMS&request=GetMap&crs=EPSG:4326&bbox=48.10,16.16,48.34,16.59&width=1&height=1&layers=ogdwien:UBAHNOGD,ogdwien:UBAHNHALTOGD&styles=&format=application/vnd.google-earth.kml+xml"];
            
            self.annotationIcon = [[NSURL alloc] initWithString:@"http://www.bachmaier.cc/appicons/ubahn64.png"];
            self.title = NSLocalizedString(@"U-Bahn Stationen", nil);
            [self parseDescriptions:@"UBahn"];
            break;
            
        case 51:
            [self initKmlWithString:@"http://data.wien.gv.at/daten/geo?version=1.3.0&service=WMS&request=GetMap&crs=EPSG:4326&bbox=48.10,16.16,48.34,16.59&width=1&height=1&layers=ogdwien:OEFFHALTESTOGD&styles=&format=application/vnd.google-earth.kml+xml"];
            
            self.annotationIcon = [[NSURL alloc] initWithString:@"http://data.wien.gv.at/katalog/images/haltestellewlogd.png"];
            self.title = NSLocalizedString(@"Haltestellen", nil);
            [self parseDescriptions:@"Öffis"];
            [self parseSubTitleDescriptions:@"ÖffisLinien"];
            break;
            
        case 52:
            [self initKmlWithString:@"http://data.wien.gv.at/daten/geo?version=1.3.0&service=WMS&request=GetMap&crs=EPSG:4326&bbox=48.10,16.16,48.34,16.59&width=1&height=1&layers=ogdwien:TAXIOGD&styles=&format=application/vnd.google-earth.kml+xml"];
            self.annotationIcon = [[NSURL alloc] initWithString:@"http://data.wien.gv.at/katalog/images/taxiogd.png"];
            self.title = NSLocalizedString(@"Taxistandplätze", nil);
            break;
            
            
        case 60:
            [self initKmlWithString:@"http://www.cusoon.at/wien-adventmaerkte.kml"];
            [self descriptionReplacement:@"/photos/" toString:@"http://www.cusoon.at/photos/"];
            self.title = NSLocalizedString(@"Adventmärkte", nil);
            self.annotationIcon = [[NSURL alloc] initWithString:@"http://www.cusoon.at/static/1204095466/images/icons/themen64/adventmaerkte.png"];
            break;
            
            
        case 61:
            [self initKmlWithString:@"http://www.bachmaier.cc/wienguide/GayWienMap.kml"];
            self.title = NSLocalizedString(@"Gay", nil);
            self.annotationIcon = [[NSURL alloc] initWithString:@"http://www.bachmaier.cc/images/gay.png"];
            break;

        default:
            break;
    }
    
    NSData *data = [NSData dataWithContentsOfURL:self.annotationIcon];
    self.annotationImage = [[UIImage alloc] initWithData:data];
}

- (void) initKmlWithIndex:(long)kmlIndex
{
    self.selectedKmlIndex = kmlIndex;
    [self initKml];
}

- (void) initKmlWithString:(NSString *)kmlstring
{
    NSURL *url = [NSURL URLWithString:kmlstring];
    _kml = [KMLParser parseKMLAtURL:url];
    self.annotations = [[NSMutableArray alloc] initWithCapacity:_kml.placemarks.count];
    for (KMLPlacemark *placemark in _kml.placemarks)
    {
        TBAnnotation *annotation = [[TBAnnotation alloc] initWithTitle:placemark.point.title andCoordinate:placemark.point.coordinate andSubtitle:placemark.placemarkDescription];
        [self.annotations addObject:annotation];
    }
}

- (void) descriptionReplacement:(NSString *)fromString toString:(NSString *)toString
{
    for (TBAnnotation *annotation in self.annotations)
    {
        annotation.description = [annotation.description stringByReplacingOccurrencesOfString:fromString withString:toString];
    }
}

- (void) parseDescriptions:(NSString *)type
{
    for (TBAnnotation *annotation in self.annotations)
    {
        annotation.title = [TBKMLDescriptionParser GetName:annotation.description ofAnnotationType:type];
    }
}

- (void) parseSubTitleDescriptions:(NSString *)type
{
    for (TBAnnotation *annotation in self.annotations)
    {
        annotation.subtitle = [TBKMLDescriptionParser GetName:annotation.description ofAnnotationType:type];
    }
}


@end

