//
//  Bloco.m
//  Explode Ball
//
//  Created by Henrique Pereira de Lima on 31/03/14.
//  Copyright (c) 2014 HENRIQUE PEREIRA DE LIMA. All rights reserved.
//

#import "Bloco.h"

@implementation Bloco


- (SKPhysicsBody *)constroiFisica : (int)vida{
    
   SKPhysicsBody *corpo = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    
    
    
    corpo.restitution = 0.1f;
    corpo.dynamic = NO;
    corpo.affectedByGravity = NO;

    
    switch (vida) {
        case -1:
            corpo.categoryBitMask = categoriaBLocoInquebravel;
            break;
    
        case 1:
            corpo.categoryBitMask = categoriaBLoco;
            break;
            
        case 2:
            corpo.categoryBitMask = categoriaBLocoInvisivel;
            break;
        case 4:
            corpo.categoryBitMask = categoriaBLocoLevel2;
            break;
            
        case 5:
            corpo.categoryBitMask = categoriaBLocoLevel3;
        default:
            break;
    }
    
    
    return corpo;

    
    
}

+ (Bloco *)constroiBloco: (NSString *)imagem  tamanho: (CGSize)tamanhoBloco posicao: (CGPoint)posicao vida: (int)vida{
    
    Bloco *novoBloco = [Bloco spriteNodeWithImageNamed:imagem];
    novoBloco.name = @"Bloco";
    novoBloco.size = tamanhoBloco;
    novoBloco.position = posicao;
    novoBloco.physicsBody = [novoBloco constroiFisica:vida];
    
    return novoBloco;
}





@end
