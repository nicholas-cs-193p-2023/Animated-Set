import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/nicholasdalba/Developer/Animated Set/Animated Set/View/SetGameView.swift", line: 1)
//
//  ContentView.swift
//  Set
//
//  Created by Nicholas Alba on 8/24/24.
//

import SwiftUI

struct SetGameView: View {
    init(viewModel: SetGameViewModel) {
        self.viewModel = viewModel
        self.cardsInDeck = viewModel.deck
        self.cardsInField = viewModel.cards
        self.cardsInDiscardPile = []
    }
    
    @ObservedObject var viewModel: SetGameViewModel
    @State private var cardsInDeck: [Card]
    @State private var cardsInField: [Card]
    @State private var cardsInDiscardPile: [Card]
    
    @Namespace private var cardDealingNamespace
    @Namespace private var cardRemovalNamespace
    
    private var rotationAnimation = Animation.linear(duration: 3)
    
    var body: some View {
        cards
        buttons
    }
    
    var cards: some View {
        AspectVGrid(cardsInField, aspectRatio: Constants.aspectRatio, minimumGridItemWidth: Constants.minimumGridItemWidth) { card in
            mainGridItemCardView(card)
        }
        .padding()
        .onChange(of: viewModel.cards) {
            withAnimation(rotationAnimation) {
                cardsInField = viewModel.cards
                cardsInDeck = viewModel.deck
            }
        }
    }
    
    @ViewBuilder
    func mainGridItemCardView(_ card: Card) -> some View {
        let selectionState = viewModel.selectionState(card)
        CardView(card: card, isFaceUp: __designTimeBoolean("#5978_0", fallback: true), selectionState: selectionState)
            .padding(Constants.cardPadding)
            .transition(AnyTransition.flip(isFaceUp: __designTimeBoolean("#5978_1", fallback: true)))
            .matchedGeometryEffect(id: card.id, in: cardDealingNamespace)
            .transition(AnyTransition.asymmetric(insertion: .identity, removal: .identity))
            .matchedGeometryEffect(id: card.id, in: cardRemovalNamespace)
            .onTapGesture {
                withAnimation(.easeInOut(duration: __designTimeInteger("#5978_2", fallback: 1))) {
                    viewModel.choose(card)
                }
            }
    }
    
    var buttons: some View {
        HStack {
            discardPileView
            Spacer()
            newGameButton
            Spacer()
            deck
        }.padding(.horizontal)
    }
    
    @ViewBuilder
    var discardPileView: some View {
        if viewModel.discardPile.isEmpty {
            invisibleDiscardPile
        } else {
            discardPile
        }
    }
    
    var invisibleDiscardPile: some View {
        CardView(card: Card(id: __designTimeInteger("#5978_3", fallback: 0b11011111)), isFaceUp: __designTimeBoolean("#5978_4", fallback: false))
            .aspectRatio(Constants.aspectRatio, contentMode: .fit)
            .frame(height: Constants.deckHeight)
            .opacity(__designTimeFloat("#5978_5", fallback: 0.0))
    }
    
    var discardPile: some View {
        ZStack {
            ForEach(cardsInDiscardPile) { card in
                CardView(card: card, isFaceUp: __designTimeBoolean("#5978_6", fallback: true))
                    .aspectRatio(Constants.aspectRatio, contentMode: .fit)
                    .frame(height: Constants.deckHeight)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .identity))
                    .matchedGeometryEffect(id: card.id, in: cardRemovalNamespace)
            }
        }
    }
    
    var newGameButton: some View {
        bottomButton(__designTimeString("#5978_7", fallback: "New Game")) {
            withAnimation(rotationAnimation) {
                viewModel.startNewGame()
            }
        }
    }
    
    var deck: some View {
        ZStack {
            ForEach(cardsInDeck) { card in
                CardView(card: card, isFaceUp: __designTimeBoolean("#5978_8", fallback: false))
                    .aspectRatio(Constants.aspectRatio, contentMode: .fit)
                    .frame(height: Constants.deckHeight)
                    .transition(AnyTransition.flip(isFaceUp: __designTimeBoolean("#5978_9", fallback: false)))
                    .matchedGeometryEffect(id: card.id, in: cardDealingNamespace)
            }
        }.onTapGesture {
            withAnimation(.linear(duration: __designTimeInteger("#5978_10", fallback: 5))) {
                viewModel.dealMoreCards()
            }
        }
    }
    
    func bottomButton(_ text: String, disabled: Bool = false, _ action: @escaping () -> Void) -> some View {
        Button(text) {
            action()
        }.disabled(disabled)
            .fontWeight(.semibold)
            .padding(.horizontal)
    }
    
    private struct Constants {
        static let aspectRatio = CGFloat(2.5)/CGFloat(3.5)
        static let cardPadding = 4.0
        static let deckHeight = 96.0
        static let minimumGridItemWidth = 64.0
    }
}

extension AnyTransition {
    static func flip(isFaceUp: Bool) -> AnyTransition {
        AnyTransition.asymmetric(
            insertion: AnyTransition.modifier(
                active: FlipModifier(isFaceUp: isFaceUp, rotation: isFaceUp ? __designTimeInteger("#5978_11", fallback: 0) : __designTimeInteger("#5978_12", fallback: 180)),
                identity: FlipModifier(isFaceUp: isFaceUp, rotation: isFaceUp ? __designTimeInteger("#5978_13", fallback: 180) : __designTimeInteger("#5978_14", fallback: 0))
            ),
            removal: AnyTransition.modifier(
                active: FlipModifier(isFaceUp: isFaceUp, rotation: isFaceUp ? __designTimeInteger("#5978_15", fallback: 0) : __designTimeInteger("#5978_16", fallback: 180)),
                identity: FlipModifier(isFaceUp: isFaceUp, rotation: isFaceUp ? __designTimeInteger("#5978_17", fallback: 180) : __designTimeInteger("#5978_18", fallback: 0))
            )
        )
    }
}


struct FlipModifier: ViewModifier, Animatable {
    let isFaceUp: Bool
    var rotation: Double
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    func body(content: Content) -> some View {
        let showBody = shouldShowBody
        content.opacity(showBody ? __designTimeInteger("#5978_19", fallback: 1) : __designTimeInteger("#5978_20", fallback: 0))
            .rotation3DEffect(.degrees(rotation), axis: (x: __designTimeInteger("#5978_21", fallback: 0), y: __designTimeInteger("#5978_22", fallback: 1), z: __designTimeInteger("#5978_23", fallback: 0)), perspective: __designTimeInteger("#5978_24", fallback: 0))
    }
    
    var shouldShowBody: Bool {
        isFaceUp ? (rotation > __designTimeInteger("#5978_25", fallback: 90)) : (rotation < __designTimeInteger("#5978_26", fallback: 90))
    }
}


extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 8) & 0xff) / 255,
            blue: Double(hex & 0xff) / 255,
            opacity: alpha
        )
    }
}

#Preview {
    SetGameView(viewModel: SetGameViewModel())
}
