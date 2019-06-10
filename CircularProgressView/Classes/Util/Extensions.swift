// Copyright (c) 2019 Nomad5. All rights reserved.

import Foundation

/// Degrees to radians and back
extension FloatingPoint {
    @inlinable var degreesToRadians: Self { return self * .pi / 180 }
    @inlinable var radiansToDegrees: Self { return self * 180 / .pi }
}


extension BinaryFloatingPoint {
    @inlinable public static var piHalf: Double { return 1.57079632679 }
}