//
//  ContentView.swift
//  lines
//
//  Created by Desmond Fitch on 2/10/24.
//

import SwiftUI

struct ContentView: View {
    @State private var gameService = GameService()
    
    var body: some View {
        VStack(alignment: .leading) {
            pickersHeader
            
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
    private var pickersHeader: some View {
        HStack {
            Text(Date().headerDateString())
                .font(.title2.bold())
            
            Spacer()
            
            Button {
                
            } label: {
                Text(gameService.activeSport.rawValue)
                    .font(.title2.bold())
            }
            .buttonStyle(.borderedProminent)
            .tint(.penk.opacity(0.7))
        }
        .padding(.horizontal, 24)
    }
    
    private var scrollContent: some View {
        ForEach(gameService.allGames, id: \.id) { game in
            if game.date.headerDateString() == Date().headerDateString() {
                GameModule(game: game)
                    .environment(gameService)
            }
        }
    }
}

#Preview {
    ContentView()
}
