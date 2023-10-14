//
//  ContentView.swift
//  Memorize
//
//  Created by Janiece Eleonor on 10/3/23.
//

import SwiftUI

struct ContentView: View {
    let emojis = ["👻", "🎃", "🕷", "😈", "🏀", "🎱"]
    
    var body: some View {
        HStack {
            ForEach(emojis.indices, id: \.self) {
                CardView(content: emojis[$0])
            }
            
        }
        .foregroundColor(.orange)
        .padding()

    }
}
 
struct CardView: View {
    let content: String
    @State var isFaceUp = true
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            if isFaceUp {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(content).font(.largeTitle)
            } else {
                base.fill()
            }
        }
        .onTapGesture {
            isFaceUp.toggle()
        }
    }
}
