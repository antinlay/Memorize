//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Janiece Eleonor on 10/14/23.
//

import Foundation
import SwiftUI

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    private(set) var score = 0
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        
        for pairIndex in 0..<max(2,numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: "\(pairIndex+1)a"))
            cards.append(Card(content: content, id: "\(pairIndex+1)b"))
        }
    }
    
    var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { index in cards[index].isFaceUp }.only
        }
        
        set {
            cards.indices.forEach { cards[$0].isFaceUp = (newValue == $0) }
        }
    }
    
    mutating func choose(_ card: Card) {
        //        print("choose \(card)")
        if let choosenIndex = cards.firstIndex(where: { $0.id == card.id }) {
            if !cards[choosenIndex].isFaceUp && !cards[choosenIndex].isMatched {
                if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                    if cards[choosenIndex].content == cards[potentialMatchIndex].content {
                        cards[choosenIndex].isMatched = true
                        cards[potentialMatchIndex].isMatched = true
                        score += 2 + cards[choosenIndex].bonus + cards[potentialMatchIndex].bonus
                    } else {
                        if cards[choosenIndex].hasBeenSeen {
                            score -= 1
                        }
                        if cards[potentialMatchIndex].hasBeenSeen {
                            score -= 1
                        }
                    }
                    
                } else {
                    indexOfTheOneAndOnlyFaceUpCard = choosenIndex
                }
                cards[choosenIndex].isFaceUp = true
            }
        }
        
    }
    
    mutating func shuffle() {
        cards.shuffle()
        print(cards)
    }
    
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                }
                if oldValue && !isFaceUp {
                    hasBeenSeen = true
                }
            }
        }
        var hasBeenSeen = false
        var isMatched = false {
            didSet {
                if isMatched {
                    stopUsingBonusTime()
                }
            }
        }
        let content: CardContent
        
        // MARK: - Bonus Time
        
        var lastFaceUpDate: Date?
        var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        var pastFaceUpTime: TimeInterval = 0
        var bonusTimeLimit: TimeInterval = 6
        
        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isFaceUp && !isMatched && bonusPercentRemaining > 0, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
        
        var bonus: Int {
            Int(bonusTimeLimit * bonusPercentRemaining)
        }
        
        var bonusPercentRemaining: Double {
            bonusTimeLimit > 0 ? max(0, bonusTimeLimit - faceUpTime) / bonusTimeLimit : 0
        }
        
        
        
        var id: String
        var debugDescription: String {
            return "\(id): \(content) \(isFaceUp ? "up" : "down")\(isMatched ? " matched" : "")"
        }
    }
}

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
