//
//  TBKMLDescriptionParser.h
//  Trinkbrunnen
//
//  Created by Andreas Bachmaier on 22.11.13.
//
//

#import <Foundation/Foundation.h>

@interface TBKMLDescriptionParser : NSObject

+ (NSString *)GetName:(NSString *)description ofAnnotationType:(NSString *)type;

@end
