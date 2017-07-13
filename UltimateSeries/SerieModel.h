//
//  SerieModel.h
//  UltimateSeries
//
//  Created by Fernando Vega Giganto on 5/7/17.
//  Copyright © 2017 Fernando Vega Giganto. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

#define NO_INFO_NUM -1

@interface SerieModel : NSObject

@property (copy, nonatomic) NSString *title;
@property (nonatomic) int idSerie;
@property (copy, nonatomic) NSArray *genres;
@property (copy, nonatomic) NSString *infoDesc;
@property (assign, nonatomic) int seasons;
@property (assign, nonatomic) int episodes;
@property (strong, nonatomic, readonly) UIImage *backdrop;
@property (strong, nonatomic) NSURL *backdropURL;
@property (strong, nonatomic, readonly) UIImage *cover;
@property (strong, nonatomic) NSURL *coverURL;
@property (strong, nonatomic) NSURL *infoWeb;
@property (nonatomic) BOOL inProduction;
@property (nonatomic) int votesAverage;
@property (nonatomic) int votesCount;


// Métodos de clase:

// constructores de conveniencia

+(id) serieWithTitle: (NSString *) aTitle
             serieID: (int) aIdSerie
          serieGenre: (NSArray *) aGenre
           serieInfo: (NSString *) aInfoDesc
        serieSeasons: (int) aSeasons
       serieEpisodes: (int) aEpisodes
    serieBackDropURL: (NSURL *) aBackdropURL
       serieCoverURL: (NSURL *) serieCoverURL
        serieInfoWeb: (NSURL *) ainfoWeb
   serieInProduction: (BOOL) aInProduction
   serieVotesAverage: (int) aVotesAverage
     serieVotesCount: (int) aVotesCount;

+(id) serieWithTitle: (NSString *) aTitle
             serieID: (int) aIdSerie
       serieCoverURL: (NSURL *) serieCoverURL;


// Métodos de instancia

// inicializador designado
-(id) initWithTitle: (NSString *) aTitle
            serieID: (int) aIdSerie
         serieGenre: (NSArray *) aGenre
          serieInfo: (NSString *) aInfoDesc
       serieSeasons: (int) aSeasons
      serieEpisodes: (int) aEpisodes
   serieBackDropURL: (NSURL *) aBackdropURL
      serieCoverURL: (NSURL *) serieCoverURL
       serieInfoWeb: (NSURL *) ainfoWeb
  serieInProduction: (BOOL) aInProduction
  serieVotesAverage: (int) aVotesAverage
    serieVotesCount: (int) aVotesCount;

// inicializador de conveniencia
-(id) initWithTitle: (NSString *) aTitle
            serieID: (int) aIdSerie
      serieCoverURL: (NSURL *) serieCoverURL;


// inicializador a partir del diccionario JSON
-(id) initMasterWithDictionary:(NSDictionary *)aDict;

-(void) updateModelWithDictionary:(NSDictionary *)aDict;

@end
