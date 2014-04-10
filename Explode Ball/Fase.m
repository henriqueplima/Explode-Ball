//
//  Fase.m
//  Explode Ball
//
//  Created by HENRIQUE PEREIRA DE LIMA on 31/03/14.
//  Copyright (c) 2014 HENRIQUE PEREIRA DE LIMA. All rights reserved.
//

#import "Fase.h"

@implementation Fase




- (NSMutableArray *)constroiFases:(int) faseLevel : (CGSize) tamanhoFrame{
    
    self.nBlocosQuebraveis = 0;
    self.tamanhoBloco = CGSizeMake(tamanhoFrame.width * 0.07,tamanhoFrame.height * 0.04);;
    
    self.blocos = [[NSMutableArray alloc]init];
    switch (faseLevel) {
        
           
            case 1:
            
            [self faseBrasil:tamanhoFrame];
            //[self faseTeste:tamanhoFrame];
            self.tempo = 120;
            
            break;
            
        case 2:
            //Brasil
            
            [self faseFlor:tamanhoFrame];
            self.tempo = 120;
            
            break;
            
            case 3:
            
            // Blocos se movimentam
            
            break;
            
        default:
            break;
    }
    
    return self.blocos;
    
    
}

- (void)faseTeste: (CGSize)tamanhoFrame{
    self.nBlocosQuebraveis = 0;
    CGPoint posicao1;
    CGPoint posicaoBloco;
    
    posicao1 = CGPointMake(tamanhoFrame.width * 0.5, tamanhoFrame.height * 0.5);
    posicaoBloco = posicao1;
    
    
        [self.blocos addObject:[Bloco constroiBloco:@"blocoVerde" tamanho:self.tamanhoBloco posicao:posicaoBloco vida:1]];
        [self tornaEspecial:[self.blocos lastObject]];
        self.nBlocosQuebraveis += 1;
    
    float primeiroPosition = posicaoBloco.y;
    
    posicaoBloco.y -= self.tamanhoBloco.height * 0.50;
        posicaoBloco.x -= self.tamanhoBloco.width * 1.0;
        
    
    float segundoPosition = posicaoBloco.y;
    
    NSLog(@"primeira : %f segunda %f \n",primeiroPosition,segundoPosition);
    
    float diferenca = segundoPosition - primeiroPosition;
    NSLog(@"diferenca %f",diferenca);
    
    
    
    [self.blocos addObject:[Bloco constroiBloco:@"blocoVerde" tamanho:self.tamanhoBloco posicao:posicaoBloco vida:1]];
    [self tornaEspecial:[self.blocos lastObject]];
    self.nBlocosQuebraveis += 1;

    
    posicaoBloco.y = tamanhoFrame.height * 0.65;
    
//    for (int i = 0; i < 2; i++) {
//        [self.blocos addObject:[Bloco constroiBloco:@"blocoVerde" tamanho:self.tamanhoBloco posicao:posicaoBloco vida:1]];
//        [self tornaEspecial:[self.blocos lastObject]];
//        self.nBlocosQuebraveis += 1;
//        posicaoBloco.y = self.tamanhoBloco.height * 1.15;
//        posicaoBloco.x = self.tamanhoBloco.width * 1.0;
//    }
    
}





- (void)destruiuBLoco{
    self.nBlocosQuebraveis -= 1;
    
    
}


- (void)tornaEspecial: (Bloco *)bloco{
    
    int x = arc4random()% 15;
    if (x <= 1) {
        bloco.physicsBody.collisionBitMask = categoriaBLocoEfeito;
        NSLog(@"especial funcionou");
    }
    
}

