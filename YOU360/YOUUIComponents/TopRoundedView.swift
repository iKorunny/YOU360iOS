//
//  TopRoundedView.swift
//  YOUUIComponents
//
//  Created by Ihar Karunny on 2/22/24.
//

import UIKit

public final class TopRoundedView: UIView {
    
    public var roundRadius: CGFloat = 40 {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    public var fillColor: UIColor = .clear {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    public override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {return}
        let leftBottomCorner = CGPoint(x: 0, y: rect.height)
        context.move(to: leftBottomCorner)
        context.addLine(to: .init(x: rect.width, y: rect.height))
        context.addLine(to: .init(x: rect.width, y: roundRadius))
        context.addArc(center: .init(x: rect.width - roundRadius, y: roundRadius), radius: roundRadius, startAngle: 0, endAngle: -CGFloat.pi * 0.5, clockwise: true)
        context.addLine(to: .init(x: roundRadius, y: 0))
        context.addArc(center: .init(x: roundRadius, y: roundRadius), radius: roundRadius, startAngle: -CGFloat.pi * 0.5, endAngle: -CGFloat.pi, clockwise: true)
        context.addLine(to: leftBottomCorner)
        context.setFillColor(fillColor.cgColor)
        context.fillPath()
    }

}
