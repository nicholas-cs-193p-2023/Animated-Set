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
            ForEach(0..<shapeCount, id: \.self) { index in
                shapeWithColor.aspectRatio(2.0, contentMode: .fit)
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
            let opacity = features.third == .second ? 0.5 : 1.0
            shape.fill(color.opacity(opacity))
        }
    }
    
    var shapeCount: Int {
        count(ofTrilean: card.features.fourth)
    }
    
    private func color(ofTrilean trilean: Trilean) -> Color {
        [Color.red, Color.green, Color.blue][Int(trilean.rawValue) - 1]
    }
    
    private func count(ofTrilean trilean: Trilean) -> Int {
        Int(trilean.rawValue)
    }
    
    private func opacity(ofTrilean trilean: Trilean) -> CGFloat {
        [1.0, 0.5, 1.0][Int(trilean.rawValue) - 1]
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
    
    CardView(card: Card(id: 0b11011111), isFaceUp: false, selectionState: selectionState)
        .aspectRatio(CGFloat(2.5)/3.5, contentMode: .fit)
        .padding()
        // .background(fillColor)
}

