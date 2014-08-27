//
//  SWARMSourceSegmentVector.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.01.07..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import "SWARMSourceSegmentVector.h"

@implementation SWARMSourceSegmentVector
@synthesize ssvDictionary;


/**
 * Adds a tag to a given category. When the category is not present yet, it will be created.
 * Returns the array of tags of the given category.
 * If any of the parameters is nil, the function returns with nil, and does not alter the collection.
 **/
-(NSMutableArray *)addTagToCategory:(NSString *)tag forCategory:(NSString *)categoryName
{
    if (tag== nil || categoryName== nil) {
        return nil;
    }
    
    if (self.ssvDictionary==nil) {
        [self setSsvDictionary:[[NSMutableDictionary alloc]init]];
    }
    
    NSMutableArray *group;
    NSObject *tmpo=[[self ssvDictionary] objectForKey:categoryName];
    if (tmpo==nil) {
        //key does not exist yet, create category with the given tag inside
        NSMutableArray *tmpGroup = [[NSMutableArray alloc] initWithArray:@[tag]];
        [[self ssvDictionary] setObject:tmpGroup forKey:categoryName];
        group = tmpGroup;
    }
    else
    {
        //category exists, add tag to it
        group = [[self ssvDictionary ] objectForKey:categoryName];
        //only add, when not present yet. TODO: will this work?
        if (![group containsObject:tag]) {
            [group addObject:tag];
        }
    }
    
    return group;
}


/**
 * Get the tags in a category. If the category is not present, returns nil.
 **/
-(NSMutableArray *)getTagsInCategory:(NSString *)categoryName
{
    /*if ([self valueForKey:categoryName]==nil) {
        NSMutableArray *tags = [[NSMutableArray alloc]init];
        return tags;
    }
    else
    {
        
    }*/
    return [self.ssvDictionary valueForKey:categoryName];
}

-(id)init{
    self = [super init];
    if (self) {
        [self setSsvDictionary: [[NSMutableDictionary alloc]init]];
    }
    return self;
}

/**
 * Creates a new instance from the json provided by the backend. If it's nil, returns with nil.
 **/
+(SWARMSourceSegmentVector*)fromDictionary:(NSDictionary*)dictionary
{
    if (dictionary == nil) {
        return nil;
    }
    SWARMSourceSegmentVector *ssv = [[SWARMSourceSegmentVector alloc]init];
    [ssv setSsvDictionary:[[NSMutableDictionary alloc]initWithDictionary: dictionary]];
    return ssv;
}

-(NSArray *)getCategoryNames
{
    return [[self ssvDictionary]allKeys];
}

/**
 * Copies source segment vector into a new instance. If categories is nil, copies all data, if you give an
 * array of strings, only those categories are copied.
 **/
+(SWARMSourceSegmentVector*)copyVector:(SWARMSourceSegmentVector*)ssv onlyCategories:(NSArray*)categories
{
    SWARMSourceSegmentVector *newSSV = [[SWARMSourceSegmentVector alloc]init];
    for (NSString *catName in [ssv getCategoryNames]) {
        BOOL copyCategory = NO;
        if (categories==nil) {
            continue;
        }
        else
        {
            if ([categories containsObject:catName]) {
                copyCategory = YES;
            }
        }
        
        if (!copyCategory) {
            continue;
        }
        
        for (NSString *tag in [ssv getTagsInCategory:catName]) {
            [newSSV addTagToCategory:tag forCategory:catName];
        }
    }
    
    return newSSV;
}
@end
