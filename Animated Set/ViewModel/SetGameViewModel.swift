//
//  SetGameViewModel.swift
//  Set
//
//  Created by Nicholas Alba on 9/29/24.
//

import Foundation

class SetGameViewModel: ObservableObject {
    init() {
        game = SetGame()
    }
    
    @Published private var game: SetGame
    
    var cards: [Card] {
        game.field
    }
    
    var deckIsEmpty: Bool {
        game.deck.isEmpty
    }
    
    func selectionState(_ card: Card) -> CardSelectionState? {
        if !game.isChosen(card) { return nil }
        if game.chosenCardCount < 3 { return .selected }
        return game.chosenCardsMatch() ? .matched : .mismatched
    }
    
    // MARK: Intents
    
    func choose(_ card: Card) {
        game.choose(card)
    }
    
    func startNewGame() {
        game.startNewGame()
    }
    
    func dealMoreCards() {
        game.dealMoreCards()
    }
}

enum CardSelectionState {
    case selected
    case matched
    case mismatched
}
