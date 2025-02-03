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
        CardView(card: card, isFaceUp: true, selectionState: selectionState)
            .padding(Constants.cardPadding)
            .transition(AnyTransition.flip(isFaceUp: true))
            .matchedGeometryEffect(id: card.id, in: cardDealingNamespace)
            .transition(AnyTransition.asymmetric(insertion: .identity, removal: .identity))
            .matchedGeometryEffect(id: card.id, in: cardRemovalNamespace)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 1)) {
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
        CardView(card: Card(id: 0b11011111), isFaceUp: false)
            .aspectRatio(Constants.aspectRatio, contentMode: .fit)
            .frame(height: Constants.deckHeight)
            .opacity(0.0)
    }
    
    var discardPile: some View {
        ZStack {
            ForEach(cardsInDiscardPile) { card in
                CardView(card: card, isFaceUp: true)
                    .aspectRatio(Constants.aspectRatio, contentMode: .fit)
                    .frame(height: Constants.deckHeight)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .identity))
                    .matchedGeometryEffect(id: card.id, in: cardRemovalNamespace)
            }
        }
    }
    
    var newGameButton: some View {
        bottomButton("New Game") {
            withAnimation(rotationAnimation) {
                viewModel.startNewGame()
            }
        }
    }
    
    var deck: some View {
        ZStack {
            ForEach(cardsInDeck) { card in
                CardView(card: card, isFaceUp: false)
                    .aspectRatio(Constants.aspectRatio, contentMode: .fit)
                    .frame(height: Constants.deckHeight)
                    .transition(AnyTransition.flip(isFaceUp: false))
                    .matchedGeometryEffect(id: card.id, in: cardDealingNamespace)
            }
        }.onTapGesture {
            withAnimation(.linear(duration: 5)) {
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
                active: FlipModifier(isFaceUp: isFaceUp, rotation: isFaceUp ? 0 : 180),
                identity: FlipModifier(isFaceUp: isFaceUp, rotation: isFaceUp ? 180 : 0)
            ),
            removal: AnyTransition.modifier(
                active: FlipModifier(isFaceUp: isFaceUp, rotation: isFaceUp ? 0 : 180),
                identity: FlipModifier(isFaceUp: isFaceUp, rotation: isFaceUp ? 180 : 0)
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
        content.opacity(showBody ? 1 : 0)
            .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0), perspective: 0)
    }
    
    var shouldShowBody: Bool {
        isFaceUp ? (rotation > 90) : (rotation < 90)
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
