// Copyright (c) 2020 mlostek@gmail.com. All rights reserved.

import Foundation
import ObjectiveC

/// A mocked timer
class TimerMock: Timer {

    /// Timer callback type
    typealias TimerCallback = ((Timer) -> Void)

    /// The latest used timer mock accessible to control
    static var  currentTimer: TimerMock!

    /// The block to be invoked on a firing
    private var block:        TimerCallback!

    /// Invalidation invocations (will contain the fireInvocation indices)
    var invalidateInvocations: [Int] = []

    /// Fire invocation count
    var fireInvocations:       Int   = 0

    /// Main function to control a timer fire
    override open func fire() {
        block(self)
        fireInvocations += 1
    }

    /// Hook into invalidation
    override open func invalidate() {
        invalidateInvocations.append(fireInvocations)
    }

    /// Hook into the timer configuration
    override open class func scheduledTimer(withTimeInterval interval: TimeInterval,
                                            repeats: Bool,
                                            block: @escaping TimerCallback) -> Timer {
        // return timer mock
        TimerMock.currentTimer = TimerMock()
        TimerMock.currentTimer.block = block
        return TimerMock.currentTimer
    }

}
