//
//  Cardify.swift
//  Animated Set
//
//  Created by Nicholas Alba on 11/30/24.
//

import SwiftUI

struct Cardify: ViewModifier {
    var cornerRadius: CGFloat?
    var fillColor: Color?
    var lineWidth: CGFloat?
    
    func body(content: Content) -> some View {
        let cornerRadius = cornerRadius ?? Constants.cornerRadius
        let rectangle = RoundedRectangle(cornerRadius: cornerRadius)
        let lineWidth = lineWidth ?? Constants.lineWidth
        
        ZStack {
            rectangle.fill(.white)
            if let fillColor = fillColor {
                let opaqueFillColor = fillColor.opacity(Constants.opacity)
                rectangle.fill(opaqueFillColor)
                rectangle.strokeBorder(fillColor, lineWidth: lineWidth)
            } else {
                rectangle.strokeBorder(lineWidth: lineWidth)
            }
            content
        }
    }
    
    
    private struct Constants {
        static let cornerRadius: CGFloat = 16.0
        static let lineWidth: CGFloat = 2.0
        static let opacity = 0.05
    }
}

extension View {
    func cardify(cornerRadius: CGFloat? = nil, fillColor: Color? = nil, lineWidth: CGFloat? = nil) -> some View {
        modifier(Cardify(cornerRadius: cornerRadius, fillColor: fillColor, lineWidth: lineWidth))
    }
}
