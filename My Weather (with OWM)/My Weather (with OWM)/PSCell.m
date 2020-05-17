//
//  PSCell.m
//  My Weather (with OWM)
//
//  Created by Павел Спицин on 21.11.19.
//  Copyright © 2019 Павел Спицин. All rights reserved.
//

#import "PSCell.h"

@implementation PSCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.activityIndicator.hidesWhenStopped = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
