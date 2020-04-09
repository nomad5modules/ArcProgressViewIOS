//  Copyright © 2018 Nomad5. All rights reserved.

import UIKit

@IBDesignable
public class ArcProgressView: UIView {
    @IBInspectable public var progressColor:             UIColor?       = nil
    @IBInspectable public var progressText:              String         = ""
    @IBInspectable public var progressTextSize:          CGFloat        = 0.0
    @IBInspectable public var progress:                  Double         = 0.0
    @IBInspectable public var progressFont:              String         = ""
    @IBInspectable public var progressAnimationDuration: Double         = 0.3
    @IBInspectable public var fadeAnimationDuration:     Double         = 1.0

    /// The font
    private var               font:                      UIFont?        = nil
    /// The progress value animation
    private var               animation:                 ValueAnimation = ValueAnimation()

    /// The main progress layer
    private let               layerForegroundProgress:   CAShapeLayer   = CAShapeLayer()
    /// The inverted mask for the background text
    private let               layerBackgroundMask:       CAShapeLayer   = CAShapeLayer()

    /// Default constructor
    override init(frame: CGRect) {
        super.init(frame: frame)
        alpha = 0
    }

    /// Default constructor
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        alpha = 0
    }

    /// Layout subviews
    public override func layoutSubviews() {
        super.layoutSubviews()
        prepareFont()
        prepareLayer()
    }

    /// Set the target progress
    @objc public func setProgress(_ progress: Double, animated: Bool) {
        animateProgress(from: self.progress,
                        to: min(1, max(0, progress)),
                        within: animated ? progressAnimationDuration : 0)
    }

    /// Animate the progress
    private func animateProgress(from: Double, to: Double, within: Double) {
        animation.start(with: within) { [weak self] animationValue in
            guard let self = self else { return }
            self.progress = from + ((to - from) * animationValue)
            self.updateAlpha()
            self.setNeedsDisplay()
        }
    }

    /// Update views visibility
    private func updateAlpha() {
        UIView.animate(withDuration: fadeAnimationDuration) { [weak self] in
            guard let self = self else { return }
            self.alpha = (self.progress > 0 && self.progress < 1) ? 1 : 0
        }
    }

    /// Prepare font (only when really needed)
    private func prepareFont() {
        if font != nil || progressFont.count == 0 || progressText.count == 0 || progressTextSize == 0 {
            return
        }
        guard var newFont = UIFont(name: progressFont, size: progressTextSize) else {
            return
        }
        // paragraph style
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center
        // attributes for back
        var attributes: [NSAttributedString.Key: Any] = [.font: newFont as Any,
                                                         .foregroundColor: progressColor as Any,
                                                         .paragraphStyle: paragraphStyle]
        var textSize                                  = progressText.size(withAttributes: attributes)
        // reduce font size until the text fits in bounds
        while textSize.width > bounds.size.width * 0.9 || textSize.height > bounds.size.height * 0.9 {
            progressTextSize -= 1
            newFont = newFont.withSize(progressTextSize)
            attributes[.font] = newFont as Any
            textSize = progressText.size(withAttributes: attributes)
        }
        // save final font
        font = newFont
    }


    /// Prepare the layer for rendering
    private func prepareLayer() {
        // remove all first
        layer.sublayers?.removeAll()

        // setup the mask that is used within the text layer
        layerBackgroundMask.contentsScale = UIScreen.main.scale
        layerBackgroundMask.frame = bounds
        layerBackgroundMask.path = getCurrentArc(ccw: true)

        // background text layer
        let layerTextBackground = VerticalCenteredTextLayer()
        layerTextBackground.string = progressText
        layerTextBackground.font = font
        layerTextBackground.mask = layerBackgroundMask
        layerTextBackground.frame = bounds
        layerTextBackground.position = center
        layerTextBackground.fontSize = progressTextSize
        layerTextBackground.foregroundColor = progressColor!.cgColor

        // create inverted text layer that will be used within the progress layer
        let invertedTextLayer = VerticalCenteredTextLayer()
        invertedTextLayer.string = progressText
        invertedTextLayer.font = font
        invertedTextLayer.frame = bounds
        invertedTextLayer.position = center
        invertedTextLayer.fontSize = progressTextSize
        invertedTextLayer.foregroundColor = UIColor.black.cgColor
        invertedTextLayer.renderInverted = true

        // setup the progress layer
        layerForegroundProgress.contentsScale = UIScreen.main.scale
        layerForegroundProgress.frame = bounds
        layerForegroundProgress.path = getCurrentArc()
        layerForegroundProgress.mask = invertedTextLayer
        layerForegroundProgress.fillColor = progressColor!.cgColor

        // add all layers
        layer.addSublayer(layerForegroundProgress)
        layer.addSublayer(layerTextBackground)
    }

    /// The main drawing
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        layerForegroundProgress.path = getCurrentArc()
        layerBackgroundMask.path = getCurrentArc(ccw: true)
    }

    /// Get the arc path for the current progress
    @inline(__always) private func getCurrentArc(ccw: Bool = false) -> CGPath {
        let clampedProgress = max(min(1 - 0.0000001, CGFloat(progress)), 0.0000001)
        let endAngle        = (clampedProgress * 360.0).degreesToRadians - CGFloat.piHalf
        let pathProgress    = CGMutablePath.init()
        pathProgress.move(to: center)
        pathProgress.addArc(center: center,
                            radius: max(bounds.size.width, bounds.size.height),
                            startAngle: -CGFloat.piHalf,
                            endAngle: endAngle,
                            clockwise: ccw)
        return pathProgress
    }

}
