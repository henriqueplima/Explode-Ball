//
//  MyScene.m
//  Explode Ball
//
//  Created by HENRIQUE PEREIRA DE LIMA on 27/03/14.
//  Copyright (c) 2014 HENRIQUE PEREIRA DE LIMA. All rights reserved.
//

#import "MyScene.h"
#import "ViewController.h"

@implementation MyScene{
    CMMotionManager *motionManager;
}

@synthesize touchPalheta;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size])
    {
        
        
        
//        [self criaEfeito];
        self.gerenciadorJogo = [GerenciadorJogo compartilharGerenciador];
        
        
        //Define a cor de fundo do cenário
        //SKColor *fundo = [[SKColor alloc]initWithRed:1 green:1 blue:1 alpha:1];
                // Gravidade do Jogo
        //[self.physicsWorld setGravity:CGVectorMake(0, -5)];
        self.physicsWorld.contactDelegate = self;
        
        
        //criando bordas laterais
        //SKPhysicsBody* bordasLaterais = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        bordas = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, 0, self.size.width, self.size.height)];
        //bordas.node.name = @"Bordas";
        self.physicsBody = bordas;
        self.physicsBody.friction = 0.0f;
        
        
        
        
        //Montar Fase
        
        [self montarFase];
        
        
        
        
        
        //inicializa acelerometro

        
        if (self.gerenciadorJogo.acelerometro) {
             [self inicializaAcelerometro];
        }
       
        
    }
    return self;
}

- (void)inicializaAcelerometro{
    motionManager = [[CMMotionManager alloc]init];
    if (motionManager.accelerometerAvailable) {
        [motionManager startAccelerometerUpdates];
    }
    
}

- (void)encerraAcelerometro{
 
    if (motionManager.accelerometerAvailable && motionManager.accelerometerActive) {
        [motionManager stopAccelerometerUpdates];
    }
    
}


- (void)montarFase{
    
    self.gerenciadorJogo = [GerenciadorJogo compartilharGerenciador];
    
    // Monta fundo
    SKSpriteNode *fundo = [SKSpriteNode spriteNodeWithImageNamed:@"fundo4.png"];
    //SKColor *fundo = [[SKColor alloc]initWithRed:0.3 green:0.5 blue:0.8 alpha:1];
    self.backgroundColor = [SKColor whiteColor];
    fundo.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:fundo];

    
    
    self.gerenciadorJogo.totalBlocos = [self.gerenciadorJogo.faseMenu constroiFases:self.gerenciadorJogo.Fase :self.size];
    
    for (int i = 0; i < self.gerenciadorJogo.totalBlocos.count; i++) {
        [self addChild:[self.gerenciadorJogo.totalBlocos objectAtIndex:i]  ];
           //[[self.gerenciadorJogo.totalBlocos objectAtIndex:i] runAction:[SKAction fadeOutWithDuration:0]];
    }
    
    if (self.gerenciadorJogo.faseMenu.blocosInvi != nil) {
        for (int i = 0; i < self.gerenciadorJogo.faseMenu.blocosInvi.count; i++) {
            //[[self.gerenciadorJogo.faseMenu.blocosInvi objectAtIndex:i] runAction:[SKAction fadeOutWithDuration:0]];
            [[self.gerenciadorJogo.faseMenu.blocosInvi objectAtIndex:i] setAlpha:0];
            [self addChild:[self.gerenciadorJogo.faseMenu.blocosInvi objectAtIndex:i]  ];
        }
    }

    [self.gerenciadorJogo preparaPlayerPrincipal:1];
    self.tempoCorrido = self.gerenciadorJogo.faseMenu.tempo;
    
    //cria os demais nos da cena
    
    [self criarObjetos];
    [self iniciaRodada];
}


