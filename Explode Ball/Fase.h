//
//  Fase.h
//  Explode Ball
//
//  Created by HENRIQUE PEREIRA DE LIMA on 31/03/14.
//  Copyright (c) 2014 HENRIQUE PEREIRA DE LIMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "Bloco.h"

@interface Fase : NSObject


@property NSMutableArray *blocos;
@property int nBlocosQuebraveis;
@property CGSize tamanhoBloco;
@property int nBlocosEspeciais;


- (NSMutableArray *)constroiFases:(int) faseLevel : (CGSize) tamanhoFrame;

- (void)destruiuBLoco;


@end
