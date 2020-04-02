// Copyright (c) 2020 mlostek@gmail.com. All rights reserved.

import XCTest
import Foundation
import Nimble
@testable import ArcProgressView

class ExtensionTests: XCTestCase {

    func testFloatingPointExtension_degreesToRadians() {
        expect(Float(0).degreesToRadians).to(beCloseTo(0))
        expect(Float(10).degreesToRadians).to(beCloseTo(0.174533))
        expect(Float(100).degreesToRadians).to(beCloseTo(1.74533))
        expect(Float(133).degreesToRadians).to(beCloseTo(2.32129))
        expect(Float(371).degreesToRadians).to(beCloseTo(6.47517))
    }

    func testFloatingPointExtension_radiansToDegrees() {
        expect(Float(0).radiansToDegrees).to(beCloseTo(0))
        expect(Float(10).radiansToDegrees).to(beCloseTo(Float(572.9578)))
        expect(Float(100).radiansToDegrees).to(beCloseTo(Float(5729.578)))
        expect(Float(133).radiansToDegrees).to(beCloseTo(Float(7620.339)))
        expect(Float(371).radiansToDegrees).to(beCloseTo(Float(21256.7341)))
    }

    func testBinaryFloatingPointExtension_piHalf() {
        expect(Double.piHalf).to(equal(1.57079632679))
    }

    func testStringExtension_lineCount() {
        expect("only one liner".lineCount).to(equal(1))
        expect("another line\nwith some \n line- \\nbreaks?".lineCount).to(equal(3))
        expect("only one liner".lineCount).to(equal(1))
        expect("only one liner".lineCount).to(equal(1))
    }
}