- (void)criarPalhetaBola{
    //Propriedades Bola
    spriteBola = [SKSpriteNode spriteNodeWithImageNamed:@"ball2"];
    spriteBola.name = @"Bola";
    [spriteBola setSize:CGSizeMake(20,20)];
    spriteBola.position = CGPointMake(self.size.width/2, self.size.height * 0.075);
    [self addChild:spriteBola];
    
    spriteBola.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:spriteBola.size.width/2];
    spriteBola.physicsBody.friction = 0.0f;
    spriteBola.physicsBody.restitution = 1.0f;
    spriteBola.physicsBody.linearDamping = 0.0f;
    spriteBola.physicsBody.allowsRotation = NO;
    spriteBola.physicsBody.affectedByGravity = NO;
    
    spriteBola.physicsBody.categoryBitMask = categoriaBola;
    spriteBola.physicsBody.contactTestBitMask = categoriaPalheta | categoriaBordaInferior | categoriaBLoco | categoriaBLocoInquebravel | categoriaBLocoInvisivel | categoriaBLocoLevel2 | categoriaBLocoLevel3;
    spriteBola.physicsBody.collisionBitMask = categoriaPalheta | categoriaBLoco | categoriaBLocoInquebravel | categoriaBLocoInvisivel | categoriaBLocoLevel2 | categoriaBLocoLevel3;
    
    //Propriedades Palheta
    spritePalheta = [SKSpriteNode spriteNodeWithImageNamed:@"palheta"];
    self.gerenciadorJogo.tamanhoOriginalPalheta = CGSizeMake(self.size.width * 0.15, self.size.height * 0.02);
    [spritePalheta setSize:self.gerenciadorJogo.tamanhoOriginalPalheta];
    spritePalheta.name = @"Palheta";
    spritePalheta.position = CGPointMake(self.size.width/2, self.size.height * 0.05);
    //spritePalheta.position = CGPointMake(self.size.width * 0.8, self.size.height * 0.05);
    spritePalheta.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:spritePalheta.frame.size];
    spritePalheta.physicsBody.restitution = 0.1f;
    spritePalheta.physicsBody.friction = 0.4f;
    spritePalheta.physicsBody.dynamic = NO;
    
    spritePalheta.physicsBody.categoryBitMask = categoriaPalheta;
    spritePalheta.physicsBody.contactTestBitMask = categoriaBola | categoriaBonus;
    spritePalheta.physicsBody.collisionBitMask = categoriaBola | categoriaBonus;
    
    
    
    
    [self addChild:spritePalheta];
    
    //Join Palheta e Bola
    [self.physicsWorld addJoint: [SKPhysicsJointPin jointWithBodyA:spritePalheta.physicsBody bodyB: spriteBola.physicsBody anchor:spritePalheta.position]];
}

- (void)criarObjetos{
 
    
    //Borda inferior
    //borda de inferior
    SKSpriteNode *bordaInferior = [SKSpriteNode spriteNodeWithImageNamed:@"barrinha"];
    bordaInferior.name = @"BordaInferior";
    bordaInferior.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.01);
    [bordaInferior setSize:CGSizeMake(self.size.width, self.size.height * 0.003)];
    bordaInferior.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bordaInferior.size];
    bordaInferior.physicsBody.dynamic = NO;
    bordaInferior.physicsBody.affectedByGravity = NO;
    //bordaInferior.physicsBody.categoryBitMask = categoriaBordaInferior | categoriaBola | categoriaBonus;
    bordaInferior.physicsBody.categoryBitMask = categoriaBordaInferior;
    //bordaInferior
    [self addChild:bordaInferior];

    //borda superior
    //SKSpriteNode *bordaSuperior = [SKSpriteNode spriteNodeWithImageNamed:@"barrinha"];
    SKSpriteNode *bordaSuperior = [[SKSpriteNode alloc]init];
    bordaSuperior.name = @"BordaSuperior";
    bordaSuperior.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.999);
    [bordaSuperior setSize:CGSizeMake(self.size.width, self.size.height * 0.003)];
    bordaSuperior.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bordaSuperior.size];
    bordaSuperior.physicsBody.dynamic = NO;
    bordaSuperior.physicsBody.affectedByGravity = NO;
    //bordaInferior.physicsBody.categoryBitMask = categoriaBordaInferior | categoriaBola | categoriaBonus;
    bordaSuperior.physicsBody.categoryBitMask = categoriaBordaSuperior;
    //bordaInferior
    [self addChild:bordaSuperior];
    
    
    //[self criarPalhetaBola];

    
    self.gerenciadorJogo.comecou = NO;
    
    
    //cria Labels
    self.lblVida = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    [self.lblVida setText:[NSString stringWithFormat:@"%d",self.gerenciadorJogo.vida]];
    self.lblVida.position = CGPointMake(self.frame.size.width * 0.9, self.size.height * 0.9);
    self.lblVida.fontSize = 80;
    self.lblVida.fontName = @"Feast of Flesh BB";
    
    self.lblPontos = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    [self.lblPontos setText:[NSString stringWithFormat:@"%d", self.gerenciadorJogo.pontos]];
    self.lblPontos.position = CGPointMake(self.frame.size.width * 0.1, self.size.height * 0.9);
    self.lblPontos.fontSize = 80;
    self.lblPontos.fontName = @"Feast of Flesh BB";
    
    self.lblTempo = [SKLabelNode labelNodeWithFontNamed:@"Feast of Flesh BB"];
    self.lblTempo.position = CGPointMake(self.frame.size.width * 0.5, self.size.height * 0.9);
    self.lblTempo.fontSize = 60;
    
    int minutos = self.tempoCorrido / 60;
    
    int segundos = self.tempoCorrido - minutos * 60;
    
    if (segundos < 10) {
        [self.lblTempo setText:[NSString stringWithFormat: @"%d : 0%d",minutos,segundos ]];
    }else{
        [self.lblTempo setText:[NSString stringWithFormat: @"%d : %d",minutos,segundos ]];
    }
    
    
    [self.lblTempo setColor:[UIColor yellowColor]];
    
    [self addChild:self.lblVida];
    [self addChild:self.lblPontos];
    [self addChild:self.lblTempo];
    
    
    
    
    
}




