//  Copyright © 2018 Nomad5. All rights reserved.

import UIKit

/// A CATextLayer that centers also vertically
class VerticalCenteredTextLayer: CATextLayer {

    /// Invert the rendering
    var renderInverted = false

    /// Required init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentsScale = UIScreen.main.scale
        alignmentMode = .center
    }

    /// Copy constructor
    override init(layer: Any) {
        super.init(layer: layer)
    }

    /// Default initialization
    init(progressText: String,
         progressFont: UIFont?,
         progressTextSize: CGFloat,
         frame: CGRect,
         position: CGPoint,
         foregroundColor: CGColor,
         maskLayer: CALayer? = nil,
         renderInverted: Bool = false) {
        super.init()
        super.string = progressText
        super.font = progressFont
        super.mask = maskLayer
        super.frame = frame
        super.position = position
        super.fontSize = progressTextSize
        super.foregroundColor = foregroundColor
        self.renderInverted = renderInverted
        contentsScale = UIScreen.main.scale
        alignmentMode = .center
    }

    /// Main drawing function
    override open func draw(in ctx: CGContext) {
        ctx.saveGState()
        if renderInverted {
            ctx.setFillColor(UIColor.white.cgColor)
            ctx.fill(bounds)
            ctx.setBlendMode(.clear)
        }
        ctx.translateBy(x: 0.0, y: self.getVerticalOffset())
        super.draw(in: ctx)
        ctx.restoreGState()
    }

    /// Get the y position
    private func getVerticalOffset() -> CGFloat {
        // string is an attributed one
        if let attributedString = self.string as? NSAttributedString {
            let lines = attributedString.string.lineCount
            fontSize = attributedString.size().height
            return (self.bounds.height - CGFloat(lines - 1) * fontSize) / 2 - fontSize
        }
        // if its a regular string
        if let string = self.string as? String {
            let lines = string.lineCount
            fontSize = self.fontSize
            return (self.bounds.height - CGFloat(lines - 1) * fontSize) / 2 - fontSize
        }
        // fallback
        return 0
    }

}
