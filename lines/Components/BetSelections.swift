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
                BetButton(odds: game.awaySpreadOdds.first?.odds ?? 0, line: game.awaySpreadLines.max() ?? 0, book: game.awaySpreadOdds.first?.book ?? "")
                BetButton(odds: game.awayMoneyLineOdds.first?.odds ?? 0, book: game.awayMoneyLineOdds.first?.book ?? "")
                BetButton(odds: game.overOdds.first?.odds ?? 0, line: game.overLines.max() ?? 0, book: game.overOdds.first?.book ?? "", total: .over)
            }
            HStack {
                BetButton(odds: game.homeSpreadOdds.first?.odds ?? 0, line: game.homeSpreadLines.max() ?? 0, book: game.homeSpreadOdds.first?.book ?? "")
                BetButton(odds: game.homeMoneyLineOdds.first?.odds ?? 0, book: game.homeMoneyLineOdds.first?.book ?? "")
                BetButton(odds: game.overOdds.first?.odds ?? 0, line: game.overLines.max() ?? 0, book: game.overOdds.first?.book ?? "", total: .under)
            }
        }
        .environment(gameService)
    }
}
