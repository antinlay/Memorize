//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Janiece Eleonor on 10/3/23.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @ObservedObject var game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: game)
        }
    }
}
