//
//  TBKMLDescriptionParser.m
//  Trinkbrunnen
//
//  Created by Andreas Bachmaier on 22.11.13.
//
//

#import "TBKMLDescriptionParser.h"
#import "HTMLParser.h"

@implementation TBKMLDescriptionParser

+ (NSString *)GetName:(NSString *)description ofAnnotationType:(NSString *)type
{
    NSString *input = [description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    input = [input stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //NSLog(@"%@", input);
    NSString *result = nil;
    
    if ([type isEqualToString:@"UBahn"])
         result = [self parseUBahn:input];
    else if ([type isEqualToString:@"Öffis"])
        result = [self parseOeffis:input];
    else if ([type isEqualToString:@"ÖffisLinien"])
        result = [self parseOeffisLinien:input];
    else if ([type isEqualToString:@"Trinkbrunnen"])
        result = [self parseTrinkbrunnen:input];
    else if ([type isEqualToString:@"Badestellen"])
        result = [self parseBadestellen:input];
    else if ([type isEqualToString:@"Schwimmbäder"])
        result = [self parseBadestellen:input];
    else if ([type isEqualToString:@"WC"])
        result = [self parseWC:input];
    else if ([type isEqualToString:@"Defibrillator"])
        result = [self parseDefi:input];
    else if ([type isEqualToString:@"Multimedia"])
        result = [self parseDefi:input];
    else if ([type isEqualToString:@"Sportstätten"])
        result = [self parseDefi:input];
    else if ([type isEqualToString:@"Citybikes"])
        result = [self parseCitybikes:input];
    else if ([type isEqualToString:@"Spielplätze"])
        result = [self parseSpielplatz:input];
    else if ([type isEqualToString:@"Schloss"])
        result = [self parseBadestellen:input];
    else if ([type isEqualToString:@"Museum"])
        result = [self parseBadestellen:input];
    return result;
}

+ (NSString *) parseUBahn:(NSString *)text
{
    NSString *result = nil;
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:text error:&error];
    NSString *atrName = nil;
    
    if (error)
    {
        NSLog(@"Error: %@", error);
        return nil;
    }
    
    HTMLNode *bodyNode = [parser body];
    NSArray *spanNodes = [bodyNode findChildTags:@"span"];
    
    for (HTMLNode *spanNode in spanNodes)
    {
        if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"atr-name"])
        {
            atrName = [spanNode.children.lastObject rawContents];
        }
        if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"atr-value"] && [atrName isEqualToString:@"LINFO"])
        {
            result = [NSString stringWithFormat:@"U%@",[spanNode.children.lastObject rawContents]];
        }
        if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"atr-value"] && [atrName isEqualToString:@"HTXT"])
        {
            result = [result stringByAppendingString:[NSString stringWithFormat:@" - %@",[spanNode.children.lastObject rawContents]]];
        }
    }
    
    return result;
}

+ (NSString *) parseOeffis:(NSString *)text
{
    NSString *result = nil;
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:text error:&error];
    NSString *atrName = nil;
    
    if (error)
    {
        NSLog(@"Error: %@", error);
        return nil;
    }
    
    HTMLNode *bodyNode = [parser body];
    NSArray *spanNodes = [bodyNode findChildTags:@"span"];
    
    for (HTMLNode *spanNode in spanNodes)
    {
        if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"atr-name"])
        {
            atrName = [spanNode.children.lastObject rawContents];
        }
        if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"atr-value"] && [atrName isEqualToString:@"HTXT"])
        {
            result = [spanNode.children.lastObject rawContents];
        }
        
    }
    return result;
}

+ (NSString *) parseOeffisLinien:(NSString *)text
{
    NSString *result = nil;
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:text error:&error];
    NSString *atrName = nil;
    
    if (error)
    {
        NSLog(@"Error: %@", error);
        return nil;
    }
    
    HTMLNode *bodyNode = [parser body];
    NSArray *spanNodes = [bodyNode findChildTags:@"span"];
    
    for (HTMLNode *spanNode in spanNodes)
    {
        if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"atr-name"])
        {
            atrName = [spanNode.children.lastObject rawContents];
        }
        if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"atr-value"] && [atrName isEqualToString:@"HLINIEN"])
        {
            result = [spanNode.children.lastObject rawContents];
        }
        
    }
    return result;
}

+ (NSString *) parseTrinkbrunnen:(NSString *)text
{
    return [TBKMLDescriptionParser parseAtr:text withTerm:@"NAME"];
}


+ (NSString *) parseBadestellen:(NSString *)text
{
    return [TBKMLDescriptionParser parseDt:text withTerm:@"Name"];
}

+ (NSString *) parseWC:(NSString *)text
{
    NSString *result = [NSString stringWithFormat:@"WC %@",[TBKMLDescriptionParser parseAtr:text withTerm:@"STRASSE"]];
    return result;
}

+ (NSString *) parseDefi:(NSString *)text
{
    return [TBKMLDescriptionParser parseAtr:text withTerm:@"ADRESSE"];
}

+ (NSString *) parseCitybikes:(NSString *)text
{
    return [TBKMLDescriptionParser parseDt:text withTerm:@"Station"];
}

+ (NSString *) parseSpielplatz:(NSString *)text
{
    return [TBKMLDescriptionParser parseDt:text withTerm:@"Standort"];
}

+(NSString *) parseDt:(NSString *)text withTerm:(NSString *)searchTerm
{
    NSString *result = nil;
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:text error:&error];
    
    if (error)
    {
        NSLog(@"Error: %@", error);
        return nil;
    }
    
    HTMLNode *bodyNode = [parser body];
    NSArray *spanNodesDt = [bodyNode findChildTags:@"dt"];
    NSArray *spanNodesDd = [bodyNode findChildTags:@"dd"];
    
    int i = 0;
    for (HTMLNode *spanNode in spanNodesDt)
    {
        if ([[spanNode.children.lastObject rawContents] isEqualToString:searchTerm])
        {
            result = [[[spanNodesDd[i] children] lastObject] rawContents];
            break;
        }
        ++i;
    }
    
    return result;
}

+(NSString *)parseAtr:(NSString *)text withTerm:(NSString *)searchTerm
{
    NSString *result = nil;
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:text error:&error];
    NSString *atrName = nil;
    
    if (error)
    {
        NSLog(@"Error: %@", error);
        return nil;
    }
    
    HTMLNode *bodyNode = [parser body];
    NSArray *spanNodes = [bodyNode findChildTags:@"span"];
    
    for (HTMLNode *spanNode in spanNodes)
    {
        if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"atr-name"])
        {
            atrName = [spanNode.children.lastObject rawContents];
        }
        if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"atr-value"] && [atrName isEqualToString:searchTerm])
        {
            result = [spanNode.children.lastObject rawContents];
        }
    }
    
    return result;
}

@end
