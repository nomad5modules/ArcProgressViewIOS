// Copyright (c) 2019 Nomad5. All rights reserved.

import Foundation

// Number of seconds between each animation step
let kStepSize = 0.015

typealias MyAnimationBlock = (Double) -> Void

/// Animate over a given time
class ValueAnimation {
    private var timer:          Timer?
    private var totalRunTime:   Double = 0.0 // Total duration of the animation (delay not included)
    private var currentRuntime: Double = 0.0 // Time the animation is already running
    private var animationBlock: MyAnimationBlock!

    /// Start a new animation
    func start(_ block: @escaping MyAnimationBlock, _ runtime: Double, delay: Double) {
        // clear existing timer first
        timer?.invalidate()
        timer = nil
        // save
        animationBlock = block
        totalRunTime = runtime
        currentRuntime = 0

        if delay > 0 {
            // delay
            timer = Timer.scheduledTimer(timeInterval: delay / 1000.0,
                                         target: self,
                                         selector: #selector(delayTick),
                                         userInfo: nil,
                                         repeats: false)
        } else {
            // the animation
            timer = Timer.scheduledTimer(timeInterval: kStepSize,
                                         target: self,
                                         selector: #selector(animationTick),
                                         userInfo: nil,
                                         repeats: true)
        }
    }


    /// One delay tick, continue with real animation
    @objc func delayTick(_ delayTimer: Timer?) {
        delayTimer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: kStepSize,
                                     target: self,
                                     selector: #selector(animationTick),
                                     userInfo: nil,
                                     repeats: true)
    }


    /// One animation tick
    @objc func animationTick(_ animationTimer: Timer?) {
        let step = 1000.0 * kStepSize // step size/length in milli seconds
        currentRuntime += step
        let progress               = min(Double(currentRuntime) / Double(totalRunTime), 1.0)

        // Progress is a value between 0 and 1. The easing function maps this
        // to the animationValue which is than used inside the animationBlock
        // to calculate the current value of the animation
        let animationValue: Double = customEaseOut(progress)
        animationBlock(animationValue)
        if progress >= 1.0 {
            // Animation complete
            timer?.invalidate()
            timer = nil
        }
    }

    /// Easing out animation
    func customEaseOut(_ t: Double) -> Double {
        // Use any easing function you like to animate your values...
        // http://rechneronline.de/function-graphs/
        // http://sol.gfxile.net/interpolation/
        return 1 - pow(1 - t, 2)
    }

}

