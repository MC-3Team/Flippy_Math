//
//  ChatBubbleShape.swift
//  FlippyMath
//
//  Created by Enrico Maricar on 18/08/24.
//

import Foundation
import SwiftUI

struct ChatBubbleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let pointerHeight: CGFloat = 20
        let pointerWidth: CGFloat = 30
        let pointerCenterX = rect.midX
        let cornerRadius: CGFloat = 16
        
        path.move(to: CGPoint(x: 0 + cornerRadius, y: pointerHeight))
        path.addLine(to: CGPoint(x: pointerCenterX - pointerWidth / 2, y: pointerHeight))

        path.addQuadCurve(to: CGPoint(x: pointerCenterX + pointerWidth / 2, y: pointerHeight),
                          control: CGPoint(x: pointerCenterX, y: -10))
        
        path.addLine(to: CGPoint(x: rect.width - cornerRadius, y: pointerHeight))
        path.addArc(center: CGPoint(x: rect.width - cornerRadius, y: pointerHeight + cornerRadius),
                    radius: cornerRadius,
                    startAngle: Angle(degrees: -90),
                    endAngle: Angle(degrees: 0),
                    clockwise: false)

        path.addLine(to: CGPoint(x: rect.width, y: rect.height - cornerRadius))
        path.addArc(center: CGPoint(x: rect.width - cornerRadius, y: rect.height - cornerRadius),
                    radius: cornerRadius,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 90),
                    clockwise: false)
        
        path.addLine(to: CGPoint(x: cornerRadius, y: rect.height))
        path.addArc(center: CGPoint(x: cornerRadius, y: rect.height - cornerRadius),
                    radius: cornerRadius,
                    startAngle: Angle(degrees: 90),
                    endAngle: Angle(degrees: 180),
                    clockwise: false)

        path.addLine(to: CGPoint(x: 0, y: pointerHeight + cornerRadius))
        path.addArc(center: CGPoint(x: cornerRadius, y: pointerHeight + cornerRadius),
                    radius: cornerRadius,
                    startAngle: Angle(degrees: 180),
                    endAngle: Angle(degrees: 270),
                    clockwise: false)
        
        path.closeSubpath()
        
        return path
    }
}
