//
//  SerieModel.m
//  UltimateSeries
//
//  Created by Fernando Vega Giganto on 5/7/17.
//  Copyright © 2017 Fernando Vega Giganto. All rights reserved.
//

#import "SerieModel.h"

@implementation SerieModel


// Para crear el método geter personalizado a una propiedad "readonly" necesitamos la variable de instancia:
@synthesize cover = _cover;

#pragma mark - properties
-(UIImage *)cover{
    
    // enviar al segundo plano para evitar bloquar la aplicacion
    
    if(_cover == nil){
        _cover = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.coverURL]];
    }
    return _cover;
}

#pragma mark - Class methods

+(id) serieWithTitle: (NSString *) aTitle
             serieID: (int) aIdSerie
          serieGenre: (NSArray *) aGenre
           serieInfo: (NSString *) aInfoDesc
        serieSeasons: (int) aSeasons
       serieEpisodes: (int) aEpisodes
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
         serieGenre: (NSArray *) aGenre
          serieInfo: (NSString *) aInfoDesc
       serieSeasons: (int) aSeasons
      serieEpisodes: (int) aEpisodes
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
        _coverURL = serieCoverURL;
        _infoWeb = aInfoWeb;
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
    
    // NSLog(@"%@", imageFinalUrl);
    
    return [self initWithTitle:[aDict objectForKey:@"name"]
                       serieID:[[aDict objectForKey:@"id"] intValue]
                 serieCoverURL:[NSURL URLWithString:imageFinalUrl]];
}


//-(id)updateDetailWithDictionary:(NSDictionary *)aDict{
-(void) updateModelWithDictionary:(NSDictionary *)aDict {

    self.genres = [self extractGenresFromJSONArray:[aDict objectForKey:@"genres"]];
    self.infoDesc = [aDict objectForKey:@"overview"];
    self.seasons = [[aDict objectForKey:@"number_of_seasons"] intValue];
    self.episodes = [[aDict objectForKey:@"number_of_episodes"] intValue];
    self.infoWeb = [NSURL URLWithString:[aDict objectForKey:@"homepage"]];
    self.inProduction = [[aDict valueForKey:@"in_production"] boolValue];
    self.votesAverage = [[aDict objectForKey:@"vote_average"] intValue];
    self.votesCount = [[aDict objectForKey:@"vote_count"] intValue];
}

//-(NSDictionary *) proxyForJSON{
//    
//    return @{@"title"           : self.title,
//             @"genres"           : self.genres,
//             @"infoDesc"        : self.infoDesc,
//             @"seasons"         : @(self.seasons),
//             @"cover"           : [self.coverURL path],
//             @"infoWeb"         : self.infoWeb };
//    
//}


#pragma mark - Utils

-(NSArray *) extractGenresFromJSONArray:(NSArray *)genresJSONArray{
    
    NSMutableArray *genres = [NSMutableArray arrayWithCapacity:[genresJSONArray count]];
    
    for (NSDictionary *dict in genresJSONArray){
        [genres addObject:[dict objectForKey:@"name"]];
    }
    return genres;
}

@end
