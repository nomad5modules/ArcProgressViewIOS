// Copyright (c) 2019 Nomad5. All rights reserved.

import Foundation

/// Animate over a given time
public class ValueAnimator {

    /// Animation block type
    public typealias AnimationBlock = (Double) -> Void

    /// The timer type used
    private let timerType:      Timer.Type
    /// The timer used for every tick
    private var timer:          Timer?
    /// Total duration of the animation
    private var totalRunTime:   Double = 0.0
    /// Time the animation is already running
    private var currentRuntime: Double = 0.0
    /// The animation callback block
    private var animationBlock: AnimationBlock?
    /// Number of seconds between each animation step
    private let stepSize:       Double

    /// Construction with dependencies
    public init(timerType: Timer.Type = Timer.self, stepSize: Double = 0.015) {
        self.timerType = timerType
        self.stepSize = stepSize
    }

    /// Start a new animation
    open func start(with time: Double, block: @escaping AnimationBlock) {
        // clear existing timer first
        timer?.invalidate()
        timer = nil
        // save
        animationBlock = block
        totalRunTime = time * 1000.0
        currentRuntime = 0
        // start timer
        timer = timerType.scheduledTimer(withTimeInterval: stepSize,
                                         repeats: true,
                                         block: { [weak self] timer in
                                             self?.animationTick(timer)
                                         })
    }


    /// One animation tick
    private func animationTick(_ animationTimer: Timer?) {
        // step size/length in milli seconds
        let step = 1000.0 * stepSize
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
    @inline(__always) private func customEaseOut(_ t: Double) -> Double {
        return 1 - pow(1 - t, 2)
    }

}

