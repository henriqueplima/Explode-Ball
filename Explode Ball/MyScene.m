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
        self.backgroundColor = [SKColor blackColor];
        
        // Gravidade do Jogo
        [self.physicsWorld setGravity:CGVectorMake(0, -5)];
        self.physicsWorld.contactDelegate = self;
        
        
        //criando bordas laterais
        //SKPhysicsBody* bordasLaterais = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        bordas = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, 0, self.size.width, self.size.height)];
        self.physicsBody = bordas;
        self.physicsBody.friction = 0.0f;
        
        //cria os demais nos da cena
        
        [self criarObjetos];
        
        
        //Montar Fase
        
        [self montarFase];
        
        [self iniciaRodada];
        
        
        
        //inicializa acelerometro

        
        //motionManager = [[CMMotionManager alloc]init];
        //[self inicializaAcelerometro];
        
    }
    return self;
}

- (void)inicializaAcelerometro{
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
    
    self.gerenciadorJogo.totalBlocos = [self.gerenciadorJogo.faseMenu constroiFases:self.gerenciadorJogo.Fase :self.size];
    
    for (int i = 0; i < self.gerenciadorJogo.totalBlocos.count; i++) {
        [self addChild:[self.gerenciadorJogo.totalBlocos objectAtIndex:i]  ];
    }

    [self.gerenciadorJogo preparaPlayerPrincipal:1];
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
    spritePalheta = [SKSpriteNode spriteNodeWithImageNamed:@"barrinha"];
    self.gerenciadorJogo.tamanhoOriginalPalheta = CGSizeMake(self.size.width * 0.15, self.size.height * 0.02);
    [spritePalheta setSize:self.gerenciadorJogo.tamanhoOriginalPalheta];
    spritePalheta.name = @"Palheta";
    spritePalheta.position = CGPointMake(self.size.width/2, self.size.height * 0.05);
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
    bordaInferior.physicsBody.categoryBitMask = categoriaBordaInferior | categoriaBola | categoriaBonus;
    //bordaInferior
    [self addChild:bordaInferior];

    
    //[self criarPalhetaBola];

    
    self.gerenciadorJogo.comecou = NO;
    
    
    //cria Labels
    self.lblVida = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    [self.lblVida setText:[NSString stringWithFormat:@"%d",self.gerenciadorJogo.vida]];
    self.lblVida.position = CGPointMake(self.frame.size.width * 0.9, self.size.height * 0.9);
    self.lblVida.fontSize = 70;
    
    self.lblPontos = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    [self.lblPontos setText:[NSString stringWithFormat:@"%d", self.gerenciadorJogo.pontos]];
    self.lblPontos.position = CGPointMake(self.frame.size.width * 0.1, self.size.height * 0.9);
    self.lblPontos.fontSize = 65;
    
    [self addChild:self.lblVida];
    [self addChild:self.lblPontos];
    
    
}


