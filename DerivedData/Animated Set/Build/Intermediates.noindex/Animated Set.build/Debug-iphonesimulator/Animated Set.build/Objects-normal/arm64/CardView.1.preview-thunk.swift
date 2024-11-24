import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/nicholasdalba/Developer/Animated Set/Animated Set/View/CardView.swift", line: 1)
//
//  CardView.swift
//  Set
//
//  Created by Nicholas Alba on 9/16/24.
//

import SwiftUI

struct CardView: View {
    var card: Card
    var fillColor: Color?
    
    var body: some View {
        let rectangle = RoundedRectangle(cornerRadius: Constants.cornerRadius)
        GeometryReader { geometry in
            ZStack {
                rectangle.fill(.white)
                if let fillColor = fillColor {
                    let opaqueFillColor = fillColor.opacity(Constants.opacity)
                    rectangle.fill(opaqueFillColor)
                    rectangle.strokeBorder(fillColor, lineWidth: Constants.lineWidth)
                } else {
                    rectangle.strokeBorder(lineWidth: Constants.lineWidth)
                }
                VStack {
                    ForEach(__designTimeInteger("#11686_0", fallback: 0)..<shapeCount, id: \.self) { index in
                        shapeWithColor.aspectRatio(__designTimeFloat("#11686_1", fallback: 2.0), contentMode: .fit)
                    }
                }.padding(Constants.shapePadding)
            }
        }
    }
        
    @ViewBuilder 
    var shapeWithColor: some View {
        let features = card.features
        let shape = shape(ofTrilean: features.first)
        let color = color(ofTrilean: features.second)
        if features.third == .first {
            shape.stroke(color, lineWidth: Constants.strokeWidth)
        } else {
            let opacity = features.third == .second ? __designTimeFloat("#11686_2", fallback: 0.5) : __designTimeFloat("#11686_3", fallback: 1.0)
            shape.fill(color.opacity(opacity))
        }
    }
    
    var shapeCount: Int {
        count(ofTrilean: card.features.fourth)
    }
    
    private func color(ofTrilean trilean: Trilean) -> Color {
        [Color.red, Color.green, Color.blue][Int(trilean.rawValue) - __designTimeInteger("#11686_4", fallback: 1)]
    }
    
    private func count(ofTrilean trilean: Trilean) -> Int {
        Int(trilean.rawValue)
    }
    
    private func opacity(ofTrilean trilean: Trilean) -> CGFloat {
        [__designTimeFloat("#11686_5", fallback: 1.0), __designTimeFloat("#11686_6", fallback: 0.5), __designTimeFloat("#11686_7", fallback: 1.0)][Int(trilean.rawValue) - __designTimeInteger("#11686_8", fallback: 1)]
    }
    
    private func shape(ofTrilean trilean: Trilean) -> some Shape {
        [AnyShape(Pill()), AnyShape(Rhombus()), AnyShape(Squiggle())][Int(trilean.rawValue) - 1]
    }
    
    private struct Constants {
        static let cornerRadius = 16.0
        static let lineWidth = 2.0
        static let strokeWidth = 2.0
        static let shapePadding = 10.0
        static let opacity = 0.05
    }
}

private struct AnyShape: Shape {
    private let _path: @Sendable (CGRect) -> Path
    
    init<S: Shape>(_ wrapped: S) {
        _path = { rect in
            wrapped.path(in: rect)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        _path(rect)
    }
}


#Preview {
    let fillColor = Color(hex: 0x71b379)
    
    CardView(card: Card(id: __designTimeInteger("#11686_9", fallback: 0b11011111)), fillColor: fillColor)
        .aspectRatio(CGFloat(__designTimeFloat("#11686_10", fallback: 2.5))/__designTimeFloat("#11686_11", fallback: 3.5), contentMode: .fit)
        .padding()
        // .background(fillColor)
}
