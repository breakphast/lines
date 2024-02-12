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
            HStack {
                Text("Feb. 17, 2024")
                    .font(.title2.bold())
                
                Spacer()
                
                Text("NHL")
                    .font(.title2.bold())
            }
            .padding(.horizontal, 24)
            
            ScrollView {
                VStack(spacing: 32) {
                    ForEach(gameService.allGames, id: \.id) { game in
                        VStack(spacing: 16) {
                            HStack {
                                // Away team stack
                                HStack(spacing: 2) {
                                    Image(nhlLogos[game.awayTeam] ?? "")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 44, height: 44)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                    VStack(alignment: .leading) {
                                        Text(nhlTeams[game.awayTeam]!)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading) // Adjust for alignment
                                
                                VStack(alignment: .center) {
                                    Text("ESPN+")
                                        .fontWeight(.regular)
                                    Text("8:00PM")
                                    Text("\(nhlTeams[game.awayTeam]!.components(separatedBy: " ")[0]) -1.5")
                                        .fontWeight(.regular)
                                }
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .center)
                                
                                // Home team stack
                                HStack(spacing: 2) {
                                    VStack(alignment: .leading) {
                                        Text(nhlTeams[game.homeTeam]!)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                    Image(nhlLogos[game.homeTeam] ?? "")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 44, height: 44)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing) // Adjust for alignment

                            }
                            .bold()
                            
                            BetSelections(game: game)
                                .environment(gameService)
                            
                            if game.id != gameService.allGames.last?.id {
                                RoundedRectangle(cornerRadius: 1)
                                    .frame(height: 1)
                                    .opacity(0.2)
                            }
                        }
                    }
                }
                .fontDesign(.rounded)
            }
            .scrollIndicators(.hidden)
        .padding([.top, .horizontal])
        }
    }
}

#Preview {
    ContentView()
}
