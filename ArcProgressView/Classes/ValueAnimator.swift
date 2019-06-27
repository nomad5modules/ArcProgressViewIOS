// Copyright (c) 2019 Nomad5. All rights reserved.

import Foundation

// Number of seconds between each animation step
let kStepSize = 0.015

/// Animation block
typealias AnimationBlock = (Double) -> Void

/// Animate over a given time
class ValueAnimation {

    /// The timer used for every tick
    private var timer:          Timer?
    /// Total duration of the animation
    private var totalRunTime:   Double = 0.0
    /// Time the animation is already running
    private var currentRuntime: Double = 0.0
    /// The animation callback block
    private var animationBlock: AnimationBlock?

    /// Start a new animation
    func start(with time: Double, block: @escaping AnimationBlock) {
        // clear existing timer first
        timer?.invalidate()
        timer = nil
        // save
        animationBlock = block
        totalRunTime = time * 1000.0
        currentRuntime = 0
        // start timer
        timer = Timer.scheduledTimer(timeInterval: kStepSize,
                                     target: self,
                                     selector: #selector(animationTick),
                                     userInfo: nil,
                                     repeats: true)
    }


    /// One animation tick
    @objc func animationTick(_ animationTimer: Timer?) {
        // step size/length in milli seconds
        let step = 1000.0 * kStepSize
        currentRuntime += step
        let progress       = min(currentRuntime / totalRunTime, 1.0)


        // Progress is a value between 0 and 1. The easing function maps this
        // to the animationValue which is than used inside the animationBlock
        // to calculate the current value of the animation
        let animationValue = customEaseOut(progress)
        animationBlock?(animationValue)
        if progress >= 1.0 {
            // Animation complete
            timer?.invalidate()
            timer = nil
        }
    }

    /// Easing out animation
    @inline(__always) func customEaseOut(_ t: Double) -> Double {
        return 1 - pow(1 - t, 2)
    }

}

