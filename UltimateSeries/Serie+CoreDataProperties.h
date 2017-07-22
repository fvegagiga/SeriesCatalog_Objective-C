//
//  Serie+CoreDataProperties.h
//  UltimateSeries
//
//  Created by Fernando Vega Giganto on 21/7/17.
//  Copyright © 2017 Fernando Vega Giganto. All rights reserved.
//

#import "Serie+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Serie (CoreDataProperties)

+ (NSFetchRequest<Serie *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *title;
@property (nonatomic) int32_t idSerie;
@property (nullable, nonatomic, copy) NSString *genres;
@property (nullable, nonatomic, copy) NSString *infoDesc;
@property (nonatomic) int32_t seasons;
@property (nonatomic) int32_t episodes;
@property (nullable, nonatomic, copy) NSString *backdropURL;
@property (nullable, nonatomic, copy) NSString *coverURL;
@property (nullable, nonatomic, copy) NSString *infoWeb;
@property (nonatomic) BOOL inProduction;
@property (nonatomic) int32_t votesAverage;
@property (nonatomic) int32_t votesCount;

@end

NS_ASSUME_NONNULL_END
