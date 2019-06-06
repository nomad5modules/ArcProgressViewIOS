//  Copyright © 2018 Nomad5. All rights reserved.

import UIKit

func DEG2RAD(_ angle: Double) -> Double {
    return (angle) / 180.0 * .pi
}

let THRESHOLD          = 0.01
let UPPER_BOUND        = 0.9999999
let PROGRESS_ANIMATION = 300.0

@IBDesignable
public class CPV: UIView {
    @IBInspectable var borderOffset:     CGFloat = 0.0
    @IBInspectable var progressColor:    UIColor?
    @IBInspectable var progressText              = ""
    @IBInspectable var progressTextSize: CGFloat = 0.0
    @IBInspectable private(set) var progress: Double = 0.0
    @IBInspectable var progressFont = ""


    private var font:       UIFont?
    private var attributes: [NSAttributedString.Key: Any] = [:]
    private var textSize                                  = CGSize.zero
    private var animation:  ValueAnimation?

    /**
         * Default construction
         */
    override init(frame: CGRect) {
        super.init(frame: frame)
        alpha = 0
    }

    /**
         * Default construction
         */
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        alpha = 0
    }

/**
     * Set the progress
     */
    public func setProgress(_ progress: Double, animated: Bool) {
        var delaySec: Double = 0.0
        if (self.progress > 0.0 && progress <= 0.0) || (self.progress < UPPER_BOUND && progress >= 1.0) {
            // fade out
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(1.0)
            UIView.setAnimationDelay(animated ? (PROGRESS_ANIMATION / 1000.0) : 0.0)
            UIView.setAnimationCurve(.linear)
            alpha = 0.0
            UIView.commitAnimations()
        } else if (self.progress <= 0 && progress > 0.0) || (self.progress >= UPPER_BOUND && progress < 1.0) {
            // fade in
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(1.0)
            UIView.setAnimationDelay(0.0)
            UIView.setAnimationCurve(.linear)
            alpha = 1.0
            UIView.commitAnimations()
            delaySec = 1.0
        }
        // set the progress
        if animated {
            animateProgress(from: self.progress, to: min(UPPER_BOUND, max(0.0, progress)), delay: delaySec)
        } else {
            // this is direct setting
            self.progress = min(UPPER_BOUND, max(0, progress))
            setNeedsDisplay()
        }
    }

    //  Converted to Swift 5 by Swiftify v5.0.23302 - https://objectivec2swift.com/
/**
     * Animate the progress from to
     */
    func animateProgress(from fromValue: Double, to toValue: Double, delay delaySec: Double) {


        if animation == nil {
            animation = ValueAnimation()
        }
        let animationBlock: MyAnimationBlock = { animationValue in
            let currentValue = fromValue + ((toValue - fromValue) * animationValue)
            self.progress = currentValue
            self.setNeedsDisplay()
        }
        animation?.start(animationBlock, PROGRESS_ANIMATION, delay: delaySec)
    }

    /// Prepare the values for rendering
    func prepare() {
        if font == nil && progressFont != nil && progressText != nil && progressTextSize > 0 {
            font = UIFont(name: progressFont, size: progressTextSize)
            // paragraph for both
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = .byWordWrapping
            paragraphStyle.alignment = .center
            // attributes for back
            attributes = [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: progressColor,
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ]
            textSize = progressText.size(withAttributes: attributes)
            // reduce font size until the text fits in bounds
            while textSize.width > bounds.size.width * 0.9 || textSize.height > bounds.size.height * 0.9 {
                progressTextSize -= 1
                font = font!.withSize(progressTextSize)
                attributes = [
                    NSAttributedString.Key.font: font,
                    NSAttributedString.Key.foregroundColor: progressColor,
                    NSAttributedString.Key.paragraphStyle: paragraphStyle
                ]
                textSize = progressText.size(withAttributes: attributes)
            }
        }
    }

//  The converted code is limited to 2 KB.
//  Upgrade your plan to remove this limitation.
//
//  Converted to Swift 5 by Swiftify v5.0.23302 - https://objectivec2swift.com/
/**
     * Where the magic happens
     */

/**
     * Where the magic happens
     */
    public override func draw(_ rect: CGRect) {
        var context: CGContext!
        prepare()
        if font == nil || attributes == nil || progressColor == nil {
            context = UIGraphicsGetCurrentContext()
            UIColor.clear.setFill()
            UIRectFill(rect)
            context?.fillPath()
            return
        }
        let angle         = CGFloat(-M_PI_2 + DEG2RAD(progress * 360.0))
        let piHalfNeg     = CGFloat(-M_PI_2)
        let x:    CGFloat = bounds.size.width / 2.0
        let y:    CGFloat = bounds.size.height / 2.0
        // calculate rect
        let textRect      = CGRect(x: rect.origin.x + CGFloat(floorf(Float(rect.size.width - textSize.width) / 2.0)),
                                   y: rect.origin.y + CGFloat(floorf(Float(rect.size.height - textSize.height) / 2.0)),
                                   width: CGFloat(ceilf(Float(textSize.width))),
                                   height: CGFloat(ceilf(Float(textSize.height))))
        // get offset
        let size: CGFloat = max(rect.size.width, rect.size.height) + borderOffset
        ///////////////////////////////////////////////// BACKGROUND IMAGE
        UIGraphicsBeginImageContextWithOptions(rect.size, _: false, _: 0.0)
        context = UIGraphicsGetCurrentContext()
        progressColor!.setFill()
        UIRectFill(rect)
        context.setBlendMode(CGBlendMode.destinationOut)
        progressText.draw(in: textRect, withAttributes: attributes)
        context?.beginPath()
        context?.setFillColor(progressColor!.cgColor)
        context?.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
        context?.addArc(center: CGPoint(x: CGFloat(x), y: CGFloat(y)),
                        radius: size,
                        startAngle: CGFloat(piHalfNeg),
                        endAngle: CGFloat(angle),
                        clockwise: true)
        context?.closePath()
        context?.fillPath()
        let backImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        ///////////////////////////////////////////////// FOREGROUND IMAGE
        UIGraphicsBeginImageContextWithOptions(rect.size, _: false, _: 0.0)
        context = UIGraphicsGetCurrentContext()
        UIColor.clear.setFill()
//
//  The converted code is limited to 2 KB.
//  Upgrade your plan to remove this limitation.
//
//  %< ----------------------------------------------------------------------------------------- %<
//  Converted to Swift 5 by Swiftify v5.0.23302 - https://objectivec2swift.com/
        UIRectFill(rect)
        context.setBlendMode(CGBlendMode.normal)
        progressText.draw(in: textRect, withAttributes: attributes)
        context.setBlendMode(CGBlendMode.destinationOut)
        context.beginPath()
        context.setFillColor(progressColor!.cgColor)
        context.move(to: CGPoint(x: x, y: y))
        context.addArc(center: CGPoint(x: x, y: y),
                       radius: size,
                       startAngle: angle,
                       endAngle: piHalfNeg,
                       clockwise: true)
        context.closePath()
        context.fillPath()
        context.setBlendMode(CGBlendMode.normal)
        let frontImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

///////////////////////////////////////////////// COMPOSE
        if progress >= THRESHOLD {
            backImage?.draw(at: CGPoint(x: 0, y: 0))
        }
        frontImage?.draw(at: CGPoint(x: 0, y: 0))
    }
}