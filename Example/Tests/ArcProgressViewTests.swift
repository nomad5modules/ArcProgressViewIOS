// Copyright (c) 2020 mlostek@gmail.com. All rights reserved.

import Foundation
import XCTest
import Nimble
@testable import ArcProgressView

class ValueAnimatorMock: ValueAnimator {
    init() {
        super.init(timerType: TimerMock.self)
    }

    override func start(with time: Double,
                        block: @escaping ValueAnimator.AnimationBlock) {
        super.start(with: time, block: block)
    }
}

class ShapeLayerMock: CAShapeLayer {

}

class ArcProgressViewTests: XCTestCase {

    var animatorMock:                ValueAnimatorMock!
    var layerForegroundProgressMock: ShapeLayerMock!
    var layerBackgroundMask:         ShapeLayerMock!

    override func setUp() {
        animatorMock = ValueAnimatorMock()
        layerForegroundProgressMock = ShapeLayerMock()
        layerBackgroundMask = ShapeLayerMock()
    }

    func testViewSetupWithoutConfiguration() {
        // Given
        let underTest = ArcProgressView(frame: CGRect(x: 10, y: 10, width: 1000, height: 1000),
                                        animator: ValueAnimatorMock(),
                                        layerForegroundProgress: layerForegroundProgressMock,
                                        layerBackgroundMask: layerBackgroundMask)
        // When
        underTest.layoutSubviews()
        // Then
        animatorMock
    }
}
