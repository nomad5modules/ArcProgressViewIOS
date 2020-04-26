// Copyright (c) 2020 mlostek@gmail.com. All rights reserved.

import XCTest
import Foundation
import Nimble
@testable import ArcProgressView

class CustomEaseOutAnimatorTests: XCTestCase {

    /// The animated values output
    var animatedValues: [Double] = []

    /// The helper block to fill animated values
    var animationBlock: ValueAnimator.AnimationBlock!

    override func setUp() {
        animatedValues.removeAll()
        animationBlock = { self.animatedValues.append($0) }
    }

    func testAnimationStepShort() {
        // GIVEN
        let underTest = CustomEaseOutAnimator(timerType: TimerMock.self, stepSize: 0.13)
        // WHEN
        underTest.start(for: 1.0, block: animationBlock)
        let a = TimerMock.currentTimer!
        (0...8).forEach { _ in
            a.fire()
        }
        // THEN
        expect(self.animatedValues).to(beCloseTo([0.2430, 0.4524, 0.6279, 0.7696, 0.8775, 0.9516, 0.9919, 1, 1]))
        expect(TimerMock.currentTimer.fireInvocations).to(equal(9))
        expect(TimerMock.currentTimer.invalidateInvocations).to(haveCount(1))
        expect(TimerMock.currentTimer.invalidateInvocations.first).to(equal(7))
    }

    func testAnimationStepLong() {
        // GIVEN
        let underTest = CustomEaseOutAnimator(timerType: TimerMock.self, stepSize: 15.33)
        // WHEN
        underTest.start(for: 100, block: animationBlock)
        let a = TimerMock.currentTimer!
        (0...8).forEach { _ in
            a.fire()
        }
        // THEN
        expect(self.animatedValues).to(beCloseTo([0.2831, 0.5192, 0.7083, 0.8504, 0.9455, 0.9936, 1, 1, 1]))
        expect(TimerMock.currentTimer.fireInvocations).to(equal(9))
        expect(TimerMock.currentTimer.invalidateInvocations).to(haveCount(1))
        expect(TimerMock.currentTimer.invalidateInvocations.first).to(equal(6))
    }
}
