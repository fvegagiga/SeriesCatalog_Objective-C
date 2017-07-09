//
//  SerieModel.h
//  UltimateSeries
//
//  Created by Fernando Vega Giganto on 5/7/17.
//  Copyright © 2017 Fernando Vega Giganto. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

#define NO_INFO_NUM_SEASONS -1

@interface SerieModel : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSArray *genres;
@property (copy, nonatomic) NSString *infoDesc;
@property (assign, nonatomic) int seasons;
@property (strong, nonatomic) UIImage *cover;
@property (strong, nonatomic) NSURL *infoWeb;

// Métodos de clase:

// constructores de conveniencia

+(id) serieWithTitle: (NSString *) aTitle
          serieGenre: (NSArray *) aGenre
           serieInfo: (NSString *) aInfoDesc
        serieSeasons: (int) aSeasons
          serieCover: (UIImage *) serieCover
        serieInfoWeb: (NSURL *) ainfoWeb;

+(id) serieWithTitle: (NSString *) aTitle
          serieInfo: (NSString *) aInfoDesc;

// Métodos de instancia

// inicializador designado
-(id) initWithTitle: (NSString *) aTitle
         serieGenre: (NSArray *) aGenre
          serieInfo: (NSString *) aInfoDesc
       serieSeasons: (int) aSeasons
         serieCover: (UIImage *) serieCover
       serieInfoWeb: (NSURL *) ainfoWeb;

// inicializador de conveniencia
-(id) initWithTitle: (NSString *) aTitle
          serieInfo: (NSString *) aInfoDesc;



@end
