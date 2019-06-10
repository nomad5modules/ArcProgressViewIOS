//  Copyright © 2018 Nomad5. All rights reserved.

import UIKit

@IBDesignable
public class CircularProgressView: UIView {
    @IBInspectable var progressColor:             UIColor? = nil
    @IBInspectable var progressText:              String   = ""
    @IBInspectable var progressTextSize:          CGFloat  = 0.0
    @IBInspectable var progress:                  Double   = 0.0
    @IBInspectable var progressFont:              String   = ""
    @IBInspectable var progressAnimationDuration: Double   = 0.3
    @IBInspectable var fadeAnimationDuration:     Double   = 1.0

    /// The font
    private var font:       UIFont?                       = nil
    private var attributes: [NSAttributedString.Key: Any] = [:]
    private var textSize:   CGSize                        = .zero
    private var animation:  ValueAnimation                = ValueAnimation()

    private let layerProgress:       CAShapeLayer              = CAShapeLayer()
    private let layerMask:           CAShapeLayer              = CAShapeLayer()
    private let layerTextForeground: VerticalCenteredTextLayer = VerticalCenteredTextLayer()
    private let layerTextBackground: VerticalCenteredTextLayer = VerticalCenteredTextLayer()

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

    /// Set the target progress
    public func setProgress(_ progress: Double, animated: Bool) {
//        var delaySec: Double = 0.0
//        if (self.progress > 0.0 && progress <= 0.0) || (self.progress < UPPER_BOUND && progress >= 1.0) {
//            // fade out
//            UIView.animate(withDuration: fadeAnimationDuration, delay: animated ? progressAnimationDuration : 0.0, animations: {
//                self.alpha = 0.0
//            })
//        } else if (self.progress <= 0 && progress > 0.0) || (self.progress >= UPPER_BOUND && progress < 1.0) {
//            // fade out
//            UIView.animate(withDuration: fadeAnimationDuration, delay: 0.0, animations: {
//                self.alpha = 1.0
//            })
//            delaySec = fadeAnimationDuration
//        }
        // set the progress
        if animated {
            animateProgress(from: self.progress, to: min(1, max(0, progress)), delay: 0)
        } else {
            // this is direct setting
            self.progress = min(1, max(0, progress))
            setNeedsDisplay()
        }
    }

    /// Layout subviews
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.prepare()
    }

    /// The main drawing
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        let arcPath = getCurrentArc()
        layerMask.path = arcPath
        layerProgress.path = arcPath

    }

    /// Update views visibility
    private func updateAlpha() {
        if (self.progress > 0 && self.progress < 1) {
            UIView.animate(withDuration: fadeAnimationDuration) {
                self.alpha = 1.0
            }
        } else {
            UIView.animate(withDuration: fadeAnimationDuration) {
                self.alpha = 0.0
            }
        }
    }

    /// Animate the progress
    private func animateProgress(from fromValue: Double, to toValue: Double, delay delaySec: Double) {
        let animationBlock: MyAnimationBlock = { animationValue in
            let currentValue = fromValue + ((toValue - fromValue) * animationValue)
            self.progress = currentValue
            self.updateAlpha()
            self.setNeedsDisplay()
        }
        animation.start(animationBlock, progressAnimationDuration * 1000.0, delay: delaySec)
    }


    /// Prepare the values for rendering
    private func prepare() {
        if font == nil && progressFont.count > 0 && progressText.count > 0 && progressTextSize > 0 {
            font = UIFont(name: progressFont, size: progressTextSize)
            // paragraph for both
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = .byWordWrapping
            paragraphStyle.alignment = .center
            // attributes for back
            attributes = [
                NSAttributedString.Key.font: font as Any,
                NSAttributedString.Key.foregroundColor: progressColor as Any,
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ]
            textSize = progressText.size(withAttributes: attributes)
            // reduce font size until the text fits in bounds
            while textSize.width > bounds.size.width * 0.9 || textSize.height > bounds.size.height * 0.9 {
                progressTextSize -= 1
                font = font!.withSize(progressTextSize)
                attributes = [
                    NSAttributedString.Key.font: font as Any,
                    NSAttributedString.Key.foregroundColor: progressColor as Any,
                    NSAttributedString.Key.paragraphStyle: paragraphStyle
                ]
                textSize = progressText.size(withAttributes: attributes)
            }
        }

        // setup players

        //// PREP
        layer.sublayers?.removeAll()

        let arcPath = getCurrentArc()
        //// DRAW
        layerMask.contentsScale = UIScreen.main.scale
        layerMask.frame = bounds
        layerMask.path = arcPath

        layerProgress.contentsScale = UIScreen.main.scale
        layerProgress.frame = bounds
        layerProgress.path = arcPath
        layerProgress.fillColor = progressColor!.cgColor

        layerTextBackground.contentsScale = UIScreen.main.scale
        layerTextBackground.string = progressText
        layerTextBackground.font = font
        layerTextBackground.alignmentMode = .center
        layerTextBackground.frame = bounds
        layerTextBackground.position = center
        layerTextBackground.fontSize = progressTextSize
        layerTextBackground.foregroundColor = progressColor!.cgColor

        layerTextForeground.contentsScale = UIScreen.main.scale
        layerTextForeground.mask = layerMask
        layerTextForeground.string = progressText
        layerTextForeground.font = font
        layerTextForeground.alignmentMode = .center
        layerTextForeground.frame = bounds
        layerTextForeground.position = center
        layerTextForeground.fontSize = progressTextSize
        layerTextForeground.foregroundColor = backgroundColor!.cgColor


        layer.addSublayer(layerTextBackground)
        layer.addSublayer(layerProgress)
        layer.addSublayer(layerTextForeground)
    }

    /// Get the arc path for the current progress
    private func getCurrentArc() -> CGPath {
        let offset          = 0.0000001
        // start and end angles
        let clampedProgress = max(min(1 - offset, progress), offset)
        let startAngle      = CGFloat(-Double.piHalf)
        let endAngle        = CGFloat(-Double.piHalf + (clampedProgress * 360.0).degreesToRadians)
        let pathProgress    = CGMutablePath.init()
        pathProgress.move(to: center)
        pathProgress.addArc(center: center,
                            radius: max(self.bounds.size.width, self.bounds.size.height),
                            startAngle: startAngle,
                            endAngle: endAngle,
                            clockwise: true)
        return pathProgress
    }

}
