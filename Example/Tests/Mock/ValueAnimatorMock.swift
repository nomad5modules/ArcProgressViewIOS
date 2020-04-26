// Copyright (c) 2020 mlostek@gmail.com. All rights reserved.

import Foundation
@testable import ArcProgressView

/// Controllable mock for the ValueAnimator
class ValueAnimatorMock: ValueAnimator {

    /// Info about invocations of "start"
    struct StartInvocation {
        let time:  TimeInSeconds
        let block: ValueAnimator.AnimationBlock
    }

    /// All start invocations
    var startInvocations: [StartInvocation] = []

    /// Mocked start method
    func start(for time: TimeInSeconds, block: @escaping ValueAnimator.AnimationBlock) {
        startInvocations.append(StartInvocation(time: time, block: block))
    }

    /// Trigger last start invocation block with given progress value
    func executeLastBlock(with progress: Double) {
        if let lastInvocation = startInvocations.last {
            lastInvocation.block(progress)
        }
    }
}