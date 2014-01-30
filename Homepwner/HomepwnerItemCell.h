//
//  HomepwnerItemCell.h
//  Homepwner
//
//  Created by Richard Fox on 1/14/14.
//  Copyright (c) 2014 Richard Fox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomepwnerItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;




@end
