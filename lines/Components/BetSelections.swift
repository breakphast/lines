//
//  BetSelections.swift
//  lines
//
//  Created by Desmond Fitch on 2/12/24.
//

import SwiftUI

struct BetSelections: View {
    @Environment(GameService.self) var gameService
    let game: Game
    
    var body: some View {
        VStack {
            HStack {
                BetButton(odds: game.awaySpreadOdds.first?.odds ?? 0, image: Image(game.awaySpreadOdds.first?.book ?? ""))
                    .onAppear {
                        print(game.awaySpreadOdds.first?.book ?? "natha")
                    }
                BetButton(odds: game.awayMoneyLineOdds.first?.odds ?? 0, image: Image(game.awaySpreadOdds.first?.book ?? ""))
                BetButton(odds: game.overOdds.first?.odds ?? 0, image: Image(game.awaySpreadOdds.first?.book ?? ""))
            }
            HStack {
                BetButton(odds: game.homeSpreadOdds.first?.odds ?? 0, image: Image(game.awaySpreadOdds.first?.book ?? ""))
                BetButton(odds: game.homeMoneyLineOdds.first?.odds ?? 0, image: Image(game.awaySpreadOdds.first?.book ?? ""))
                BetButton(odds: game.underOdds.first?.odds ?? 0, image: Image(game.awaySpreadOdds.first?.book ?? ""))
            }
        }
        .environment(gameService)
    }
}

//#Preview {
//    @Environment(GameService.self) var gameService
//    
//    BetSelections()
//}
