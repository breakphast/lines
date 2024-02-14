//
//  Helpers.swift
//  lines
//
//  Created by Desmond Fitch on 2/14/24.
//

import Foundation

class Helpers {
    static func sportURL(sportKey: SportKey, apiKey: String) -> URL {
        return URL(string: "https://api.the-odds-api.com/v4/sports/\(sportKey)/odds/?apiKey=\(apiKey)&regions=us&markets=h2h,spreads,totals&oddsFormat=american&bookmakers=fanduel,draftkings,betrivers,pointsbetus,unibet_us,espnbet,betmgm")!
    }
}
