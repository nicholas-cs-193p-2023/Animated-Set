//
//  SetGame.swift
//  Set
//
//  Created by Nicholas Alba on 9/5/24.
//

import Foundation

let game = SetGame()

struct SetGame {
    
    init() {
        deck = SetGame.generateDeck().shuffled()
        for _ in 0..<initialFieldCount {
            field.append(deck.removeFirst())
        }
        print("Field: \(field.count)")
        print("Deck: \(deck.count)")
    }
    
    private let initialFieldCount = 12
    private(set) var field: [Card] = []
    private(set) var deck: [Card]
    private(set) var discardPile: [Card] = []
    
    private var chosenCards: Set<Card> = []
    
    func isChosen(_ card: Card) -> Bool {
        chosenCards.contains(card)
    }
    
    var chosenCardCount: Int {
        chosenCards.count
    }
    
    mutating func startNewGame() {
        field.removeAll()
        discardPile.removeAll()
        deck = SetGame.generateDeck().shuffled()
        for _ in 0..<initialFieldCount {
            field.append(deck.removeFirst())
        }
    }
    
    mutating func choose(_ card: Card) {
        if chosenCards.count < 3 {
            if chosenCards.contains(card) {
                chosenCards.remove(card)
            } else {
                chosenCards.insert(card)
            }
            return
        }
        
        if chosenCardsMatch() {
            let cardPreviouslySelected = chosenCards.contains(card)
            removeMatchingCards()
            if !cardPreviouslySelected {
                chosenCards.insert(card)
            }
        } else {
            chosenCards.removeAll()
            chosenCards.insert(card)
        }
    }
    
    mutating func dealMoreCards() {
        guard deck.count >= 3 else {
            print("No more cards to deal")
            return
        }
        if chosenCardsMatch() {
            removeMatchingCards()
        }
        for _ in 0..<3 {
            field.append(deck.removeFirst())
        }
    }
    
    private mutating func removeMatchingCards() {
        var chosenCardIndices: [Int] = []
        for chosenCard in chosenCards {
            guard let cardIndex = field.firstIndex(where: {$0.id == chosenCard.id}) else { return }
            chosenCardIndices.append(cardIndex)
        }
        
        chosenCardIndices.sort { $0 > $1 }
        for cardIndex in chosenCardIndices {
            field.remove(at: cardIndex)
        }
        
        discardPile += Array(chosenCards)
        chosenCards.removeAll()
    }
    
    func chosenCardsMatch() -> Bool {
        if chosenCards.count < 3 { return false }
        
        let chosenCardList = Array(chosenCards)
        let firstCard = chosenCardList[0]
        let secondCard = chosenCardList[1]
        let thirdCard = chosenCardList[2]
        return SetGame.isMatch(firstCard, secondCard, thirdCard)
    }
    
    // lol
    private static func generateDeck() -> [Card] {
        var deck: [Card] = []
        for first in Trilean.allCases {
            let firstBits = first.rawValue
            for second in Trilean.allCases {
                let secondBits = second.rawValue << 2
                for third in Trilean.allCases {
                    let thirdBits = third.rawValue << 4
                    for fourth in Trilean.allCases {
                        let fourthBits = fourth.rawValue << 6
                        
                        let id = firstBits | secondBits | thirdBits | fourthBits
                        deck.append(Card(id: id))
                    }
                }
            }
        }
        return deck
    }
    
    private static func isMatch(_ one: Card, _ two: Card, _ three: Card) -> Bool {
        for i in 0..<4 {
            let mask: UInt8 = 0b11 << (2 * i)
            let first = one.id & mask
            let second = two.id & mask
            let third = three.id & mask
            
            let isMatch = first == second ? second == third : (second != third && first != third)
            if !isMatch {
                return false
            }
        }
        return true
    }

}

struct Card: CustomStringConvertible, Identifiable, Hashable {
    let id: UInt8
    
    var features: FeatureSet {
        var features: [Trilean] = []
        for i in 0..<4 {
            let mask: UInt8 = 3 << (i * 2)
            let rawValue = (id & mask) >> (i * 2)
            guard let feature = Trilean(rawValue: rawValue) else {
                preconditionFailure("Could not parse trilean value from \(rawValue)")
            }
            features.append(feature)
        }
        return FeatureSet(features[0], features[1], features[2], features[3])
    }
    
    var description: String {
        "Card(id: \(String(id, radix: 2)))"
    }
}

struct FeatureSet {
    init(_ first: Trilean, _ second: Trilean, _ third: Trilean, _ fourth: Trilean) {
        self.first = first
        self.second = second
        self.third = third
        self.fourth = fourth
    }
    
    var first: Trilean
    var second: Trilean
    var third: Trilean
    var fourth: Trilean
}

enum Trilean: UInt8, CaseIterable {
    case first = 1
    case second = 2
    case third = 3
}
