//
//  ContentView.swift
//  Memorize
//
//  Created by Janiece Eleonor on 10/3/23.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    private let aspectRatio: CGFloat = 2/3
    
    var body: some View {
        VStack {
//            ScrollView {
                cards
                    .animation(.default, value: viewModel.cards)
//            }
            Button("Shuffle") {
                viewModel.shuffle()
            }
        }
        .padding()
    }
    
    private var cards: some View {
        AspectVGrid(viewModel.cards, aspectRatio: aspectRatio) { card in
                VStack {
                    CardView(card)
                    .padding(4)
                    .onTapGesture {
                        viewModel.choose(card)
                    }
                }
                .padding(10)
        }
        .foregroundColor(.blue)
    }
}

struct CardView_Previews: PreviewProvider {
    typealias Card = CardView.Card
    static var previews: some View {
        HStack {
            CardView(Card(isFaceUp: true, content: "G", id: "test1"))
            CardView(Card(isFaceUp: true, content: "X", id: "test1"))
        }
    }
}
