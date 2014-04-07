//
//  TableCell.h
//  Explode Ball
//
//  Created by MARCOS VINICIUS SOUZA LACERDA on 31/03/14.
//  Copyright (c) 2014 HENRIQUE PEREIRA DE LIMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbNome;
@property (weak, nonatomic) IBOutlet UILabel *lbPontos;
@property (weak, nonatomic) IBOutlet UIImageView *foto;
@property (weak, nonatomic) IBOutlet UILabel *textNome;
@property (weak, nonatomic) IBOutlet UILabel *textPontos;

@end
