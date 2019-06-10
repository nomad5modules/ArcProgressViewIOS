//  Copyright © 2018 Nomad5. All rights reserved.

import UIKit

/// A intelligent CATextLayer that centers also vertically
class VerticalCenteredTextLayer: CATextLayer {
    override open func draw(in ctx: CGContext) {
        var yDiff:    CGFloat = 0
        let fontSize: CGFloat
        let height            = self.bounds.height

        if let attributedString = self.string as? NSAttributedString {
            let lines = attributedString.string.reduce(into: 0) { (count, letter) in
                if letter == "\n" {
                    count += 1
                }
            }
            fontSize = attributedString.size().height
            yDiff = (height - CGFloat(lines) * fontSize) / 2
        } else {
            if let string = self.string as? String {
                let lines = string.reduce(into: 0) { (count, letter) in
                    if letter == "\n" {
                        count += 1
                    }
                }
                fontSize = self.fontSize
                yDiff = (height - CGFloat(lines) * fontSize) / 2 - CGFloat(lines) * fontSize / 10
            }
        }

        ctx.saveGState()
        ctx.translateBy(x: 0.0, y: yDiff)
        super.draw(in: ctx)
        ctx.restoreGState()
    }
}