- (void)atualizaPosicaoAcelerometro{
    CMAccelerometerData* data = motionManager.accelerometerData;
    
    if (fabs(data.acceleration.y) > 0.02f) {
        float aceleracao = data.acceleration.y + 0.5;
        //NSLog(@"acceleration value = %f",data.acceleration.y);
        //NSLog(@"aceleracao somada %f",aceleracao);
        float teste = 1000 * aceleracao;
         //NSLog(@"teste valor = %f",teste);
        
        
        teste = MAX(teste, spritePalheta.size.width/2);
        teste = MIN(teste, self.size.width - spritePalheta.size.width/2);
        
        
        [spritePalheta setPosition:CGPointMake(teste, spritePalheta.position.y)];
        
        
    }
    
}

- (void)youLose{
    [self.gerenciadorJogo preparaPlayerPrincipal:2];
    ViewController *menuPrincipal = [ViewController sharedViewController];
    self.gerenciadorJogo.fraseFinal = @"Você Perdeu";
    [menuPrincipal CenaYouLose];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
    //Chamado quando ocorrer um evento de touch
    UITouch *touch = [touches anyObject];
//    CGPoint touchLocation = [touch locationInNode:self];
//    
//    SKPhysicsBody* body = [self.physicsWorld bodyAtPoint:touchLocation];
//    if (body && [body.node.name isEqualToString: @"Palheta"])
//    {
//        NSLog(@"palheta posicao : %f",spritePalheta.position.x);
        self.touchPalheta = YES;
//    }
    

    
    
    if ([touch tapCount] == 2) {
        if (!self.gerenciadorJogo.comecou) {
            [self iniciarTimer];
            [spriteBola.physicsBody applyImpulse:CGVectorMake(3.0f, 5.0f)];
            [self.physicsWorld removeAllJoints];
            self.gerenciadorJogo.comecou = YES;
            //spritePalheta.size = CGSizeMake(spritePalheta.size.width * 1.5, spritePalheta.size.height);
            
            
        }
    }
    
    if (self.gerenciadorJogo.tiro) {
        [self criaTiro];
    }
    
}



- (void)iniciarTimer{
    self.tempo = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(controlaTempo) userInfo:nil repeats:YES];
}

-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    // Verifica se houve touch na Palheta
    if (self.touchPalheta)
    {
        // Pega a localização do touch
        UITouch* touch = [touches anyObject];
        CGPoint touchLocation = [touch locationInNode:self];
        
        CGPoint previousLocation = [touch previousLocationInNode:self];
        // 3 Get node for paddle
        SKSpriteNode* spritePalheta = (SKSpriteNode*)[self childNodeWithName: @"Palheta"];
        // 4 Calculate new position along x for paddle
        int paddleX = spritePalheta.position.x + (touchLocation.x - previousLocation.x);
        // 5 Limit x so that the paddle will not leave the screen to left or right
        paddleX = MAX(paddleX, spritePalheta.size.width/2);
        paddleX = MIN(paddleX, self.size.width - spritePalheta.size.width/2);
        // 6 Update position of paddle
        spritePalheta.position = CGPointMake(paddleX, spritePalheta.position.y);
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
}

