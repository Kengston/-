//
//  ViewController.swift
//  Концентрация игра
//
//  Created by Данил Лысиков on 25.02.2020.
//  Copyright © 2020 Данил Лысиков. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    lazy var game: Concentration = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBOutlet weak var newGameButton: UIButton!
    
    @IBAction func newGame() {
        game.resetGame()
        indexTheme = emojiThemes.count.arc4random
        updateViewFromModel()
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indexTheme = emojiThemes.count.arc4random
        updateViewFromModel()
    }
    
    @IBAction private func touchCard(_ sender: UIButton)  {

        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }   else   {
            print("error")
        }
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : cardBackColor
            }
        }
        scoreLabel.text = "Score: \(game.score)"
        flipCountLabel.text = "Flips \(game.flipCount)"
    }
    
    private struct Theme {
        var name: String
        var emojis: [String]
        var viewColor: UIColor
        var cardColor: UIColor
    }
    
    private func updateAppearance() {
        view.backgroundColor = backgroundColor
        flipCountLabel.textColor = cardBackColor
        scoreLabel.textColor = cardBackColor
        titleLabel.textColor = cardBackColor
        newGameButton.setTitleColor(backgroundColor, for: .normal)
        newGameButton.backgroundColor = cardBackColor
    }
    
    private var emojiChoices = ["🎃","👻","🤡","🧦","🌚","🇺🇦","🤪","👨‍👨‍👦","🐊","🐽","🦍","🖕🏿"]
    
    private var emojiThemes: [Theme] = [
        Theme(name: "Fruits",
              emojis: ["🍏","🍎","🍐","🍊","🍋","🍌","🍉","🍇","🍓","🍈","🍒","🥥"],
              viewColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1),
              cardColor: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)),
        Theme(name: "Countries",
              emojis: ["🇺🇦","🇫🇷","🇯🇵","🇷🇺","🇸🇪","🇪🇸","🇬🇧","🇿🇦","🇺🇸","🇹🇷","🇧🇷","🇨🇳"],
              viewColor: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),
              cardColor: #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)),
        Theme(name: "Animals",
              emojis: ["🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼","🐨","🐯","🦁","🐵"],
              viewColor: #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1),
              cardColor: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1))
]
    
    private var indexTheme = 0 {
        didSet {
            print(indexTheme, emojiThemes[indexTheme].name)
            emoji = [Int: String]()
            titleLabel.text = emojiThemes[indexTheme].name
            
            emojiChoices = emojiThemes[indexTheme].emojis
            backgroundColor = emojiThemes[indexTheme].viewColor
            cardBackColor = emojiThemes[indexTheme].cardColor
            
            updateAppearance()
        }
    }
    
    private var backgroundColor = UIColor.black
    private var cardBackColor = UIColor.orange
    private var emoji = [Int:String]()
    
    private func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            emoji[card.identifier] = emojiChoices.remove(at: emojiChoices.count.arc4random)
        }        
        return emoji[card.identifier] ?? "?"
    }
}


extension Array {
    //тассование элементов 'self' "по месту"
    mutating func shuffle() {
        //пустая коллекция и с одним элементом не тасуются
        if count < 2 { return }
        
        for i in indices.dropLast() {
            let diff = distance(from: i, to: endIndex)
            let j = index(i, offsetBy: diff.arc4random)
            swapAt(i, j)
        }
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