- (void)atualizaPosicaoAcelerometro{
    CMAccelerometerData* data = motionManager.accelerometerData;
    
    if (fabs(data.acceleration.y) > 0.2) {
         NSLog(@"acceleration value = %f",data.acceleration.y);
        float teste = 80.0 * data.acceleration.y;
        teste *= -1;
        [spritePalheta.physicsBody applyForce:CGVectorMake(teste, 0.0)];
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
    CGPoint touchLocation = [touch locationInNode:self];
    
    //SKPhysicsBody* body = [self.physicsWorld bodyAtPoint:touchLocation];
//    if (body && [body.node.name isEqualToString: @"Palheta"])
//    {
        //NSLog(@"Began touch on paddle");
        self.touchPalheta = YES;
   // }
    
    if ([touch tapCount ] == 2)
    {
        
        if (!self.gerenciadorJogo.comecou) {
            [spriteBola.physicsBody applyImpulse:CGVectorMake(5.0f,5.0f)];
            //self.gerenciadorJogo.velocidadeAtual = spriteBola.physicsBody.velocity;
            [self.physicsWorld removeAllJoints];
            self.gerenciadorJogo.comecou = YES;
        }
        
    }
    if (self.gerenciadorJogo.tiro) {
        [self criaTiro];
    }
    
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

- (void)encerraRodada{
    
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
}

- (void)didBeginContact:(SKPhysicsContact *)contact{
    SKPhysicsBody *first, *second;
    
    first = contact.bodyA;
    second = contact.bodyB;
    
    
    //NSLog(@"primeiro : %@ segundo : %@",first.node.name,second.node.name);
    
    
    //Tiro
    
    if (second.categoryBitMask == categoriaTiro && [first.node.name isEqualToString:@"Bloco"]) {
        
        if (first.categoryBitMask == categoriaBLocoInquebravel) {
            [self removeCorpo:second];
        }else{
            [self removeCorpo:second];
            [self removeCorpo:first];
        }
        
    }else if (first.categoryBitMask == categoriaTiro && [second.node.name isEqualToString:@"Bloco"]){
        if (second.categoryBitMask == categoriaBLocoInquebravel) {
            [self removeCorpo:first];
        }else{
            [self removeCorpo:second];
            [self removeCorpo:first];
        }
    }
       
    //contato Palheta e bola
    if ([first.node.name isEqualToString:@"Palheta"] && [second.node.name isEqualToString:@"Bola"]) {
        float palheta = first.node.position.x;
        float bola = second.node.position.x;
        bola = bola / 10;
        palheta = palheta / 10;
        float teste = bola - palheta;
        //if (teste == 0) {
           // NSLog(@"valor do impulso: %f",teste);
            [second applyImpulse:CGVectorMake(0, 0)];
            [second applyImpulse:CGVectorMake(teste, 1.5f)];
        
    
        
    }
    //Contato Borda Inferior e Bola
   
    if ([first.node.name isEqualToString:@"BordaInferior"] && [second.node.name isEqualToString:@"Bola"]) {
        
        [self encerraRodada];
        
        //Contato bloco e Bola
    }else if ([first.node.name isEqualToString:@"Bloco"] && [second.node.name isEqualToString:@"Bola"]){
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
        }
        
        
    }
    
    
    if (first.categoryBitMask == categoriaBonus && [second.node.name isEqualToString:@"Palheta"]) {
        
        
        
        
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
        
        
        NSLog(@"passou de novo");
        
    }
    
    
    if (first.contactTestBitMask == categoriaBonus && [second.node.name isEqualToString:@"BordaInferior"]) {
        [self removeCorpo:first];
    }else if (second.contactTestBitMask == categoriaBonus && [first.node.name isEqualToString:@"BordaInferior"]){
        [self removeCorpo:second];
    }
    
}

- (void)Ganhou{
    if (self.gerenciadorJogo.faseMenu.nBlocosQuebraveis < 1) {
        self.gerenciadorJogo.Fase += 1;
        if (self.gerenciadorJogo.Fase > self.gerenciadorJogo.nFases) {
            [self.gerenciadorJogo preparaPlayerPrincipal:2];
            self.gerenciadorJogo.fraseFinal = @"Você Ganhou";
            ViewController *menuPrincipal = [ViewController sharedViewController];
            [menuPrincipal CenaYouLose];
        }else{
            [self removeAllChildren];
            [self montarFase];
            [self criarObjetos];
            [self iniciaRodada];
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
 
    //[self atualizaPosicaoAcelerometro];
    /* Called before each frame is rendered */
    SKNode* ball = [self childNodeWithName: @"Bola"];
    static int maxSpeed = 500;
    
    if (self.gerenciadorJogo.velocidadeMax) {
        maxSpeed = 700;
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
        SKSpriteNode *bonus = [SKSpriteNode spriteNodeWithImageNamed:@"super.jpg"];
        bonus.name = @"super";
        bonus.position = posicao;
        bonus.size = CGSizeMake(70, 70);
        bonus.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bonus.size];
        //bonus.physicsBody.dynamic = NO;
        bonus.physicsBody.categoryBitMask = categoriaBonus;
        bonus.physicsBody.contactTestBitMask = categoriaBonus | categoriaPalheta;
        bonus.physicsBody.collisionBitMask = categoriaPalheta;
        bonus.physicsBody.dynamic = YES;
        
        NSLog(@"chamou super");
        
        [bonus runAction:[SKAction moveToY:-300 duration:1.5]];
        
        [self addChild:bonus];
        [bonus.physicsBody applyImpulse:CGVectorMake(-300.0f, 300.0f)];
    }else{
        SKSpriteNode *bonus = [SKSpriteNode spriteNodeWithImageNamed:@"eufrazino2.jpg"];
        bonus.name = @"atirar";
        bonus.position = posicao;
        bonus.size = CGSizeMake(70, 70);
        bonus.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bonus.size];
        //bonus.physicsBody.dynamic = NO;
        bonus.physicsBody.categoryBitMask = categoriaBonus;
        bonus.physicsBody.contactTestBitMask = categoriaBonus | categoriaPalheta;
        bonus.physicsBody.collisionBitMask = categoriaPalheta;
        bonus.physicsBody.dynamic = YES;
        
        NSLog(@"chamou euFrazino");
        
        [bonus runAction:[SKAction moveToY:-300 duration:1.5]];
        
        [self addChild:bonus];
        [bonus.physicsBody applyImpulse:CGVectorMake(-300.0f, 300.0f)];
    }
    
    
    
    
}
@end
