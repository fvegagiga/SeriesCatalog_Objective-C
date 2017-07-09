//
//  SerieModel.m
//  UltimateSeries
//
//  Created by Fernando Vega Giganto on 5/7/17.
//  Copyright © 2017 Fernando Vega Giganto. All rights reserved.
//

#import "SerieModel.h"

@implementation SerieModel

#pragma mark - Class methods

+(id) serieWithTitle: (NSString *) aTitle
          serieGenre: (NSArray *) aGenre
           serieInfo: (NSString *) aInfoDesc
        serieSeasons: (int) aSeasons
          serieCover: (UIImage *) serieCover
        serieInfoWeb: (NSURL *) ainfoWeb {
    
    return [[self alloc] initWithTitle:aTitle
                            serieGenre:aGenre
                             serieInfo:aInfoDesc
                          serieSeasons:aSeasons
                            serieCover:serieCover
                          serieInfoWeb:ainfoWeb];
}

+(id) serieWithTitle: (NSString *) aTitle
           serieInfo: (NSString *) aInfoDesc {
    
    return [[self alloc] initWithTitle:aTitle
                            serieGenre:nil
                             serieInfo:aInfoDesc
                          serieSeasons:NO_INFO_NUM_SEASONS
                            serieCover:nil
                          serieInfoWeb:nil];
}




#pragma mark - Init

// inicializador designado
-(id) initWithTitle: (NSString *) aTitle
         serieGenre: (NSArray *) aGenre
          serieInfo: (NSString *) aInfoDesc
       serieSeasons: (int) aSeasons
         serieCover: (UIImage *) serieCover
       serieInfoWeb: (NSURL *) aInfoWeb {
    
    if (self = [super init]){
        _title = aTitle;
        _genres = aGenre;
        _infoDesc = aInfoDesc;
        _seasons = aSeasons;
        _cover = serieCover;
        _infoWeb = aInfoWeb;
    }
   
    return self;
}


// inicializador de conveniencia
-(id) initWithTitle: (NSString *) aTitle
          serieInfo: (NSString *) aInfoDesc {
    
    return [self initWithTitle:aTitle
                    serieGenre:nil
                     serieInfo:aInfoDesc
                  serieSeasons:NO_INFO_NUM_SEASONS
                    serieCover:nil
                  serieInfoWeb:nil];
}

@end