- (void)encerraRodada{
    
    [self zeraRepetidorTempo];
    
    if (self.gerenciadorJogo.vida <= 1) {
        [self youLose];
        
    }else{
        [spriteBola removeFromParent];
        [spritePalheta removeFromParent];
        self.gerenciadorJogo.comecou = NO;
        [self.gerenciadorJogo alteraVida:NO];
        [self iniciaRodada];
        
    }

    
}

- (void)removeCorpo: (SKPhysicsBody *)corpo{
    
    if ([corpo.node.name isEqualToString:@"Bloco"]) {
        [self.gerenciadorJogo.faseMenu destruiuBLoco];
        self.gerenciadorJogo.pontos += 10;
        [self.lblPontos setText:[NSString stringWithFormat:@"%d",self.gerenciadorJogo.pontos]];
        [self.gerenciadorJogo preparaPlayerSecundario:0];
        [self Ganhou];
    }
    
    [corpo.node removeFromParent];
    
}

- (void)iniciaRodada{
    [self criarPalhetaBola];
    [self.lblVida setText:[NSString stringWithFormat:@"%d",self.gerenciadorJogo.vida]];
    self.gerenciadorJogo.velocidadeMax = NO;
    self.gerenciadorJogo.superBola = NO;
    self.gerenciadorJogo.tiro = NO;
    self.gerenciadorJogo.comecou = NO;
    //self.tempo = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(controlaTempo) userInfo:nil repeats:YES];
}

