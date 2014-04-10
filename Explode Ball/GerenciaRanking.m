//
//  GerenciaRanking.m
//  Explode Ball
//
//  Created by MARCOS VINICIUS SOUZA LACERDA on 28/03/14.
//  Copyright (c) 2014 HENRIQUE PEREIRA DE LIMA. All rights reserved.
//

#import "GerenciaRanking.h"
#import "TableCell.h"

@interface GerenciaRanking ()

@end

@implementation GerenciaRanking
@synthesize pontos;
@synthesize nomes;
@synthesize ponto;
@synthesize path;
@synthesize dictionary;
@synthesize documentsPath;
@synthesize filePath;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self refresh];
    [self ordenarVetor];
    
    [self.tableView reloadData];
    
    
}
-(id)init
{
    self = [super init];
    if (self)
    {
        
        [self refresh];
        
    }
    
    return self;
}

+ (GerenciaRanking *)compartilharGerenciador
{
    static GerenciaRanking *gerenciadorCompartilhado = nil;
    
    if (!gerenciadorCompartilhado)
    {
        gerenciadorCompartilhado = [[super allocWithZone:nil] init];
    }
    return gerenciadorCompartilhado;
}


+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self compartilharGerenciador];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.auxNomes count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    self.btnVoltar = [[UIButton alloc]initWithFrame:CGRectMake(10,20,64,64)];
    self.btnVoltar.layer.cornerRadius = self.btnVoltar.bounds.size.width / 2.0;
    [self.btnVoltar setBackgroundImage:[UIImage imageNamed:@"btnVoltar"] forState:UIControlStateNormal];
    [self.btnVoltar addTarget:self action:@selector(actionBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:self.btnVoltar];
    return footerView;
}

-(void)actionBtn
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableCell  = @"TableCell";
    
    
    
    TableCell *cell = (TableCell *)[tableView dequeueReusableCellWithIdentifier:tableCell];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    cell.textNome.font = [UIFont fontWithName:@"Feast of Flesh BB" size:20.0];
    cell.textNome.text = [self.auxNomes objectAtIndex:indexPath.row];
    cell.textPontos.font = [UIFont fontWithName:@"Feast of Flesh BB" size:20.0];
    if ([self.ponto count] > 0)
    {
        cell.textPontos.text = [self.auxPontos objectAtIndex:indexPath.row];
    }
    
    cell.foto.layer.borderColor = [UIColor blackColor].CGColor;
    cell.foto.layer.borderWidth = 2.0f;
    cell.foto.layer.cornerRadius = CGRectGetWidth(cell.foto.bounds)/2.0f;
    cell.foto.layer.masksToBounds = YES;
    cell.foto.image = [UIImage imageNamed:@"avatar"];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //1. Configura a estrutura CATransform3D
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    
    
    //2. Define o estado inicial  (antes da animação)
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    cell.layer.transform = rotation;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    
    //3. Define o estado final (após a animação) 
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
    
}

- (void)writeToPlist:(NSString *)nome : (NSString *)pontuacao

{
    NSMutableDictionary *plistDictionary;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:filePath])
    {
        NSLog(@" O Arquivo Existe - Leitura");
        plistDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
        
        [[plistDictionary objectForKey:@"Nome"] addObject:nome];
        [[plistDictionary objectForKey:@"Pontos"] addObject:pontuacao];
        [plistDictionary writeToFile:filePath atomically:YES];
        
        
    }
    else
    {
        NSLog(@" O Arquivo Não Existe - Criar");
        
    }
}

-(void)refresh
{
    self.path =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
    self.documentsPath = [self.path objectAtIndex:0];
    self.filePath = [documentsPath stringByAppendingPathComponent:@"novoRanking.plist"];
    
    self.dictionary = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    
    self.nomes = [[NSMutableArray alloc]init];
    self.ponto = [[NSMutableArray alloc]init];
    
    self.nomes = [self.dictionary objectForKey:@"Nome"];
    self.ponto = [self.dictionary objectForKey:@"Pontos"];
    
}

- (void)ordenarVetor
{
    self.auxPontos = [[NSMutableArray alloc] init];
    self.auxPontos = [self.ponto mutableCopy] ;
    
    self.auxNomes = [[NSMutableArray alloc] init];
    self.auxNomes = [self.nomes mutableCopy] ;
    
    while (TRUE)
    {
        
        BOOL hasSwapped = NO;
        
        for (int i=0; i<self.auxPontos.count; i++)
        {
            
            
            if (i < self.auxPontos.count-1)
            {
                
                NSUInteger currentIndexValue = [self.auxPontos[i] intValue];
                NSUInteger nextIndexValue    = [self.auxPontos[i+1] intValue];
                
                if (currentIndexValue < nextIndexValue)
                {
                    hasSwapped = YES;
                    [self swapFirstIndex:i withSecondIndex:i+1 inMutableArray:self.auxPontos];
                    [self swapFirstIndex:i withSecondIndex:i+1 inMutableArray:self.auxNomes];
                }
            }
            
        }
        
        
        if (!hasSwapped)
        {
            break;
        }
        
    }
    
    
}

-(void)swapFirstIndex:(NSUInteger)firstIndex withSecondIndex:(NSUInteger)secondIndex inMutableArray:(NSMutableArray*)array{
    
    NSNumber* valueAtFirstIndex = array[firstIndex];
    NSNumber* valueAtSecondIndex = array[secondIndex];
    
    [array replaceObjectAtIndex:firstIndex withObject:valueAtSecondIndex];
    [array replaceObjectAtIndex:secondIndex withObject:valueAtFirstIndex];
}


@end
