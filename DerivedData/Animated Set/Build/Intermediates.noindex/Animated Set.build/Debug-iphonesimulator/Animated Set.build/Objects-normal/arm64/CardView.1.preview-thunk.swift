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
    init(card: Card, isFaceUp: Bool, selectionState: CardSelectionState? = nil) {
        self.card = card
        self.isFaceUp = isFaceUp
        self.selectionState = selectionState
    }
    
    var card: Card
    var isFaceUp: Bool

    var selectionState: CardSelectionState?
    
//    var rotation: Double = 0
//    var animatableData: Double {
//        get { return rotation }
//        set { rotation = newValue }
//    }
    
    var body: some View {
        Group {
            if isFaceUp {
                faceUpCard
            } else {
                faceDownCard
            }
        }.cardify(fillColor: Constants.backgroundColors[selectionState])
            // .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
    }
    
    var faceUpCard: some View {
        VStack {
            ForEach(__designTimeInteger("#6125_0", fallback: 0)..<shapeCount, id: \.self) { index in
                shapeWithColor.aspectRatio(__designTimeFloat("#6125_1", fallback: 2.0), contentMode: .fit)
            }
        }.padding(Constants.shapePadding)
    }

    var faceDownCard: some View {
        CoolS().stroke(lineWidth: Constants.coolSStrokeWidth)
    }
        
    @ViewBuilder
    var shapeWithColor: some View {
        let features = card.features
        let shape = shape(ofTrilean: features.first)
        let color = color(ofTrilean: features.second)
        if features.third == .first {
            shape.stroke(color, lineWidth: Constants.strokeWidth)
        } else {
            let opacity = features.third == .second ? __designTimeFloat("#6125_2", fallback: 0.5) : __designTimeFloat("#6125_3", fallback: 1.0)
            shape.fill(color.opacity(opacity))
        }
    }
    
    var shapeCount: Int {
        count(ofTrilean: card.features.fourth)
    }
    
    private func color(ofTrilean trilean: Trilean) -> Color {
        [Color.red, Color.green, Color.blue][Int(trilean.rawValue) - __designTimeInteger("#6125_4", fallback: 1)]
    }
    
    private func count(ofTrilean trilean: Trilean) -> Int {
        Int(trilean.rawValue)
    }
    
    private func opacity(ofTrilean trilean: Trilean) -> CGFloat {
        [__designTimeFloat("#6125_5", fallback: 1.0), __designTimeFloat("#6125_6", fallback: 0.5), __designTimeFloat("#6125_7", fallback: 1.0)][Int(trilean.rawValue) - __designTimeInteger("#6125_8", fallback: 1)]
    }
    
    private func shape(ofTrilean trilean: Trilean) -> some Shape {
        [AnyShape(Pill()), AnyShape(Rhombus()), AnyShape(Squiggle())][Int(trilean.rawValue) - 1]
    }
    
    private struct Constants {
        static let coolSStrokeWidth = 3.0
        static let strokeWidth = 2.0
        static let shapePadding = 10.0
        static let backgroundColors: [CardSelectionState?: Color] = [.selected: Color(hex: 0xedc400), .matched: Color(hex: 0x71b379), .mismatched: Color(hex: 0xb25690)]
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
    let selectionState = CardSelectionState.matched
    
    CardView(card: Card(id: __designTimeInteger("#6125_9", fallback: 0b11011111)), isFaceUp: __designTimeBoolean("#6125_10", fallback: false), selectionState: selectionState)
        .aspectRatio(CGFloat(__designTimeFloat("#6125_11", fallback: 2.5))/__designTimeFloat("#6125_12", fallback: 3.5), contentMode: .fit)
        .padding()
        // .background(fillColor)
}

