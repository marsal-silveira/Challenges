//
//  DGLabel.m
//  Dogo
//
//  Created by Marsal on 04/09/15.
//  Copyright (c) 2015 Marsal Silveira. All rights reserved.
//

#import "DGLabel.h"

@implementation DGLabel

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    
    // If this is a multiline label, need to make sure preferredMaxLayoutWidth always matches the frame width (i.e. orientation change can mess this up)
    if (self.numberOfLines == 0 && bounds.size.width != self.preferredMaxLayoutWidth) {
        self.preferredMaxLayoutWidth = self.bounds.size.width;
        [self setNeedsUpdateConstraints];
    }
}

@end