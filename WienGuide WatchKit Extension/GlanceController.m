//
//  GlanceController.m
//  Trinkbrunnen
//
//  Created by Andreas Bachmaier on 21.11.14.
//
//

#import "GlanceController.h"

@interface GlanceController()

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *glanceLabel;


@end

@implementation GlanceController

- (instancetype)initWithContext:(id)context {
    self = [super init];

    if (self) {
        // Initialize variables here.
        // Configure interface objects here.
        NSLog(@"%@ initWithContext", self);
    }
    
    return self;
}

- (void)willActivate {
    // This method is called when the controller is about to be visible to the wearer.
    NSLog(@"%@ will activate", self);
    
    self.glanceLabel.text = @"Glance is working now.";
    
    // Use Handoff to route the wearer to the image detail controller when the Glance is tapped
    [self updateUserActivity:@"com.example.apple-samplecode.WatchKit-Catalog"
                    userInfo:@{
                               @"controllerName": @"imageDetailController",
                               @"detailInfo": @"This is some more detailed information to pass."
                               }
                  webpageURL:[NSURL URLWithString:@"http://wienguide.bachmaier.cc"]];
}

- (void)didDeactivate {
    // This method is called when the controller is no longer visible.
    NSLog(@"%@ did deactivate", self);
}

@end
