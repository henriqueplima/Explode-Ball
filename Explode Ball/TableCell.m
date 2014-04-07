//
//  TableCell.m
//  Explode Ball
//
//  Created by MARCOS VINICIUS SOUZA LACERDA on 31/03/14.
//  Copyright (c) 2014 HENRIQUE PEREIRA DE LIMA. All rights reserved.
//

#import "TableCell.h"

@implementation TableCell
@synthesize lbNome = _lbNome;
@synthesize lbPontos = _lbPontos;
@synthesize foto = _foto;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
