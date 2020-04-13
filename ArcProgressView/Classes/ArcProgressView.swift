//  Copyright © 2018 Nomad5. All rights reserved.

import UIKit

@IBDesignable
public class ArcProgressView: UIView {

    /// The color overlay that shows the progress
    @IBInspectable public var progressColor:             UIColor = .black
    /// The text shown with the progress
    @IBInspectable public var progressText:              String  = ""
    /// The text size of the progress text
    @IBInspectable public var progressTextSize:          CGFloat = 0.0
    /// The progress value itself
    @IBInspectable public var progress:                  Double  = 0.0
    /// The font used for the progress text
    @IBInspectable public var progressFont:              String  = ""
    /// The animation duration for the progress animation
    @IBInspectable public var progressAnimationDuration: Double  = 0.3
    /// The duration of the fade in / out when progress starts at 0 vs. reaches 1
    @IBInspectable public var fadeAnimationDuration:     Double  = 1.0

    /// The font
    private(set) var          font:                      UIFont? = nil

    /// The progress value animation
    private var               animator:                  ValueAnimator
    /// The main progress layer
    private let               layerForegroundProgress:   CAShapeLayer
    /// The inverted mask for the background text
    private let               layerBackgroundMask:       CAShapeLayer

    /// Default constructor
    override init(frame: CGRect) {
        animator = CustomEaseOutAnimator()
        layerForegroundProgress = CAShapeLayer()
        layerBackgroundMask = CAShapeLayer()
        super.init(frame: frame)
        alpha = 0
    }

    /// Default constructor
    required init?(coder: NSCoder) {
        animator = CustomEaseOutAnimator()
        layerForegroundProgress = CAShapeLayer()
        layerBackgroundMask = CAShapeLayer()
        super.init(coder: coder)
        alpha = 0
    }

    /// Main constructor with mock-able dependencies
    public init(frame: CGRect,
                animator: ValueAnimator = CustomEaseOutAnimator(),
                layerForegroundProgress: CAShapeLayer = CAShapeLayer(),
                layerBackgroundMask: CAShapeLayer = CAShapeLayer()) {
        self.animator = animator
        self.layerForegroundProgress = layerForegroundProgress
        self.layerBackgroundMask = layerBackgroundMask
        super.init(frame: frame)
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
    private func animateProgress(from: Double, to: Double, within duration: ValueAnimator.TimeInSeconds) {
        animator.start(for: duration) { [weak self] animationValue in
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
        // early exit
        guard font == nil,
              !progressFont.isEmpty,
              !progressText.isEmpty,
              progressTextSize > 0,
              var newFont = UIFont(name: progressFont, size: progressTextSize) else {
            return
        }
        // paragraph with proper attributes
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center
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
        let layerTextBackground = VerticalCenteredTextLayer(progressText: progressText,
                                                            progressFont: font,
                                                            progressTextSize: progressTextSize,
                                                            frame: bounds,
                                                            position: center,
                                                            foregroundColor: progressColor.cgColor,
                                                            maskLayer: layerBackgroundMask)

        // create inverted text layer that will be used within the progress layer
        let invertedTextLayer   = VerticalCenteredTextLayer(progressText: progressText,
                                                            progressFont: font,
                                                            progressTextSize: progressTextSize,
                                                            frame: bounds,
                                                            position: center,
                                                            foregroundColor: UIColor.black.cgColor,
                                                            renderInverted: true)

        // setup the progress layer
        layerForegroundProgress.contentsScale = UIScreen.main.scale
        layerForegroundProgress.frame = bounds
        layerForegroundProgress.path = getCurrentArc()
        layerForegroundProgress.mask = invertedTextLayer
        layerForegroundProgress.fillColor = progressColor.cgColor

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
