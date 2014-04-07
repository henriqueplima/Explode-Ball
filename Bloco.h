//
//  Bloco.h
//  Explode Ball
//
//  Created by Henrique Pereira de Lima on 31/03/14.
//  Copyright (c) 2014 HENRIQUE PEREIRA DE LIMA. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Corpo.h"

static const uint32_t categoriaBLoco = 0x1 << 4;
static const uint32_t categoriaBLocoInquebravel = 0x1 << 5;
static const uint32_t categoriaBLocoInvisivel = 0x1 << 6;
static const uint32_t categoriaBLocoLevel2 = 0x1 << 7;
static const uint32_t categoriaBLocoLevel3 = 0x1 << 8;
static const uint32_t categoriaBLocoEfeito = 0x1 << 9;
static const uint32_t categoriaBola2 = 0x1 << 0;

@interface Bloco : SKSpriteNode

@property int vida;
@property BOOL especial;
- (SKPhysicsBody *)constroiFisica : (int)vida;
+ (Bloco *)constroiBloco: (NSString *)imagem  tamanho: (CGSize)tamanhoBloco posicao: (CGPoint)posicao vida: (int)vida;
@end
