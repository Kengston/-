//
//  Concentration.swift
//  Концентрация игра
//
//  Created by Данил Лысиков on 01.03.2020.
//  Copyright © 2020 Данил Лысиков. All rights reserved.
//

import Foundation

class Concentration
{
    private(set) var cards = [Card]()
    
    private(set) var flipCount = 0
    
    private(set) var score = 0
    private var seenCards: Set<Int> = []
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    if foundIndex == nil {
                        foundIndex = index
                    } else {
                        return nil
                    }
                }
            }
            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
            
        }
    }
    
    private struct Points {
        static let matchBonus = 2
        static let missMatchPenalty = 1
    }
    
    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): choosen index not in the cards")
        if !cards[index].isMatched {
            flipCount += 1
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                //check if cards match
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    
                    //increase the score
                    score += Points.matchBonus
                } else {
                    if seenCards.contains(index) {
                        score -= Points.missMatchPenalty
                    }
                    if seenCards.contains(matchIndex) {
                        score -= Points.missMatchPenalty
                    }
                    seenCards.insert(index)
                    seenCards.insert(matchIndex)
                }
                cards[index].isFaceUp = true
                
            } else {  
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    func resetGame (){
        flipCount = 0
        score = 0
        seenCards = []
        for index in cards.indices {
            cards[index].isFaceUp = false
            cards[index].isMatched = false
        }
        cards.shuffle()
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.chooseCard(\(numberOfPairsOfCards)): you must have at least 1 pair of cards")
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
           
        }
        cards.shuffle()	
     }
}


