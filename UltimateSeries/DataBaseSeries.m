//
//  DataBaseSeries.m
//  UltimateSeries
//
//  Created by Fernando Vega Giganto on 21/7/17.
//  Copyright © 2017 Fernando Vega Giganto. All rights reserved.
//

#import "DataBaseSeries.h"
#import "Serie+CoreDataClass.h"


@interface DataBaseSeries ()

@property (nonatomic, strong) NSPersistentContainer *pc;

-(void)load;

@end

@implementation DataBaseSeries

+(DataBaseSeries *)defaultDataBase {
    
    static DataBaseSeries* instance = nil;
    if (instance == nil) {
        instance = [[DataBaseSeries alloc] init];
        [instance load];
    }
    return instance;
}

// sobreescribimos el método getter de Serie (así cada vez que se pide se recargan los datos)
-(NSArray *)seriesFavoritas{
    NSFetchRequest *fetch = [Serie fetchRequest];
    
    NSError *error;
    return [self.moc executeFetchRequest:fetch error:&error];
}

-(void)load {
    self.pc = [[NSPersistentContainer alloc] initWithName:@"SerieFavModel"];
    [self.pc loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription * _Nonnull desc, NSError * _Nullable error) {
        // Inicializamos el moc (propiedad pública para gestionar desde fuera la BBDD)
        self.moc = self.pc.viewContext;
    }];
}

-(void)save{
    NSError *error;
    [self.moc save:&error];
}

@end
