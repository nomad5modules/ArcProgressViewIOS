//
// Created by Martin Mlostek on 26.01.16.
// Copyright (c) 2016 Nomad5. All rights reserved.
//

#import <Foundation/Foundation.h>

// the callback function
typedef void (^MyAnimationBlock)(double animationValue);

/**
 * The Animator class
 */
@interface ValueAnimation : NSObject

    // simple start animation
    - (void)startAnimation:(MyAnimationBlock)animationBlock runtime:(NSUInteger)runtime delay:(double)delay;

@end