//
//  Serie+CoreDataProperties.m
//  UltimateSeries
//
//  Created by Fernando Vega Giganto on 21/7/17.
//  Copyright © 2017 Fernando Vega Giganto. All rights reserved.
//

#import "Serie+CoreDataProperties.h"

@implementation Serie (CoreDataProperties)

+ (NSFetchRequest<Serie *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Serie"];
}

@dynamic title;
@dynamic idSerie;
@dynamic genres;
@dynamic infoDesc;
@dynamic seasons;
@dynamic episodes;
@dynamic backdropURL;
@dynamic coverURL;
@dynamic infoWeb;
@dynamic inProduction;
@dynamic votesAverage;
@dynamic votesCount;

@end
