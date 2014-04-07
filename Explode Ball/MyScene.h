//
//  MyScene.h
//  Explode Ball
//

//  Copyright (c) 2014 HENRIQUE PEREIRA DE LIMA. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <CoreMotion/CoreMotion.h>
#import "GerenciadorJogo.h"
#import "Fase.h"
#import "Bloco.h"

@interface MyScene : SKScene <SKPhysicsContactDelegate>
{
    SKSpriteNode *spriteBola;
    SKPhysicsBody *bordas;
    SKSpriteNode *spritePalheta;
}

@property GerenciadorJogo *gerenciadorJogo;
@property (nonatomic) BOOL touchPalheta;
@property SKLabelNode * lblVida;
@property SKLabelNode *lblPontos;
@end