- (void)didBeginContact:(SKPhysicsContact *)contact{
    SKPhysicsBody *first, *second;
    
    first = contact.bodyA;
    second = contact.bodyB;
    
    
    //NSLog(@"primeiro : %@ segundo : %@",first.node.name,second.node.name);
    
    
    //Tiro
    
    if (second.categoryBitMask == categoriaTiro && [first.node.name isEqualToString:@"Bloco"]) {
        
        self.gerenciadorJogo.repetiuBatidaLateral = 0;
        
        if (first.categoryBitMask == categoriaBLocoInquebravel) {
            [self removeCorpo:second];
        }else if (first.categoryBitMask == categoriaBLocoInvisivel){
            first.categoryBitMask = categoriaBLoco;
                     [first.node setAlpha:1];
        }else{
            [self removeCorpo:second];
            [self removeCorpo:first];
        }
        
    }else if (first.categoryBitMask == categoriaTiro && [second.node.name isEqualToString:@"Bloco"]){
        
        self.gerenciadorJogo.repetiuBatidaLateral = 0;
        
        if (second.categoryBitMask == categoriaBLocoInquebravel) {
            [self removeCorpo:first];
        }else if (second.categoryBitMask == categoriaBLocoInvisivel){
            second.categoryBitMask = categoriaBLoco;
            [second.node setAlpha:1];
        }else{
            [self removeCorpo:second];
            [self removeCorpo:first];
        }
        
        
        // contato Palheta e bola
    }else if ([first.node.name isEqualToString:@"Palheta"] && [second.node.name isEqualToString:@"Bola"]){
        
        self.gerenciadorJogo.repetiuBatidaLateral = 0;
        
        float palheta = first.node.position.x;
        float bola = second.node.position.x;
        bola = bola / 10;
        palheta = palheta / 10;
        float impulsoY = bola - palheta;
        //[second applyImpulse:CGVectorMake(0, 0)];
        if (impulsoY < 0) {
            [second setVelocity:CGVectorMake(1, -1)];
        }else{
            [second setVelocity:CGVectorMake(-1, -1)];
        }
        [second applyImpulse:CGVectorMake(impulsoY, 5.0f)];
        
        
        //Contato Borda Inferior e Bola
        
        
    }else if ([first.node.name isEqualToString:@"BordaInferior"] && [second.node.name isEqualToString:@"Bola"]){
        self.gerenciadorJogo.repetiuBatidaLateral = 0;
        [self encerraRodada];
        
        //Contato bloco e Bola
        
    }else if ([first.node.name isEqualToString:@"Bloco"] && [second.node.name isEqualToString:@"Bola"]){
        self.gerenciadorJogo.repetiuBatidaLateral = 0;
        if (self.gerenciadorJogo.superBola) {
            [self removeCorpo:first];
        }else if (first.categoryBitMask == categoriaBLoco) {
            if (first.collisionBitMask == categoriaBLocoEfeito) {
                [self criaEfeito:first.node.position];
            }
            [self removeCorpo:first];
        }else if (first.categoryBitMask == categoriaBLocoLevel3){
            first.categoryBitMask = categoriaBLocoLevel2;
            
        }else if (first.categoryBitMask == categoriaBLocoLevel2){
            first.categoryBitMask = categoriaBLoco;
        }else if (first.categoryBitMask == categoriaBLocoInvisivel){
            first.categoryBitMask = categoriaBLoco;
            //[[first.node] runAction:[SKAction fadeOutWithDuration:0]];
            //[first.node runAction:[SKAction fadeInWithDuration:2]];
            [first.node setAlpha:1];
        }
        
        //contato Bonus Palheta
    }else if (first.categoryBitMask == categoriaBonus && [second.node.name isEqualToString:@"Palheta"]){
        self.gerenciadorJogo.repetiuBatidaLateral = 0;
        
        if ([first.node.name isEqualToString:@"2x"]) {
            self.gerenciadorJogo.pontos *= 2;
            [self.lblPontos setText:[NSString stringWithFormat:@"%d",self.gerenciadorJogo.pontos]];
            [self removeCorpo:first];
        }else if ([first.node.name isEqualToString:@"vida"]){
            [self.gerenciadorJogo alteraVida:YES];
            [self.lblVida setText:[NSString stringWithFormat:@"%d",self.gerenciadorJogo.vida]];
            [self removeCorpo:first];
        }else if ([first.node.name isEqualToString:@"morre"]){
            [self removeCorpo:first];
            [self encerraRodada];
        }else if ([first.node.name isEqualToString:@"velocidade"]){
            [self removeCorpo:first];
            self.gerenciadorJogo.velocidadeMax = YES;
        }else if ([first.node.name isEqualToString:@"super"]){
            self.gerenciadorJogo.superBola = YES;
            [self removeCorpo:first];
            spriteBola.physicsBody.collisionBitMask = categoriaPalheta;
            spriteBola.physicsBody.contactTestBitMask = categoriaPalheta | categoriaBordaInferior | categoriaBLoco | categoriaBLocoInquebravel | categoriaBLocoInvisivel | categoriaBLocoLevel2 | categoriaBLocoLevel3 | categoriaBLocoInquebravel;
            NSLog(@"pegou super");
        }else if ([first.node.name isEqualToString:@"atirar"]){
            [self removeCorpo:first];
            self.gerenciadorJogo.tiro = YES;
        }

        
        
    }else if ([first.node.name isEqualToString:@"Palheta"] && second.categoryBitMask == categoriaBonus){
        self.gerenciadorJogo.repetiuBatidaLateral = 0;
        if ([second.node.name isEqualToString:@"2x"]) {
            self.gerenciadorJogo.pontos *= 2;
            [self.lblPontos setText:[NSString stringWithFormat:@"%d",self.gerenciadorJogo.pontos]];
            [self removeCorpo:second];
        }else if ([second.node.name isEqualToString:@"vida"]){
            [self.gerenciadorJogo alteraVida:YES];
            [self.lblVida setText:[NSString stringWithFormat:@"%d",self.gerenciadorJogo.vida]];
            [self removeCorpo:second];
        }else if ([second.node.name isEqualToString:@"morre"]){
            [self removeCorpo:second];
            [self encerraRodada];
        }else if ([second.node.name isEqualToString:@"velocidade"]){
            [self removeCorpo:second];
            self.gerenciadorJogo.velocidadeMax = YES;
        }else if ([second.node.name isEqualToString:@"super"]){
            self.gerenciadorJogo.superBola = YES;
            [self removeCorpo:second];
            spriteBola.physicsBody.collisionBitMask = categoriaPalheta;
            spriteBola.physicsBody.contactTestBitMask = categoriaPalheta | categoriaBordaInferior | categoriaBLoco | categoriaBLocoInquebravel | categoriaBLocoInvisivel | categoriaBLocoLevel2 | categoriaBLocoLevel3 | categoriaBLocoInquebravel;
            NSLog(@"pegou super");
        }else if ([second.node.name isEqualToString:@"atirar"]){
            [self removeCorpo:second];
            self.gerenciadorJogo.tiro = YES;
        }
        
        //contato Bonus e borda inferior

    }else if (first.contactTestBitMask == categoriaBonus && [second.node.name isEqualToString:@"BordaInferior"]){
        self.gerenciadorJogo.repetiuBatidaLateral = 0;
        [self removeCorpo:first];
    }else if (second.contactTestBitMask == categoriaBonus && [first.node.name isEqualToString:@"BordaInferior"]){
        [self removeCorpo:second];
        self.gerenciadorJogo.repetiuBatidaLateral = 0;
        
        
        //parade lateral e bola
        
        
    }else if (first.node.name == nil && [second.node.name isEqualToString:@"Bola"]){
        self.gerenciadorJogo.repetiuBatidaLateral += 1;
        if (self.gerenciadorJogo.repetiuBatidaLateral == 1) {
            self.gerenciadorJogo.posicaoAntes = second.node.position.y;
        }else if (self.gerenciadorJogo.repetiuBatidaLateral == 2){
            self.gerenciadorJogo.posicaoDepois = second.node.position.y;
            
            
            [self verificaRota];
        }
    }
    
   

    
}

