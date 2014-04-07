//
//  Perdeu.m
//  Explode Ball
//
//  Created by Henrique Pereira de Lima on 01/04/14.
//  Copyright (c) 2014 HENRIQUE PEREIRA DE LIMA. All rights reserved.
//

#import "Perdeu.h"

@implementation Perdeu

- (id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        myLabel.fontSize = 70;
        
        
        
        
        self.gerenciadorJogo = [GerenciadorJogo compartilharGerenciador];
        
        myLabel.text = self.gerenciadorJogo.fraseFinal;
        [self addChild:myLabel];
        
        [self.gerenciadorJogo preparaPlayerPrincipal:2];
        
        [self gravandoRanking];
        [self.gerenciadorJogo zerarJogo];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
    //Chamado quando ocorrer um evento de touch
    UITouch *touch = [touches anyObject];
    
    
    
    if ([touch tapCount ] == 2)
    {
        ViewController *menuPrincipal = [ViewController sharedViewController];
        [menuPrincipal voltarMenuPrincipal];
        [self.gerenciadorJogo.playerPrincipal stop];
    }
}

- (void)gravandoRanking{
    
    
    GerenciaRanking *ranking = [GerenciaRanking compartilharGerenciador];
    
    [ranking writeToPlist:self.gerenciadorJogo.nome :[NSString stringWithFormat:@"%d",self.gerenciadorJogo.pontos]];
   
    
}

@end
