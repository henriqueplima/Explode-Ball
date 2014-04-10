//
//  GerenciaRanking.h
//  Explode Ball
//
//  Created by MARCOS VINICIUS SOUZA LACERDA on 28/03/14.
//  Copyright (c) 2014 HENRIQUE PEREIRA DE LIMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GerenciaRanking : UITableViewController

@property NSInteger *pontos;
@property NSMutableArray *nomes;
@property NSMutableArray *ponto;
@property NSArray *path;
@property NSDictionary *dictionary;
@property NSString *documentsPath;
@property NSString *filePath;
@property NSMutableArray *auxPontos;
@property NSMutableArray *auxNomes;
@property UIButton *btnVoltar;

// método de classe
+ (GerenciaRanking *)compartilharGerenciador;
+ (id)allocWithZone:(struct _NSZone *)zone;


- (void)writeToPlist:(NSString *)nome : (NSString *)pontuacao;
- (void)refresh;
@end
