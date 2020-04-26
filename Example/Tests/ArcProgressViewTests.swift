// Copyright (c) 2020 mlostek@gmail.com. All rights reserved.

import Foundation
import XCTest
import Nimble
@testable import ArcProgressView

class ShapeLayerMock: CAShapeLayer {

}

class ArcProgressViewTests: XCTestCase {

    var animatorMock:                ValueAnimatorMock!
    var layerForegroundProgressMock: ShapeLayerMock!
    var layerBackgroundMask:         ShapeLayerMock!

    override func setUp() {
        TimerMock.currentTimer = nil
        animatorMock = ValueAnimatorMock()
        layerForegroundProgressMock = ShapeLayerMock()
        layerBackgroundMask = ShapeLayerMock()
    }

    private func configure(arcProgressView: ArcProgressView) {
        arcProgressView.progressFont = "Courier"
        arcProgressView.progressTextSize = 36
        arcProgressView.progressColor = .red
        arcProgressView.progressAnimationDuration = 2.0
        arcProgressView.progress = 0.33
        arcProgressView.progressText = "Lorem ipsum dolor sit amet, consectetur adipiscing\nelit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. \nUt enim ad minim veniam, quis nostrud exercitation"
    }

    func testViewSetupWithoutConfiguration() {
        // Given
        let underTest = ArcProgressView(frame: CGRect(x: 10, y: 10, width: 1000, height: 1000),
                                        animator: animatorMock,
                                        layerForegroundProgress: layerForegroundProgressMock,
                                        layerBackgroundMask: layerBackgroundMask)
        // When
        underTest.layoutSubviews()
        // Then
        expect(self.animatorMock.startInvocations).to(beEmpty())
        expect(underTest.font).to(beNil())
        expect(underTest.layer.sublayers).to(contain([layerForegroundProgressMock]))
        expect(underTest.alpha).to(equal(0))
    }

    func testViewSetupWithConfiguration() {
        // Given
        let underTest = ArcProgressView(frame: CGRect(x: 10, y: 10, width: 1000, height: 1000),
                                        animator: animatorMock,
                                        layerForegroundProgress: layerForegroundProgressMock,
                                        layerBackgroundMask: layerBackgroundMask)
        configure(arcProgressView: underTest)
        // When
        underTest.layoutSubviews()
        // Then
        expect(self.animatorMock.startInvocations).to(beEmpty())
        expect(underTest.font).notTo(beNil())
        expect(underTest.font?.familyName).to(equal("Courier"))
        expect(underTest.font?.pointSize).to(equal(20))
        expect(underTest.layer.sublayers).to(contain([layerForegroundProgressMock]))
        expect(underTest.alpha).to(equal(0))
    }

    func testViewWithASequenceOfAnimations() {
        // Given
        let underTest = ArcProgressView(frame: CGRect(x: 10, y: 10, width: 1000, height: 1000),
                                        animator: animatorMock,
                                        layerForegroundProgress: layerForegroundProgressMock,
                                        layerBackgroundMask: layerBackgroundMask)
        configure(arcProgressView: underTest)
        underTest.layoutSubviews()
        // When & Then
        // animate to 0.85
        underTest.setProgress(0.85, animated: true)
        animatorMock.executeLastBlock(with: 0.1)
        expect(underTest.progress).to(beCloseTo(0.382))
        expect(underTest.alpha).to(equal(1))
        animatorMock.executeLastBlock(with: 0.5)
        expect(underTest.progress).to(beCloseTo(0.59))
        expect(underTest.alpha).to(equal(1))
        animatorMock.executeLastBlock(with: 1.0)
        expect(underTest.progress).to(beCloseTo(0.85))
        expect(underTest.alpha).to(equal(1))
        // animate to 1.0
        underTest.setProgress(1, animated: true)
        animatorMock.executeLastBlock(with: 0.5)
        expect(underTest.progress).to(beCloseTo(0.925))
        expect(underTest.alpha).to(equal(1))
        animatorMock.executeLastBlock(with: 1.0)
        expect(underTest.progress).to(beCloseTo(1.0))
        expect(underTest.alpha).to(equal(0))
    }
}