- (void)verificaRota{
    
    float diferenca = 0;
    
    
    if (self.gerenciadorJogo.posicaoDepois > self.gerenciadorJogo.posicaoAntes) {
        //bolinha subindo
        
        if (self.gerenciadorJogo.posicaoDepois < 0) {
            self.gerenciadorJogo.posicaoDepois *= -1;
            self.gerenciadorJogo.posicaoAntes *= -1;
            
        }
    
        
        diferenca = self.gerenciadorJogo.posicaoDepois - self.gerenciadorJogo.posicaoAntes;
        
        if (diferenca < 30) {
            [spriteBola.physicsBody applyImpulse:CGVectorMake(8.0f, 5.0f)];
        }
        
    }else{
        //bolinha descendo
        if (self.gerenciadorJogo.posicaoAntes < 0) {
            self.gerenciadorJogo.posicaoDepois *= -1;
            self.gerenciadorJogo.posicaoAntes *= -1;
            
        }
        
        diferenca = self.gerenciadorJogo.posicaoAntes - self.gerenciadorJogo.posicaoDepois;
        
        if (diferenca < 30) {
            [spriteBola.physicsBody applyImpulse:CGVectorMake(8.0f, 5.0f)];
        }
        
        NSLog(@"antes %f depois %f\n",self.gerenciadorJogo.posicaoAntes, self.gerenciadorJogo.posicaoDepois);
        //diferenca = self.gerenciadorJogo.posicaoDepois - self.gerenciadorJogo.posicaoAntes;
        NSLog(@"diferenca %f\n",diferenca);

    }
    self.gerenciadorJogo.repetiuBatidaLateral = 0;
}

- (void)Ganhou{
    
    
    
    if (self.gerenciadorJogo.faseMenu.nBlocosQuebraveis < 1) {
        self.gerenciadorJogo.Fase += 1;
        [self zeraRepetidorTempo];
        if (self.gerenciadorJogo.Fase > self.gerenciadorJogo.nFases) {
            [self.gerenciadorJogo preparaPlayerPrincipal:2];
            self.gerenciadorJogo.fraseFinal = @"Você Ganhou";
            
            ViewController *menuPrincipal = [ViewController sharedViewController];
            [menuPrincipal CenaYouLose];
        }else{
            [self removeAllChildren];
            [self montarFase];
            [self zeraRepetidorTempo];
//            [self criarObjetos];
//            [self iniciaRodada];
        }
        
    }
}

- (void)ajustaVelocidade{
    SKNode* ball = [self childNodeWithName: @"Bola"];
    static int maxSpeed = 400;
    float speed = sqrt(ball.physicsBody.velocity.dx*ball.physicsBody.velocity.dx + ball.physicsBody.velocity.dy * ball.physicsBody.velocity.dy);
    if (speed > maxSpeed) {
        ball.physicsBody.linearDamping = - 0.4f;
    } else {
        ball.physicsBody.linearDamping = 0.0f;
    }

}

