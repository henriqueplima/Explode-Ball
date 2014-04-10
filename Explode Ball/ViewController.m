//
//  ViewController.m
//  Explode Ball
//
//  Created by HENRIQUE PEREIRA DE LIMA on 27/03/14.
//  Copyright (c) 2014 HENRIQUE PEREIRA DE LIMA. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"

@implementation ViewController
@synthesize ranking;
@synthesize documentsPath;
@synthesize filePath;
@synthesize path;
@synthesize fileManager;
+ (ViewController *)sharedViewController{
    static ViewController *sharedViewController;
    if (!sharedViewController)
    {
        sharedViewController = [[super allocWithZone:nil]init];
    }
    
    return sharedViewController;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedViewController];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.background.image = [UIImage imageNamed:@"02.jpg"];
    
    self.path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                    NSUserDomainMask, YES);
    self.documentsPath = [path objectAtIndex:0];
    
    self.filePath = [documentsPath stringByAppendingPathComponent:@"novoRanking.plist"];
    
    self.fileManager = [NSFileManager defaultManager];
    
    [self criaPlist];
    
    self.txfNome.delegate = self;
    self.txfNome.alpha = 0;
    self.btnIniciar.alpha = 0;
    
    //Propriedades do Botão Jogar
    self.btnJogar.titleLabel.font = [UIFont fontWithName:@"Feast of Flesh BB" size:60.0];
    self.btnJogar.titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.btnJogar.titleLabel.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    self.btnJogar.titleLabel.layer.shadowOpacity = 1.0f;
    self.btnJogar.titleLabel.layer.shadowRadius = 1.0f;
    
    
    //Propriedade do Botão Ranking
    self.btnRaking.titleLabel.font = [UIFont fontWithName:@"Feast of Flesh BB" size:60.0];
    self.btnRaking.titleLabel.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    self.btnRaking.titleLabel.layer.shadowOpacity = 1.0f;
    self.btnRaking.titleLabel.layer.shadowRadius = 1.0f;
    
    //Propriedade TextField Nome
    self.txfNome.layer.borderColor = [UIColor blackColor].CGColor;
    self.txfNome.layer.borderWidth = 3.0;
    
    //Propriedade Botão Iniciar
    self.btnIniciar.layer.cornerRadius = self.btnIniciar.bounds.size.width / 2.0;
    [self.btnIniciar setBackgroundImage:[UIImage imageNamed:@"btnIniciar"] forState:UIControlStateNormal];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)btnJogar:(id)sender
{
   
    [self habilitarObjetos];
    
}

- (void)voltar
{
  [self.skView presentScene:nil];
}

-(void)desabilitaObjetos
{
    self.btnJogar.alpha = 0;
    self.txfNome.alpha = 0;
    self.btnRaking.alpha = 0;
    self.btnIniciar.alpha = 0;
    self.background.alpha = 0;
    
}

-(void)habilitarObjetos
{
    self.btnJogar.alpha = 1;
    self.txfNome.alpha = 1;
    self.txfNome.text = @"";
    self.btnRaking.alpha = 1;
    self.btnIniciar.alpha = 1;
    self.background.alpha = 1;
}

- (IBAction)btnIniciar:(id)sender
{
    
    [self desabilitaObjetos];
    

    GerenciadorJogo *gerenciadorJogo = [GerenciadorJogo compartilharGerenciador];
    gerenciadorJogo.nome = self.txfNome.text;
    if ([gerenciadorJogo.nome isEqualToString:@""]) {
        gerenciadorJogo.nome = @"anonimo";
    }
    
    // Configure the view.
    self.skView = (SKView *)self.view;
    self.skView.showsFPS = YES;
    self.skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [MyScene sceneWithSize:self.skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [self.skView presentScene:scene];
    [self.txfNome resignFirstResponder];
    
}
- (void)CenaYouLose{
    self.skView = (SKView *)self.view;
    self.skView.showsFPS = YES;
    self.skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [Perdeu sceneWithSize:self.skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [self.skView presentScene:scene];

}

- (void)voltarMenuPrincipal{
    [self.skView presentScene:nil];
    [self habilitarObjetos];
}
-(void)criaPlist
{
    
    if (![self.fileManager fileExistsAtPath:filePath])
    {
        NSString * pathBundle = [[NSBundle mainBundle] pathForResource:@"novoRanking" ofType:@"plist"];
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:pathBundle];
        
        [dic writeToFile:filePath atomically:YES];
    }
    
}

@end
