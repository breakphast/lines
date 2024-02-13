//
//  GameModule.swift
//  lines
//
//  Created by Desmond Fitch on 2/12/24.
//

import SwiftUI

struct GameModule: View {
    @Environment(GameService.self) var gameService
    let game: Game
    var spread: String? = nil
    let sport: SportTitle
    
    var teamAssets = [[String : String]]()
    
    init(game: Game, sport: SportTitle) {
        self.game = game
        self.sport = sport
        
        if let homeLine = game.homeSpreadLines.first, let awayLine = game.awaySpreadLines.first {
            self.spread = String(homeLine < awayLine ? homeLine : awayLine)
        }
        switch sport {
        case .nba:
            teamAssets = [nbaTeams, nbaTeams2]
        case .nhl:
            teamAssets = [nhlTeams, nhlTeams2]
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                // Away team stack
                HStack(spacing: 2) {
                    Image(teamAssets[0][game.awayTeam] ?? "")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 44, height: 44)
                    
                    VStack(alignment: .leading) {
                        Text(teamAssets[1][game.awayTeam] ?? "")
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Matchup info stack
                VStack(alignment: .center) {
                    Text(game.date.toEasternTimeString())
                    Text("\((teamAssets[0][game.awayTeam] ?? "").components(separatedBy: " ")[0]) \(spread ?? "")")
                        .fontWeight(.regular)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                // Home team stack
                HStack(spacing: 2) {
                    VStack(alignment: .leading) {
                        Text(teamAssets[1][game.homeTeam] ?? "")
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Image(teamAssets[0][game.homeTeam] ?? "")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 44, height: 44)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
            }
            .bold()
            
            VStack(spacing: 8) {
                labelHeaders
                
                BetSelections(game: game)
                    .environment(gameService)
            }
            
            if game.id != gameService.allGames.filter({ $0.date.headerDateString() == Date().headerDateString() }).last?.id {
                RoundedRectangle(cornerRadius: 1)
                    .frame(height: 1)
                    .opacity(0.2)
            }
        }
        .lineLimit(2)
    }
    
    private var labelHeaders: some View {
        HStack {
            Text("SPREAD")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("MONEY")
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("TOTAL")
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .font(.caption.bold())
        .foregroundStyle(.secondary.opacity(0.7))
        .padding(.horizontal, 32)
    }
}