-(void)update:(CFTimeInterval)currentTime
{
    if (self.gerenciadorJogo.acelerometro) {
        [self atualizaPosicaoAcelerometro];
    }
 
    
    /* Called before each frame is rendered */
    SKNode* ball = [self childNodeWithName: @"Bola"];
    static int maxSpeed = 500;
    
    if (self.gerenciadorJogo.velocidadeMax) {
        maxSpeed = 650;
    }
    
    float speed = sqrt(ball.physicsBody.velocity.dx*ball.physicsBody.velocity.dx + ball.physicsBody.velocity.dy * ball.physicsBody.velocity.dy);
    if (speed > maxSpeed) {
        ball.physicsBody.linearDamping = 0.4f;
    } else {
        ball.physicsBody.linearDamping = 0.0f;
    }
    
}

- (void)criaTiro{
    SKSpriteNode *bala = [SKSpriteNode spriteNodeWithImageNamed:@"ball2"];
    bala.name = @"tiro";
    bala.size = CGSizeMake(7, 15);
    bala.position = spritePalheta.position;
    bala.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bala.size];
    //bonus.physicsBody.dynamic = NO;
    bala.physicsBody.categoryBitMask = categoriaTiro;
    bala.physicsBody.collisionBitMask = categoriaBLocoInquebravel;
    bala.physicsBody.contactTestBitMask =  categoriaBLocoInvisivel | categoriaBLoco | categoriaBLocoLevel2 | categoriaBLocoLevel3 | categoriaBLocoInquebravel;
    //bonus.physicsBody.collisionBitMask = categoriaPalheta;
    bala.physicsBody.dynamic = YES;
    bala.physicsBody.affectedByGravity = NO;
    
    [self addChild:bala];
    
    [bala runAction:[SKAction moveToY:2000 duration:3.0]];
    
}

