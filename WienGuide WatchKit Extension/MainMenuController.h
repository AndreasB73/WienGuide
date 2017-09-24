//
//  MainMenuController.h
//  Trinkbrunnen
//
//  Created by Andreas Bachmaier on 20.11.14.
//
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface MainMenuController : WKInterfaceController

@property (weak, nonatomic) IBOutlet WKInterfaceTable *menuTable;
@property (strong, nonatomic) NSDictionary *menuData;
@property (strong, nonatomic) NSString *menuName;
@property (strong, nonatomic) NSString *pushControllerName;

- (void)loadMenuTable;


@end
