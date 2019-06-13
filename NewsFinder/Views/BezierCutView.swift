//
//  BezierCutView.swift
//  NewsFinder
//
//  Created by Nitesh Singh on 24/08/18.
//  Copyright © 2018 Nitesh Singh. All rights reserved.
//

import UIKit

@IBDesignable
class BezierCutView: UIView {
    
    @IBInspectable
    var radius: CGFloat = 15 { didSet { updateMask() } }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateMask()
    }
    
    private func updateMask() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x:0, y:0))
        _ = CGPoint(x: bounds.origin.x + bounds.size.width / 2.0, y: 140)
        //print(NSStringFromCGPoint(center))
        path.addLine(to: CGPoint(x: bounds.origin.x + bounds.size.width - 10, y: bounds.origin.y))
        path.addQuadCurve(to: CGPoint(x: bounds.origin.x + bounds.size.width , y: bounds.origin.y + 10), controlPoint: CGPoint(x: bounds.origin.x + bounds.size.width , y: bounds.origin.y))
        path.addLine(to: CGPoint(x: bounds.origin.x + bounds.size.width, y: bounds.origin.y + bounds.size.height - 30))
        path.addQuadCurve(to: CGPoint(x: bounds.origin.x + bounds.size.width - 10, y: bounds.origin.y + bounds.size.height - 20), controlPoint: CGPoint(x: bounds.origin.x + bounds.size.width, y: bounds.origin.y + bounds.size.height - 20))
        //path.addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: .pi, clockwise: false)
        path.addLine(to: CGPoint(x: bounds.origin.x , y: bounds.origin.y + bounds.size.height - 20))
        //path.addQuadCurve(to: CGPoint(x: bounds.origin.x , y: bounds.origin.y + bounds.size.height - 30), controlPoint: CGPoint(x: bounds.origin.x , y: bounds.origin.y + bounds.size.height - 20))
        path.close()
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        
        layer.mask = mask
        
        
    }

}
