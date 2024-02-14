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
        self.spread = min(game.homeSpreadLines.first ?? 0, game.awaySpreadLines.first ?? 0).description
        teamAssets = sport == .nba ? [nbaTeams, nbaTeams2] : [nhlTeams, nhlTeams2]
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                awayTeamStack
                matchupInfoStack
                homeTeamStack
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
                    .foregroundStyle(.secondary.opacity(0.1))
            }
        }
    }
    
    private var awayTeamStack: some View {
        HStack(spacing: 2) {
            Spacer()
            Image(teamAssets[0][game.awayTeam] ?? "")
                .resizable()
                .aspectRatio(contentMode: .fit)
//                        .frame(width: 44, height: 44)
                .frame(width: gameService.activeSport == .nba ? 33 : 44, height: gameService.activeSport == .nba ? 33 : 44)
            Spacer()
            VStack(alignment: .leading) {
                Text(teamAssets[1][game.awayTeam] ?? "")
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .lineLimit(2)
    }
    private var matchupInfoStack: some View {
        VStack(alignment: .center) {
            Text(game.date.toEasternTimeString())
            Text("\((teamAssets[0][game.spreadAdvantageTeam] ?? "").components(separatedBy: " ")[0]) \(spread ?? "")")
                .fontWeight(.regular)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    private var homeTeamStack: some View {
        HStack(spacing: 2) {
            VStack(alignment: .leading) {
                Text(teamAssets[1][game.homeTeam] ?? "")
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
            Image(teamAssets[0][game.homeTeam] ?? "")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: gameService.activeSport == .nba ? 33 : 44, height: gameService.activeSport == .nba ? 33 : 44)
//                        .frame(width: 44, height: 44)
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
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

