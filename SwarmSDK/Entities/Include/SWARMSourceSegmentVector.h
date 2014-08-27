//
//  SWARMBLESSourceSegmentVector.SourceSegmentVector.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.01.07..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWARMSourceSegmentVector : NSObject
-(NSMutableArray *)addTagToCategory:(NSString *)tag forCategory:(NSString *)categoryName;
-(NSMutableArray *)getTagsInCategory:(NSString *)categoryName;
-(NSArray *)getCategoryNames;
@property (strong,nonatomic) NSMutableDictionary *ssvDictionary;
+(SWARMSourceSegmentVector*)fromDictionary:(NSDictionary*)dictionary;
+(SWARMSourceSegmentVector*)copyVector:(SWARMSourceSegmentVector*)ssv onlyCategories:(NSArray*)categories;
@end
