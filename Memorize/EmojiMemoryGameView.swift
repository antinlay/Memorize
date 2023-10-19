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
    private let spacing: CGFloat = 4
    
    var body: some View {
        VStack {
            cards
            .foregroundColor(viewModel.color)
            Button("Shuffle") {
                withAnimation(.interactiveSpring()) {
                    viewModel.shuffle()
                }
            }
        }
        .padding()
    }
    
    private var cards: some View {
        AspectVGrid(viewModel.cards, aspectRatio: aspectRatio) { card in
                VStack {
                    CardView(card)
                    .padding(spacing)
                    .onTapGesture {
                        viewModel.choose(card)
                    }
                }
        }
    }
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
