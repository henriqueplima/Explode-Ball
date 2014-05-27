//
//  GerenciadorJogo.h
//  Explode Ball
//
//  Created by HENRIQUE PEREIRA DE LIMA on 27/03/14.
//  Copyright (c) 2014 HENRIQUE PEREIRA DE LIMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fase.h"
#import "Bloco.h"
#import <AVFoundation/AVFoundation.h>


static const uint32_t categoriaBola = 0x1 << 0;
static const uint32_t categoriaPalheta = 0x1 << 1;

static const uint32_t categoriaBonus = 0x1 << 2;
static const uint32_t categoriaBordaInferior = 0x1 << 3;
static const uint32_t categoriaTiro = 0x1 << 10;
static const uint32_t categoriaBordaSuperior = 0x1 << 11;
@interface GerenciadorJogo : NSObject

//propriedades

@property NSString *nome;
@property int pontos;
@property int vida;
@property NSMutableArray *totalBlocos;
@property int Fase;
@property Fase *faseMenu;
@property int nBlocos;
@property AVAudioPlayer *playerPrincipal;
@property AVAudioPlayer *playerSecundario;
@property BOOL comecou;
@property int porcentagem;
@property BOOL velocidadeMax;
@property BOOL superBola;
@property BOOL tiro;
@property int nFases;
@property NSString *fraseFinal;
@property CGSize tamanhoOriginalPalheta;
@property int repetiuBatidaLateral;
@property float posicaoAntes;
@property float posicaoDepois;
@property BOOL acelerometro;
@property NSMutableArray *blocosInvisivel;

//Métodos:

// método de classe
+ (GerenciadorJogo *)compartilharGerenciador;
+ (id)allocWithZone:(struct _NSZone *)zone;


// método de objetos
- (id) init;
- (void) alteraVida : (bool)acrescenta;
- (void)zerarJogo;
- (void)preparaPlayerPrincipal: (int)faixa;
- (void)preparaPlayerSecundario: (int)faixa;




@end
