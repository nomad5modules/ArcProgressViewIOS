////
////  CircularProgressView.m
////  Beatsnap
////
////  Created by Martin Mlostek on 25.01.16.
////  Copyright © 2016 Nomad5. All rights reserved.
////
//
//#import "CircularProgressView.h"
//#import "ValueAnimation.h"
////#import "Globals.h"
//
//#define DEG2RAD(angle)    ((angle)   /  180.0 * M_PI)
//#define THRESHOLD         0.01f
//#define UPPER_BOUND       0.9999999f
//#define PROGRESS_ANIMATION                          300
//
//@implementation CircularProgressView22
//    {
//        UIFont         *font;
//        NSDictionary   *attributes;
//        CGSize         textSize;
//        ValueAnimation22 *animation;
//    }
//
//    /**
//     * Default construction
//     */
//    - (instancetype)initWithFrame:(CGRect)frame
//    {
//        self = [super initWithFrame:frame];
//        if(self)
//        {
//            self.alpha = 0;
//        }
//
//        return self;
//    }
//
//    /**
//     * Default construction
//     */
//    - (instancetype)initWithCoder:(NSCoder *)coder
//    {
//        self = [super initWithCoder:coder];
//        if(self)
//        {
//            self.alpha = 0;
//        }
//
//        return self;
//    }
//
//    /**
//     * Set the progress
//     */
//    - (void)setProgress:(float)progress animated:(bool)animated
//    {
//        double delaySec = 0.0;
//        if((_progress > 0.0f && progress <= 0.0f) ||
//           (_progress < UPPER_BOUND && progress >= 1.0f))
//        {
//            // fade out
//            [UIView beginAnimations:nil context:nil];
//            [UIView setAnimationDuration:1.0f];
//            [UIView setAnimationDelay:(animated ? (PROGRESS_ANIMATION / 1000.0f) : 0.0f)];
//            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
//            self.alpha = 0.0f;
//            [UIView commitAnimations];
//        }
//        else if((_progress <= 0 && progress > 0.0f) ||
//                (_progress >= UPPER_BOUND && progress < 1.0f))
//        {
//            // fade in
//            [UIView beginAnimations:nil context:nil];
//            [UIView setAnimationDuration:1.0f];
//            [UIView setAnimationDelay:0.0f];
//            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
//            self.alpha = 1.0f;
//            [UIView commitAnimations];
//            delaySec = 1.0;
//        }
//        // set the progress
//        if(animated)
//        {
//            [self animateProgressFrom:_progress to:MIN(UPPER_BOUND, MAX(0, progress)) delay:delaySec];
//        }
//        else
//        {
//            // this is direct setting
//            _progress = MIN(UPPER_BOUND, MAX(0, progress));
//            [self setNeedsDisplay];
//        }
//    }
//
//    /**
//     * Animate the progress from to
//     */
//    - (void)animateProgressFrom:(float)fromValue to:(float)toValue delay:(double)delaySec
//    {
//        if(animation == nil)
//        {
//            animation = [[ValueAnimation22 alloc] init];
//        }
//        MyAnimationBlock animationBlock = ^(double animationValue)
//        {
//            float currentValue = fromValue + ((toValue - fromValue) * (float) animationValue);
//            self->_progress          = currentValue;
//            [self setNeedsDisplay];
//        };
//        [animation startAnimation:animationBlock runtime:PROGRESS_ANIMATION delay:delaySec];
//    }
//
//    /**
//     * Prepare the values for rendering
//     */
//    - (void)prepare
//    {
//        if(font == nil &&_progressFont != nil && _progressText != nil && _progressTextSize > 0)
//        {
//            font = [UIFont fontWithName:_progressFont size:_progressTextSize];
//            // paragraph for both
//            NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
//            paragraphStyle.alignment     = NSTextAlignmentCenter;
//            // attributes for back
//            attributes = @{NSFontAttributeName            : font,
//                           NSForegroundColorAttributeName : _progressColor,
//                           NSParagraphStyleAttributeName  : paragraphStyle};
//            textSize   = [_progressText sizeWithAttributes:attributes];
//            // reduce font size until the text fits in bounds
//            while(textSize.width > self.bounds.size.width * 0.9f || textSize.height > self.bounds.size.height * 0.9f)
//            {
//                _progressTextSize--;
//                font       = [font fontWithSize:_progressTextSize];
//                attributes = @{NSFontAttributeName            : font,
//                               NSForegroundColorAttributeName : _progressColor,
//                               NSParagraphStyleAttributeName  : paragraphStyle};
//                textSize   = [_progressText sizeWithAttributes:attributes];
//            }
//        }
//    }
//
//    /**
//     * Where the magic happens
//     */
//    - (void)__unused drawRect:(CGRect)rect
//    {
//        CGContextRef context;
//        [self prepare];
//        if(!font || !attributes || !_progressColor)
//        {
//            context = UIGraphicsGetCurrentContext();
//            [[UIColor clearColor] setFill];
//            UIRectFill(rect);
//            CGContextFillPath(context);
//            return;
//        }
//        float   angle     = (float) (-M_PI_2 + DEG2RAD(_progress * 360.0f));
//        float   piHalfNeg = (float) -M_PI_2;
//        float   x         = self.bounds.size.width / 2.0f;
//        float   y         = self.bounds.size.height / 2.0f;
//        // calculate rect
//        CGRect  textRect  = CGRectMake(rect.origin.x + floorf((rect.size.width - textSize.width) / 2),
//                                       rect.origin.y + floorf((rect.size.height - textSize.height) / 2),
//                                       ceilf(textSize.width),
//                                       ceilf(textSize.height));
//        // get offset
//        CGFloat size      = MAX(rect.size.width, rect.size.height) + _borderOffset;
//        ///////////////////////////////////////////////// BACKGROUND IMAGE
//        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0f);
//        context = UIGraphicsGetCurrentContext();
//        [_progressColor setFill];
//        UIRectFill(rect);
//        CGContextSetBlendMode(context, kCGBlendModeDestinationOut);
//        [_progressText drawInRect:textRect withAttributes:attributes];
//        CGContextBeginPath(context);
//        CGContextSetFillColorWithColor(context, _progressColor.CGColor);
//        CGContextMoveToPoint(context, x, y);
//        CGContextAddArc(context, x, y, size, piHalfNeg, angle, true);
//        CGContextClosePath(context);
//        CGContextFillPath(context);
//        UIImage *backImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//
//        ///////////////////////////////////////////////// FOREGROUND IMAGE
//        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0f);
//        context = UIGraphicsGetCurrentContext();
//        [[UIColor clearColor] setFill];
//        UIRectFill(rect);
//        CGContextSetBlendMode(context, kCGBlendModeNormal);
//        [_progressText drawInRect:textRect withAttributes:attributes];
//        CGContextSetBlendMode(context, kCGBlendModeDestinationOut);
//        CGContextBeginPath(context);
//        CGContextSetFillColorWithColor(context, _progressColor.CGColor);
//        CGContextMoveToPoint(context, x, y);
//        CGContextAddArc(context, x, y, size, angle, piHalfNeg, true);
//        CGContextClosePath(context);
//        CGContextFillPath(context);
//        CGContextSetBlendMode(context, kCGBlendModeNormal);
//        UIImage *frontImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//
//        ///////////////////////////////////////////////// COMPOSE
//        if(_progress >= THRESHOLD)
//        {
//            [backImage drawAtPoint:CGPointMake(0, 0)];
//        }
//        [frontImage drawAtPoint:CGPointMake(0, 0)];
//    }
//@end
