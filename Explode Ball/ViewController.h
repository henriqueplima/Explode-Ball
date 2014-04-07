//
//  ViewController.h
//  Explode Ball
//

//  Copyright (c) 2014 HENRIQUE PEREIRA DE LIMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "GerenciaRanking.h"
#import "GerenciadorJogo.h"
#import "Perdeu.h"

@interface ViewController : UIViewController<UITextFieldDelegate>

@property NSString *documentsPath;
@property NSString *filePath;
@property NSArray *path;
@property NSFileManager *fileManager;

@property SKView * skView;
@property (weak, nonatomic) IBOutlet UIButton *btnJogar;
@property (weak, nonatomic) IBOutlet UITextField *txfNome;
@property (weak, nonatomic) IBOutlet UIButton *btnIniciar;
@property GerenciaRanking *ranking;
- (IBAction)btnIniciar:(id)sender;



@property (weak, nonatomic) IBOutlet UIButton *btnRaking;

- (IBAction)btnJogar:(id)sender;
+ (ViewController *)sharedViewController;
+ (id)allocWithZone:(struct _NSZone *)zone;
- (void)voltar;
- (void)habilitarObjetos;
-(void)desabilitaObjetos;
- (void)CenaYouLose;
- (void)voltarMenuPrincipal;
-(void)criaPlist;

@end