- (void)faseBrasil: (CGSize)tamanhoFrame{
    self.nBlocosQuebraveis = 0;
    CGPoint posicao1;
    CGPoint posicaoBloco;
    
    posicao1 = CGPointMake(tamanhoFrame.width * 0.15, tamanhoFrame.height * 0.75);
    posicaoBloco = posicao1;
    
    // Blocos Verde
    
    for (int y = 0; y < 11; y++) {
        for (int x = 0; x < 11; x++) {
            
            
            if (y == 0 || y == 10) {
                
                [self.blocos addObject:[Bloco constroiBloco:@"blocoVerde" tamanho:self.tamanhoBloco posicao:posicaoBloco vida:1]];
                [self tornaEspecial:[self.blocos lastObject]];
                self.nBlocosQuebraveis += 1;
                
            }else if (x == 0 || x == 10){
                
                [self.blocos addObject:[Bloco constroiBloco:@"blocoVerde" tamanho:self.tamanhoBloco posicao:posicaoBloco vida:1]];
                [self tornaEspecial:[self.blocos lastObject]];
                self.nBlocosQuebraveis += 1;
                
            }
            posicaoBloco.x += (self.tamanhoBloco.width * 1.0);
            
            
            
        }
        posicaoBloco.y -= (self.tamanhoBloco.height * 1.0);
        posicaoBloco.x = posicao1.x;
        
    }
    
    // Blocos Amarelos
    
    posicao1 = CGPointMake(tamanhoFrame.width * 0.465, tamanhoFrame.height * 0.71);
    posicao1.x += (self.tamanhoBloco.width * 0.5);
    posicaoBloco = posicao1;
    
    
    
    for (int y = 0; y < 5; y++) {
        for (int x = 0; x < 5; x++) {
            
            
            if (y == 0 || y == 4) {
                
                [self.blocos addObject:[Bloco constroiBloco:@"blocoAmarelo" tamanho:self.tamanhoBloco posicao:posicaoBloco vida:1]];
                [self tornaEspecial:[self.blocos lastObject]];
                self.nBlocosQuebraveis += 1;
                
            }else if (x == 0 || x == 4){
                
                
                [self.blocos addObject:[Bloco constroiBloco:@"blocoAmarelo" tamanho:self.tamanhoBloco posicao:posicaoBloco vida:1]];
                [self tornaEspecial:[self.blocos lastObject]];
                self.nBlocosQuebraveis += 1;
                
            }
            posicaoBloco.x -= (self.tamanhoBloco.width * 1.0);
            posicaoBloco.y -= (self.tamanhoBloco.height * 1.0);
            
            
            
        }
        float teste = y + 1;
        posicaoBloco.x = posicao1.x;
        posicaoBloco.y = posicao1.y;
        posicaoBloco.x += (self.tamanhoBloco.width * teste);
        
        posicaoBloco.y -= (self.tamanhoBloco.height * teste);
        
        
    }
    
    
    // Bloco Azul
    
    posicao1 = CGPointMake(tamanhoFrame.width * 0.43, tamanhoFrame.height * 0.59);
    //position1.x += (size.width * 0.5);
    posicaoBloco = posicao1;
    
    
    
    
    for (int y = 0; y < 3; y++) {
        for (int x = 0; x < 3; x++) {
            
            
            if (y == 0 || y == 2) {
                
                [self.blocos addObject:[Bloco constroiBloco:@"blocoAzul" tamanho:self.tamanhoBloco posicao:posicaoBloco vida:1]];
                [self tornaEspecial:[self.blocos lastObject]];
                self.nBlocosQuebraveis += 1;
                
            }else if (x == 0 || x == 2){
                
                
                [self.blocos addObject:[Bloco constroiBloco:@"blocoAzul" tamanho:self.tamanhoBloco posicao:posicaoBloco vida:1]];
                [self tornaEspecial:[self.blocos lastObject]];
                self.nBlocosQuebraveis += 1;
                
                
            }
            posicaoBloco.x += (self.tamanhoBloco.width * 1.0);
            
            
            
        }
        posicaoBloco.y -= (self.tamanhoBloco.height * 1.0);
        posicaoBloco.x = posicao1.x;
        
    }

    
}

- (void)faseFlor: (CGSize)tamanhoFrame{
    self.nBlocosQuebraveis = 0;
    self.blocos = nil;
    self.blocos = [[NSMutableArray alloc]init];
    
    CGPoint posicao1 = CGPointMake(tamanhoFrame.width * 0.20, tamanhoFrame.height * 0.75);
    CGPoint posicaoBloco = posicao1;
    
    
    
    for (int y = 0; y < 9; y++) {
        for (int x = 0; x < 9; x++) {
            
            if (y == 0 || y == 8) {
                if (x < 3|| x > 5) {
                    [self.blocos addObject:[Bloco constroiBloco:@"blocoNaoQuebra" tamanho:self.tamanhoBloco posicao:posicaoBloco vida:-1]];
                }
                
                
                
                
            }else if ((y == 1 && x == 0) || (y == 1 && x == 8) || (y == 2 && x == 0) || (y == 2 && x == 8) || (y == 7 && x == 0) || (y == 7 && x == 8) || (y == 6 && x == 0) || (y == 6 && x == 8) ){
                [self.blocos addObject:[Bloco constroiBloco:@"blocoNaoQuebra" tamanho:self.tamanhoBloco posicao:posicaoBloco vida:-1]];
            }
            
            
            
            else if ((y == 2 && x == 4) ||(y == 3 && x == 3 ) || (y == 3 && x == 5) || (y == 4 && x == 4)) {
                [self.blocos addObject:[Bloco constroiBloco:@"blocoVermelho" tamanho:self.tamanhoBloco posicao:posicaoBloco vida:1]];
                self.nBlocosQuebraveis += 1;
                [self tornaEspecial:[self.blocos lastObject]];
            }else if (y == 3 && x == 4){
                [self.blocos addObject:[Bloco constroiBloco:@"blocoAmarelo" tamanho:self.tamanhoBloco posicao:posicaoBloco vida:1]];
                [self tornaEspecial:[self.blocos lastObject]];
                self.nBlocosQuebraveis += 1;
            }else if ((y == 4 && x == 5) || (y == 5 && x == 6) || (y == 6 && x == 7) ){
                [self.blocos addObject:[Bloco constroiBloco:@"blocoVerde" tamanho:self.tamanhoBloco posicao:posicaoBloco vida:1]];
                [self tornaEspecial:[self.blocos lastObject]];
                self.nBlocosQuebraveis += 1;
            }
            else{
                [self.blocos addObject:[Bloco constroiBloco:@"blocoAzul" tamanho:self.tamanhoBloco posicao:posicaoBloco vida:1]];
                [self tornaEspecial:[self.blocos lastObject]];
                self.nBlocosQuebraveis += 1;
            }
            posicaoBloco.x += (self.tamanhoBloco.width * 1.0);
            
            
        }
        posicaoBloco.y -= (self.tamanhoBloco.height * 1.0);
        posicaoBloco.x = posicao1.x;
        
    }
    
}


@end
