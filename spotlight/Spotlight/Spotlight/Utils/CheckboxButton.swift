//
//  CheckboxButton.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 10.05.2022.
//

import Foundation
import UIKit

@IBDesignable
class CheckboxButton: UIControl {
    var increasedTouchRadius: CGFloat = 5
    
    @IBInspectable
    var borderWidth: CGFloat = 1
    
    @IBInspectable
    var radius: CGFloat = 5
    
    @IBInspectable
    var uncheckedBorderColor: UIColor = Asset.Colors.black.color
    
    @IBInspectable
    var checkedBorderColor: UIColor = Asset.Colors.primary.color
    
    @IBInspectable
    var checkmarkColor: UIColor = Asset.Colors.primary.color
    
    var checkboxBackgroundColor: UIColor! = .white
    
    @IBInspectable
    var isChecked: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.isChecked = !isChecked
        self.sendActions(for: .valueChanged)
    }
    
    override func draw(_ rect: CGRect) {
        let newRect = rect.insetBy(dx: borderWidth / 2, dy: borderWidth / 2)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setStrokeColor(self.isChecked ? checkedBorderColor.cgColor : uncheckedBorderColor.cgColor)
        context.setFillColor(checkboxBackgroundColor.cgColor)
        context.setLineWidth(borderWidth)
        
        var shapePath: UIBezierPath!
        shapePath = UIBezierPath(roundedRect: newRect, cornerRadius: radius)
        context.addPath(shapePath.cgPath)
        context.strokePath()
        context.fillPath()
        
        if isChecked {
            self.drawCheckMark(frame: newRect)
        }
    }
    
    func drawCheckMark(frame: CGRect) {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: frame.minX + 0.26000 * frame.width, y: frame.minY + 0.50000 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.42000 * frame.width, y: frame.minY + 0.62000 * frame.height),
                            controlPoint1: CGPoint(x: frame.minX + 0.38000 * frame.width, y: frame.minY + 0.60000 * frame.height),
                            controlPoint2: CGPoint(x: frame.minX + 0.42000 * frame.width, y: frame.minY + 0.62000 * frame.height))
        
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.70000 * frame.width, y: frame.minY + 0.24000 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.78000 * frame.width, y: frame.minY + 0.30000 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.44000 * frame.width, y: frame.minY + 0.76000 * frame.height))
        
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.20000 * frame.width, y: frame.minY + 0.58000 * frame.height),
                            controlPoint1: CGPoint(x: frame.minX + 0.44000 * frame.width, y: frame.minY + 0.76000 * frame.height),
                            controlPoint2: CGPoint(x: frame.minX + 0.26000 * frame.width, y: frame.minY + 0.62000 * frame.height))
        
        checkmarkColor.setFill()
        bezierPath.fill()
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let relativeFrame = self.bounds
        let hitTestEdgeInsets = UIEdgeInsets(top: -increasedTouchRadius, left: -increasedTouchRadius, bottom: -increasedTouchRadius, right: -increasedTouchRadius)
        let hitFrame = relativeFrame.inset(by: hitTestEdgeInsets)
        return hitFrame.contains(point)
    }
}
