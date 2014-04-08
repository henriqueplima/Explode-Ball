//
//  GerenciadorJogo.m
//  Explode Ball
//
//  Created by HENRIQUE PEREIRA DE LIMA on 27/03/14.
//  Copyright (c) 2014 HENRIQUE PEREIRA DE LIMA. All rights reserved.
//

#import "GerenciadorJogo.h"

@implementation GerenciadorJogo

+ (GerenciadorJogo *)compartilharGerenciador{
    static GerenciadorJogo *gerenciadorCompartilhado = nil;
    
    if (!gerenciadorCompartilhado) {
        gerenciadorCompartilhado = [[super allocWithZone:nil] init];
    }
    return gerenciadorCompartilhado;
}


+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self compartilharGerenciador];
}


- (id) init{
    self = [super init];
    if (self) {
        self.vida = 2;
        self.pontos = 0;
        self.faseMenu = [[Fase alloc]init];
        self.Fase = 1;
        self.nFases = 2;
        
    }
    return self;
}

- (void) alteraVida : (bool)acrescenta{
    
    
    // se valor do acrescenta for verdadeiro então a vida é incrementada se não é decrementada
    
    if (acrescenta) {
        self.vida += 1;
    }else{
        self.vida -= 1;
    }
    
    
}


- (void)zerarJogo{
    self.vida = 2;
    self.Fase = 1;
    self.pontos = 0;
    self.nome = @"";
    self.velocidadeMax = NO;
}

- (void)preparaPlayerPrincipal: (int)faixa{
    
    
    NSURL *urlSom;
    
    switch (faixa) {
        case 0:
            //
            break;
        case 1:
            
            
            urlSom   = [[NSBundle mainBundle] URLForResource:@"sonic" withExtension:@"mp3"];
            self.playerPrincipal = [[AVAudioPlayer alloc] initWithContentsOfURL:urlSom error:nil];
            self.playerPrincipal.numberOfLoops = -1;
            self.playerPrincipal.volume = 0.5;
            [self.playerPrincipal play];
            break;

            
        case 2:
            urlSom   = [[NSBundle mainBundle] URLForResource:@"StreetFighter" withExtension:@"mp3"];
            self.playerPrincipal = [[AVAudioPlayer alloc] initWithContentsOfURL:urlSom error:nil];
            self.playerPrincipal.numberOfLoops = -1;
            self.playerPrincipal.volume = 0.5;
            [self.playerPrincipal play];
        default:
            break;
    }
    
}

- (void)preparaPlayerSecundario:(int)faixa{
    
    
    NSURL *urlSom;
    
    switch (faixa) {
        case 0:
            urlSom   = [[NSBundle mainBundle] URLForResource:@"quebrando" withExtension:@"mp3"];
            self.playerSecundario = [[AVAudioPlayer alloc] initWithContentsOfURL:urlSom error:nil];
            //self.playerSecundario.numberOfLoops = -1;
            self.playerSecundario.volume = 0.5;
            [self.playerSecundario play];
            break;
        case 1:
            
            
            
            break;
            
            
        case 2:
            break;
        default:
            break;
    }
    
}




@end
