//
// Created by Martin Mlostek on 26.01.16.
// Copyright (c) 2016 Nomad5. All rights reserved.
//

#import "ValueAnimation.h"

// Number of seconds between each animation step
#define kStepSize 0.025

@implementation ValueAnimation
    {
        NSTimer          *timer;
        NSUInteger       totalRunTime;    // Total duration of the animation (delay not included)
        NSUInteger       currentRuntime;  // Time the animation is already running
        MyAnimationBlock animationBlock;
    }

    /**
     * Start the animation
     */
    - (void)startAnimation:(MyAnimationBlock)block runtime:(NSUInteger)runtime delay:(double)delay
    {
        if(timer != nil)
        {
            [timer invalidate];
        }

        timer          = nil;
        totalRunTime   = runtime;
        animationBlock = block;
        currentRuntime = 0;

        if(block != nil)
        {
            if(delay > 0)
            {
                // Wait to delay the start. Convert delay from millis to seconds
                double delaySeconds = delay / 1000.0;
                timer = [NSTimer scheduledTimerWithTimeInterval:delaySeconds
                                 target:self
                                 selector:@selector(delayTick:)
                                 userInfo:nil
                                 repeats:false];
            }
            else
            {
                // Run the animation
                timer = [NSTimer scheduledTimerWithTimeInterval:kStepSize
                                 target:self
                                 selector:@selector(animationTick:)
                                 userInfo:nil
                                 repeats:true];
            }
        }
    }

    /**
     * One delay tick
     */
    - (void)delayTick:(NSTimer *)delayTimer
    {
        // End of delay -> run animation
        [delayTimer invalidate];
        timer = [NSTimer scheduledTimerWithTimeInterval:kStepSize
                         target:self
                         selector:@selector(animationTick:)
                         userInfo:nil
                         repeats:true];
    }

    /**
     * One animation tick
     */
    - (void)animationTick:(NSTimer *)animationTimer
    {
        NSUInteger step = (NSUInteger) (1000 * kStepSize);  // step size/length in milli seconds
        currentRuntime += step;
        double progress = MIN((double) currentRuntime / (double) totalRunTime, 1.0);

        // Progress is a value between 0 and 1. The easing function maps this
        // to the animationValue which is than used inside the animationBlock
        // to calculate the current value of the animation
        double animationValue = [self customEaseOut:progress];
        if(animationBlock != nil)
        {
            animationBlock(animationValue);
        }
        if(progress >= 1.0)
        {
            // Animation complete
            [timer invalidate];
            timer = nil;
        }
    }

    /**
     * Ease out animation
     */
    - (double)customEaseOut:(double)t
    {
        // Use any easing function you like to animate your values...
        // http://rechneronline.de/function-graphs/
        // http://sol.gfxile.net/interpolation/
        return (1 - pow(1 - t, 2));
    }
@end