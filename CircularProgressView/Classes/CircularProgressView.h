//
//  CircularProgressView.h
//  Beatsnap
//
//  Created by Martin Mlostek on 25.01.16.
//  Copyright © 2016 Nomad5. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface CircularProgressView : UIView

    @property(nonatomic) IBInspectable CGFloat         borderOffset;
    @property(nonatomic) IBInspectable UIColor         *progressColor;
    @property(nonatomic) IBInspectable NSString        *progressText;
    @property(nonatomic) IBInspectable int             progressTextSize;
    @property(nonatomic, readonly) IBInspectable float progress;
    @property(nonatomic) IBInspectable NSString        *progressFont;

    // set the progress
    - (void)setProgress:(float)progress animated:(bool)animated;
@end
