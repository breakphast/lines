//
//  ContentView.swift
//  lines
//
//  Created by Desmond Fitch on 2/10/24.
//

import SwiftUI

struct ContentView: View {
    @State private var gameService = GameService()
    @State private var sport: String? = "NBA"
    let sports = ["NHL", "NBA", "NFL", "MLB"]
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading) {
                pickersHeader
                    .zIndex(100)
                
                ScrollView {
                    VStack(spacing: 32) {
                        scrollContent
                    }
                }
                .scrollIndicators(.hidden)
                .padding(.top, 16)
                .padding(.horizontal)
            }
        }
        .environment(gameService)
    }
    private var pickersHeader: some View {
        HStack {
            Text(Date().headerDateString())
                .font(.title2.bold())
            
            Spacer()
            
            DropDownView(hint: gameService.activeSport.rawValue, options: sports, selection: $sport)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 8)
    }
    
    private var scrollContent: some View {
        ForEach(gameService.allGames, id: \.id) { game in
            if game.date.headerDateString() == Date().headerDateString() {
                GameModule(game: game, sport: gameService.activeSport)
            }
        }
    }
}

#Preview {
    ContentView()
}
