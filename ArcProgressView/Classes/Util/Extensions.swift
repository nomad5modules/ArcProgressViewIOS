// Copyright (c) 2019 Nomad5. All rights reserved.

import UIKit

/// Degrees to radians and back
extension FloatingPoint {
    @inlinable var degreesToRadians: Self {
        return self * .pi / 180
    }
    @inlinable var radiansToDegrees: Self {
        return self * 180 / .pi
    }
}

extension Double {
    @inlinable var easedOut: Double {
        return 1 - pow(1 - max(min(self, 1), 0), 2)
    }
}

/// PI half constant
extension BinaryFloatingPoint {
    @inlinable public static var piHalf: CGFloat {
        return 1.57079632679
    }
}

/// Count lines in string
extension String {
    @inlinable var lineCount: UInt {
        return self.reduce(into: 1) { (count, letter) in
            if letter == "\n" {
                count += 1
            }
        }
    }
}