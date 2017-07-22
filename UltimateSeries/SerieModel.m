//
//  SerieModel.m
//  UltimateSeries
//
//  Created by Fernando Vega Giganto on 5/7/17.
//  Copyright © 2017 Fernando Vega Giganto. All rights reserved.
//

#import "SerieModel.h"

@interface SerieModel ()

@property (nonatomic, strong) NSURLSessionDataTask *imageDataTask;

@end

@implementation SerieModel


// Para crear el método geter personalizado a una propiedad "readonly" necesitamos la variable de instancia:
@synthesize cover = _cover;
@synthesize backdrop = _backdrop;

#pragma mark - properties
-(UIImage *)cover{
    
    // enviar al segundo plano para evitar bloquar la aplicacion
    
    if(_cover == nil){
        _cover = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.coverURL]];
    }
    return _cover;
}

-(UIImage *)backdrop{
    
    // enviar al segundo plano para evitar bloquar la aplicacion
    
    if(_backdrop == nil){
        _backdrop = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.backdropURL]];
    }
    return _backdrop;
}

#pragma mark - Class methods

+(id) serieWithTitle: (NSString *) aTitle
             serieID: (int) aIdSerie
          serieGenre: (NSString *) aGenre
           serieInfo: (NSString *) aInfoDesc
        serieSeasons: (int) aSeasons
       serieEpisodes: (int) aEpisodes
    serieBackDropURL: (NSURL *) aBackdropURL
       serieCoverURL: (NSURL *) serieCoverURL
        serieInfoWeb: (NSURL *) ainfoWeb
   serieInProduction: (BOOL) aInProduction
   serieVotesAverage: (int) aVotesAverage
     serieVotesCount: (int) aVotesCount
{
    
    return [[self alloc] initWithTitle:aTitle
                               serieID:aIdSerie
                            serieGenre:aGenre
                             serieInfo:aInfoDesc
                          serieSeasons:aSeasons
                         serieEpisodes:aEpisodes
                      serieBackDropURL:aBackdropURL
                         serieCoverURL:serieCoverURL
                          serieInfoWeb:ainfoWeb
                     serieInProduction:aInProduction
                     serieVotesAverage:aVotesAverage
                       serieVotesCount:aVotesCount];
}

+(id) serieWithTitle: (NSString *) aTitle
             serieID: (int) aIdSerie
       serieCoverURL: (NSURL *) serieCoverURL {
    
    return [[self alloc] initWithTitle: aTitle
                               serieID:aIdSerie
                            serieGenre:nil
                             serieInfo:nil
                          serieSeasons:NO_INFO_NUM
                         serieEpisodes:NO_INFO_NUM
                      serieBackDropURL:nil
                         serieCoverURL:nil
                          serieInfoWeb:nil
                     serieInProduction:false
                     serieVotesAverage:NO_INFO_NUM
                       serieVotesCount:NO_INFO_NUM];
}


#pragma mark - Init

// inicializador designado
-(id) initWithTitle: (NSString *) aTitle
            serieID: (int) aIdSerie
         serieGenre: (NSString *) aGenre
          serieInfo: (NSString *) aInfoDesc
       serieSeasons: (int) aSeasons
      serieEpisodes: (int) aEpisodes
   serieBackDropURL: (NSURL *) aBackdropURL
      serieCoverURL: (NSURL *) serieCoverURL
       serieInfoWeb: (NSURL *) aInfoWeb
  serieInProduction: (BOOL) aInProduction
  serieVotesAverage: (int) aVotesAverage
    serieVotesCount: (int) aVotesCount {
    
    if (self = [super init]){
        _title = aTitle;
        _idSerie = aIdSerie;
        _genres = aGenre;
        _infoDesc = aInfoDesc;
        _seasons = aSeasons;
        _episodes = aEpisodes;
        _backdropURL = aBackdropURL;
        _coverURL = serieCoverURL;
        _infoWeb = aInfoWeb;
        _inProduction = aInProduction;
        _votesAverage = aVotesAverage;
        _votesCount = aVotesCount;
    }
   
    return self;
}


// inicializador de conveniencia
-(id) initWithTitle: (NSString *) aTitle
            serieID: (int) aIdSerie
      serieCoverURL: (NSURL *) serieCoverURL {
    
    return [self initWithTitle: aTitle
                       serieID:aIdSerie
                    serieGenre:nil
                     serieInfo:nil
                  serieSeasons:NO_INFO_NUM
                 serieEpisodes:NO_INFO_NUM
              serieBackDropURL:nil
                 serieCoverURL:serieCoverURL
                  serieInfoWeb:nil
             serieInProduction:false
             serieVotesAverage:NO_INFO_NUM
               serieVotesCount:NO_INFO_NUM];
}

#pragma mark - JSON
-(id)initMasterWithDictionary:(NSDictionary *)aDict{
    
    NSString *imageBaseUrl = @"https://image.tmdb.org/t/p/w185";
    NSString *imageFinalUrl = [imageBaseUrl stringByAppendingString:[aDict objectForKey:@"poster_path"]];
    
    return [self initWithTitle:[aDict objectForKey:@"name"]
                       serieID:[[aDict objectForKey:@"id"] intValue]
                 serieCoverURL:[NSURL URLWithString:imageFinalUrl]];
}


-(void) updateModelWithDictionary:(NSDictionary *)aDict {

    self.genres = [self arrayToString:[self extractGenresFromJSONArray:[aDict objectForKey:@"genres"]]];
    self.infoDesc = [aDict objectForKey:@"overview"];
    self.seasons = [[aDict objectForKey:@"number_of_seasons"] intValue];
    self.episodes = ([aDict objectForKey:@"number_of_episodes"] != (id)[NSNull null]) ?
        [[aDict objectForKey:@"number_of_episodes"] intValue] : 0;
    
    NSLog(@"id: %d", self.idSerie);
    
    if ([aDict objectForKey:@"backdrop_path"] != (id)[NSNull null]) {
        NSString *backdropURLBaseUrl = @"https://image.tmdb.org/t/p/w780";
        NSString *backdropURLFinalUrl = [backdropURLBaseUrl stringByAppendingString:[aDict objectForKey:@"backdrop_path"]];
        self.backdropURL = [NSURL URLWithString:backdropURLFinalUrl];
    } else {
        self.backdropURL = nil;
    }
    
    if ([aDict objectForKey:@"homepage"] != (id)[NSNull null]){
        self.infoWeb = [NSURL URLWithString:[aDict objectForKey:@"homepage"]];
    } else {
        self.infoWeb = nil;
    }

    self.inProduction = [[aDict valueForKey:@"in_production"] boolValue];
    self.votesAverage = [[aDict objectForKey:@"vote_average"] intValue];
    self.votesCount = [[aDict objectForKey:@"vote_count"] intValue];
}

#pragma mark - Utils

-(NSArray *) extractGenresFromJSONArray:(NSArray *)genresJSONArray{
    
    NSMutableArray *genres = [NSMutableArray arrayWithCapacity:[genresJSONArray count]];
    
    for (NSDictionary *dict in genresJSONArray){
        [genres addObject:[dict objectForKey:@"name"]];
    }
    return genres;
}


-(NSString *) arrayToString:(NSArray *) arrayGenres{
    
    NSString *result = nil;
    
    if ([arrayGenres count] == 1) {
        result = [[arrayGenres lastObject] stringByAppendingString:@"."];
    } else if ([arrayGenres count] > 1){
        result = [[arrayGenres componentsJoinedByString:@", "] stringByAppendingString:@"."];
    } else {
        result = @"no defined.";
    }
    
    return result;
}

@end
