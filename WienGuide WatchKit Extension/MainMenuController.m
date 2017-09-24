//
//  MainMenuController.m
//  Trinkbrunnen
//
//  Created by Andreas Bachmaier on 20.11.14.
//
//

#import "MainMenuController.h"
#import "MenuController.h"

@interface MainMenuController()


@end

@implementation MainMenuController



- (instancetype)initWithContext:(id)context
{
    self = [super init];
    if (self)
    {
        // Initialize variables here.
        // Configure interface objects here.
        [self initMenuTables];
        [self initMenu:context];
        [self loadMenuTable];

    }
    return self;
}

- (void)initMenu:(id)context
{
    NSString *myContext = context;
    if (context == nil)
    {
        self.pushControllerName = @"MainMenu";
        self.menuName = self.pushControllerName;
    }
    else
    {
        self.menuName = myContext;
        self.pushControllerName = @"mapController";
    }
}

-(void)initMenuTables
{
    NSMutableDictionary *menu = [[NSMutableDictionary alloc] init];
    menu[@"MainMenu"] = @[@"Gesundheit",@"Internet", @"Spiel & Sport"];
    menu[@"Gesundheit"] = @[@"Trinkbrunnen",@"Badestellen", @"Schwimmbäder"];
    menu[@"Internet"] = @[@"Freewave",@"Multimedia"];
    menu[@"Spiel & Sport"] = @[@" Spielplätze",@" Sportstätten", @"Citybikes"];
    
    self.menuData = menu;
}

- (void)loadMenuTable
{
    NSArray *menu = self.menuData[self.menuName];
    [self.menuTable setNumberOfRows:menu.count withRowType:@"default"];
    
    [menu enumerateObjectsUsingBlock:^(NSString *menuName, NSUInteger idx, BOOL *stop)
    {
        MenuController *row = [self.menuTable rowControllerAtIndex:idx];
        row.menuLabel.text = menuName;
    }];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    //NSLog(@"%@ will activate", self);
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    //NSLog(@"%@ did deactivate", self);
}


- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex {
    NSArray *menu = self.menuData[self.menuName];
    NSString *selectedMenuItem = menu[rowIndex];
    [self pushControllerWithName:self.pushControllerName context:selectedMenuItem];
}

@end