- (void)criaEfeito : (CGPoint)posicao{
    
    int x = arc4random()% 25;
    
    if (x < 5) {
        SKSpriteNode *bonus = [SKSpriteNode spriteNodeWithImageNamed:@"bonus2x"];
        bonus.name = @"2x";
        bonus.position = posicao;
        bonus.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bonus.size];
        //bonus.physicsBody.dynamic = NO;
        bonus.physicsBody.categoryBitMask = categoriaBonus;
        bonus.physicsBody.contactTestBitMask = categoriaBordaInferior | categoriaPalheta;
        bonus.physicsBody.collisionBitMask = categoriaPalheta;
        bonus.physicsBody.dynamic = YES;
        
        
        [bonus runAction:[SKAction moveToY:-300 duration:1.5]];
        
        [self addChild:bonus];
        [bonus.physicsBody applyImpulse:CGVectorMake(-300.0f, 300.0f)];
        
        
        
    }else if (x < 8){
        SKSpriteNode *bonus = [SKSpriteNode spriteNodeWithImageNamed:@"vida2"];
        bonus.name = @"vida";
        bonus.size = CGSizeMake(70, 70);
        bonus.position = posicao;
        bonus.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bonus.size];
        //bonus.physicsBody.dynamic = NO;
        bonus.physicsBody.categoryBitMask = categoriaBonus;
        bonus.physicsBody.contactTestBitMask = categoriaBonus | categoriaPalheta;
        bonus.physicsBody.collisionBitMask = categoriaPalheta;
        bonus.physicsBody.dynamic = YES;
        
        
        [bonus runAction:[SKAction moveToY:-300 duration:1.5]];
        
        [self addChild:bonus];
        [bonus.physicsBody applyImpulse:CGVectorMake(-300.0f, 300.0f)];
        

    }else if (x < 13){
        SKSpriteNode *bonus = [SKSpriteNode spriteNodeWithImageNamed:@"morre"];
        bonus.name = @"morre";
        bonus.size = CGSizeMake(70, 70);
        bonus.position = posicao;
        bonus.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bonus.size];
       // bonus.physicsBody.dynamic = NO;
        bonus.physicsBody.categoryBitMask = categoriaBonus;
        bonus.physicsBody.contactTestBitMask = categoriaBonus | categoriaPalheta;
        bonus.physicsBody.collisionBitMask = categoriaPalheta;
        bonus.physicsBody.dynamic = YES;
        
        
        [bonus runAction:[SKAction moveToY:-100 duration:1.5]];
        
        [self addChild:bonus];
        [bonus.physicsBody applyImpulse:CGVectorMake(-200.0f, 300.0f)];
    }else if (x < 17){
        SKSpriteNode *bonus = [SKSpriteNode spriteNodeWithImageNamed:@"velocidade.jpg"];
        bonus.name = @"velocidade";
        bonus.position = posicao;
        bonus.size = CGSizeMake(70, 70);
        bonus.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bonus.size];
        //bonus.physicsBody.dynamic = NO;
        bonus.physicsBody.categoryBitMask = categoriaBonus;
        bonus.physicsBody.contactTestBitMask = categoriaBonus | categoriaPalheta;
        bonus.physicsBody.collisionBitMask = categoriaPalheta;
        bonus.physicsBody.dynamic = YES;
        
        
        [bonus runAction:[SKAction moveToY:-200 duration:1.5]];
        
        [self addChild:bonus];
        [bonus.physicsBody applyImpulse:CGVectorMake(-300.0f, 300.0f)];
    }else if (x < 21){
        SKSpriteNode *bonus = [SKSpriteNode spriteNodeWithImageNamed:@"super.png"];
        bonus.name = @"super";
        bonus.position = posicao;
        bonus.size = CGSizeMake(70, 70);
        bonus.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bonus.size];
        //bonus.physicsBody.dynamic = NO;
        bonus.physicsBody.categoryBitMask = categoriaBonus;
        bonus.physicsBody.contactTestBitMask = categoriaBonus | categoriaPalheta;
        bonus.physicsBody.collisionBitMask = categoriaPalheta;
        bonus.physicsBody.dynamic = YES;
        
        //NSLog(@"chamou super");
        
        [bonus runAction:[SKAction moveToY:-300 duration:1.5]];
        
        [self addChild:bonus];
        [bonus.physicsBody applyImpulse:CGVectorMake(-300.0f, 300.0f)];
    }else{
        SKSpriteNode *bonus = [SKSpriteNode spriteNodeWithImageNamed:@"tiro.png"];
        bonus.name = @"atirar";
        bonus.position = posicao;
        bonus.size = CGSizeMake(70, 70);
        bonus.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bonus.size];
        //bonus.physicsBody.dynamic = NO;
        bonus.physicsBody.categoryBitMask = categoriaBonus;
        bonus.physicsBody.contactTestBitMask = categoriaBonus | categoriaPalheta;
        bonus.physicsBody.collisionBitMask = categoriaPalheta;
        bonus.physicsBody.dynamic = YES;
        
       // NSLog(@"chamou euFrazino");
        
        [bonus runAction:[SKAction moveToY:-300 duration:1.5]];
        
        [self addChild:bonus];
        [bonus.physicsBody applyImpulse:CGVectorMake(-300.0f, 300.0f)];
    }
    
}

- (void)zeraRepetidorTempo{
    if (self.tempo) {
        [self.tempo invalidate];
        self.tempo = nil;
    }
}

- (void)controlaTempo{
    
    self.tempoCorrido -= 1;
   
    

    [self performSelectorOnMainThread:@selector(escreveTela) withObject: nil waitUntilDone:YES];
    
}

- (void)escreveTela{
    
    int minutos = self.tempoCorrido / 60;
    
    int segundos = self.tempoCorrido - minutos * 60;
    
    if (segundos < 10) {
        [self.lblTempo setText:[NSString stringWithFormat:@"%d : 0%d",minutos, segundos]];
    }else{
        [self.lblTempo setText:[NSString stringWithFormat: @"%d : %d",minutos,segundos ]];
    }
    
    
    if ([self tempoCorrido] <= 0) {
        [self zeraRepetidorTempo];
        [self youLose];
    }else if (self.tempoCorrido <= 10){
        self.lblTempo.fontColor = [SKColor colorWithRed:0.8 green:0 blue:0 alpha:1];
    }else{
        self.lblTempo.fontColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:1];
    }

}
@end
