// Copyright (c) 2019 Nomad5. All rights reserved.

import Foundation

/// Degrees to radians and back
extension FloatingPoint {
    @inlinable var degreesToRadians: Self { return self * .pi / 180 }
    @inlinable var radiansToDegrees: Self { return self * 180 / .pi }
}

/// PI half constant
extension BinaryFloatingPoint {
    @inlinable public static var piHalf: CGFloat { return 1.57079632679 }
}

/// Count lines in string
extension String {
    @inlinable var lineCount: UInt {
        return self.reduce(into: 0) { (count, letter) in
            if letter == "\n" {
                count += 1
            }
        }
    }
}