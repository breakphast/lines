//
//  Game.swift
//  lines
//
//  Created by Desmond Fitch on 2/10/24.
//

import SwiftUI
import Combine

import Foundation

struct BookOdds: Codable {
    let book: String
    var odds: Int
}

class Game: Identifiable, Codable {
    let id, homeTeam, awayTeam: String
    var date: Date
    var completed: Bool
    var bookmakers: [Bookmaker]
    
    // Odds information could be arrays to represent multiple bookmakers
    var awaySpreadLines: [Double]
    var awaySpreadOdds: [BookOdds]
    var homeSpreadLines: [Double]
    var homeSpreadOdds: [BookOdds]

    var homeMoneyLineOdds: [BookOdds]
    var awayMoneyLineOdds: [BookOdds]
    
    var overLines: [Double]
    var overOdds: [BookOdds]
    var underLines: [Double]
    var underOdds: [BookOdds]
    
    var spreadAdvantageTeam: String
    
    init(gameElement: GameElement) {
        // Temp collections to hold data from multiple bookmakers
        var homeSpreadLinesTemp: [Double] = []
        var awaySpreadLinesTemp: [Double] = []
        var homeMoneyLineOddsTemp = [BookOdds]()
        var awayMoneyLineOddsTemp = [BookOdds]()
        var overLinesTemp: [Double] = []
        var underLinesTemp: [Double] = []
        var homeSpreadOddsTemp = [BookOdds]()
        var awaySpreadOddsTemp = [BookOdds]()
        var overOddsTemp = [BookOdds]()
        var underOddsTemp = [BookOdds]()

        gameElement.bookmakers.forEach { bookmaker in
            bookmaker.markets.forEach { market in
                switch market.key {
                case .h2H:
                    market.outcomes.forEach { outcome in
                        if outcome.name == gameElement.homeTeam {
                            homeMoneyLineOddsTemp.append(BookOdds(book: bookmaker.title, odds: outcome.price))
                        } else if outcome.name == gameElement.awayTeam {
                            awayMoneyLineOddsTemp.append(BookOdds(book: bookmaker.title, odds: outcome.price))
                        }
                    }
                case .spreads:
                    market.outcomes.forEach { outcome in
                        if outcome.name == gameElement.homeTeam {
                            homeSpreadLinesTemp.append(outcome.point ?? 0.0)
                            homeSpreadOddsTemp.append(BookOdds(book: bookmaker.title, odds: outcome.price))
                        } else if outcome.name == gameElement.awayTeam {
                            awaySpreadLinesTemp.append(outcome.point ?? 0.0)
                            awaySpreadOddsTemp.append(BookOdds(book: bookmaker.title, odds: outcome.price))
                        }
                    }
                case .totals:
                    market.outcomes.forEach { outcome in
                        if outcome.name == "Over" {
                            overLinesTemp.append(outcome.point ?? 0.0)
                            overOddsTemp.append(BookOdds(book: bookmaker.title, odds: outcome.price))
                        } else if outcome.name == "Under" {
                            underLinesTemp.append(outcome.point ?? 0.0)
                            underOddsTemp.append(BookOdds(book: bookmaker.title, odds: outcome.price))
                        }
                    }
                }
            }
        }
        
        self.id = gameElement.id
        self.homeTeam = gameElement.homeTeam
        self.awayTeam = gameElement.awayTeam
        self.date = gameElement.commenceTime
        
        self.completed = gameElement.completed ?? false
        self.bookmakers = gameElement.bookmakers
        
        self.homeMoneyLineOdds = homeMoneyLineOddsTemp.sorted { $0.odds > $1.odds }
        self.awayMoneyLineOdds = awayMoneyLineOddsTemp.sorted { $0.odds > $1.odds }
        
        self.homeSpreadLines = homeSpreadLinesTemp
        self.homeSpreadOdds = homeSpreadOddsTemp.sorted { $0.odds > $1.odds }

        self.awaySpreadLines = awaySpreadLinesTemp
        self.awaySpreadOdds = awaySpreadOddsTemp.sorted { $0.odds > $1.odds }

        self.overLines = overLinesTemp
        self.overOdds = overOddsTemp.sorted { $0.odds > $1.odds }

        self.underLines = underLinesTemp
        self.underOdds = underOddsTemp.sorted { $0.odds > $1.odds }
        
        var team = ""
        if let spread = homeSpreadLinesTemp.first {
            team = spread < 0 ? gameElement.homeTeam : gameElement.awayTeam
        }
        self.spreadAdvantageTeam = team
    }
}


// MARK: - GameElement
struct GameElement: Codable {
    let id: String
    let sportKey: SportKey
    let sportTitle: SportTitle
    let commenceTime: Date
    let completed: Bool?
    let homeTeam, awayTeam: String
    let bookmakers: [Bookmaker]

    enum CodingKeys: String, CodingKey {
        case id
        case sportKey = "sport_key"
        case sportTitle = "sport_title"
        case commenceTime = "commence_time"
        case completed
        case homeTeam = "home_team"
        case awayTeam = "away_team"
        case bookmakers
    }
}

// MARK: - Bookmaker
struct Bookmaker: Codable {
    let key, title: String
    let lastUpdate: Date
    let markets: [Market]

    enum CodingKeys: String, CodingKey {
        case key, title
        case lastUpdate = "last_update"
        case markets
    }
}

// MARK: - Market
struct Market: Codable {
    let key: Key
    let lastUpdate: Date
    let outcomes: [Outcome]

    enum CodingKeys: String, CodingKey {
        case key
        case lastUpdate = "last_update"
        case outcomes
    }
}

enum Key: String, Codable {
    case h2H = "h2h"
    case spreads = "spreads"
    case totals = "totals"
}

// MARK: - Outcome
struct Outcome: Codable {
    let name: String
    let price: Int
    let point: Double?
}

enum SportKey: String, Codable {
    case icehockeyNhl = "icehockey_nhl"
    case basketball_nba = "basketball_nba"
}

enum SportTitle: String, Codable {
    case nhl = "NHL"
    case nba = "NBA"
}



let nhlLogos = [
    "Anaheim Ducks": "anaheim-ducks-logo",
    "Arizona Coyotes": "arizona-coyotes-logo",
    "Boston Bruins": "boston-bruins-logo",
    "Buffalo Sabres": "buffalo-sabres-logo",
    "Calgary Flames": "calgary-flames-logo",
    "Carolina Hurricanes": "carolina-hurricanes-logo",
    "Chicago Blackhawks": "chicago-blackhawks-logo",
    "Colorado Avalanche": "colorado-avalanche-logo",
    "Columbus Blue Jackets": "columbus-blue-jackets-logo",
    "Dallas Stars": "dallas-stars-logo",
    "Detroit Red Wings": "detroit-red-wings-logo",
    "Edmonton Oilers": "edmonton-oilers-logo",
    "Florida Panthers": "florida-panthers-logo",
    "Los Angeles Kings": "los-angeles-kings-logo",
    "Minnesota Wild": "minnesota-wild-logo",
    "Montréal Canadiens": "montreal-canadiens-logo",
    "Nashville Predators": "nashville-predators-logo",
    "New Jersey Devils": "new-jersey-devils-logo",
    "New York Islanders": "new-york-islanders-logo",
    "New York Rangers": "new-york-rangers-logo",
    "Ottawa Senators": "ottawa-senators-logo",
    "Philadelphia Flyers": "philadelphia-flyers-logo",
    "Pittsburgh Penguins": "pittsburgh-penguins-logo",
    "San Jose Sharks": "san-jose-sharks-logo",
    "Seattle Kraken": "seattle-kraken-logo",
    "St Louis Blues": "st-louis-blues-logo",
    "Tampa Bay Lightning": "tampa-bay-lightning-logo",
    "Toronto Maple Leafs": "toronto-maple-leafs-logo",
    "Vancouver Canucks": "vancouver-canucks-logo",
    "Vegas Golden Knights": "vegas-golden-knights-logo",
    "Washington Capitals": "washington-capitals-logo",
    "Winnipeg Jets": "winnipeg-jets-logo"
]

let nhlTeams = [
    "Anaheim Ducks": "ANA Ducks",
    "Arizona Coyotes": "ARI Coyotes",
    "Boston Bruins": "BOS Bruins",
    "Buffalo Sabres": "BUF Sabres",
    "Calgary Flames": "CGY Flames",
    "Carolina Hurricanes": "CAR Hurricanes",
    "Chicago Blackhawks": "CHI Blackhawks",
    "Colorado Avalanche": "COL Avalanche",
    "Columbus Blue Jackets": "CBJ Blue Jackets",
    "Dallas Stars": "DAL Stars",
    "Detroit Red Wings": "DET Red Wings",
    "Edmonton Oilers": "EDM Oilers",
    "Florida Panthers": "FLA Panthers",
    "Los Angeles Kings": "LA Kings",
    "Minnesota Wild": "MIN Wild",
    "Montréal Canadiens": "MTL Canadiens",
    "Nashville Predators": "NSH Predators",
    "New Jersey Devils": "NJ Devils",
    "New York Islanders": "NYI Islanders",
    "New York Rangers": "NYR Rangers",
    "Ottawa Senators": "OTT Senators",
    "Philadelphia Flyers": "PHI Flyers",
    "Pittsburgh Penguins": "PIT Penguins",
    "San Jose Sharks": "SJ Sharks",
    "Seattle Kraken": "SEA Kraken",
    "St Louis Blues": "STL Blues",
    "Tampa Bay Lightning": "TB Lightning",
    "Toronto Maple Leafs": "TOR Maple Leafs",
    "Vancouver Canucks": "VAN Canucks",
    "Vegas Golden Knights": "VGK Golden Knights",
    "Washington Capitals": "WAS Capitals",
    "Winnipeg Jets": "WPG Jets"
]

let nhlTeams2 = [
    "Anaheim Ducks": "ANA\nDucks",
    "Arizona Coyotes": "ARI\nCoyotes",
    "Boston Bruins": "BOS\nBruins",
    "Buffalo Sabres": "BUF\nSabres",
    "Calgary Flames": "CGY\nFlames",
    "Carolina Hurricanes": "CAR\nHurricanes",
    "Chicago Blackhawks": "CHI\nBlackhawks",
    "Colorado Avalanche": "COL\nAvalanche",
    "Columbus Blue Jackets": "CBJ\nBlue Jackets",
    "Dallas Stars": "DAL\nStars",
    "Detroit Red Wings": "DET\nRed Wings",
    "Edmonton Oilers": "EDM\nOilers",
    "Florida Panthers": "FLA\nPanthers",
    "Los Angeles Kings": "LA\nKings",
    "Minnesota Wild": "MIN\nWild",
    "Montréal Canadiens": "MTL\nCanadiens",
    "Nashville Predators": "NSH\nPredators",
    "New Jersey Devils": "NJ\nDevils",
    "New York Islanders": "NYI\nIslanders",
    "New York Rangers": "NYR\nRangers",
    "Ottawa Senators": "OTT\nSenators",
    "Philadelphia Flyers": "PHI\nFlyers",
    "Pittsburgh Penguins": "PIT\nPenguins",
    "San Jose Sharks": "SJ\nSharks",
    "Seattle Kraken": "SEA\nKraken",
    "St Louis Blues": "STL\nBlues",
    "Tampa Bay Lightning": "TB\nLightning",
    "Toronto Maple Leafs": "TOR\nMaple Leafs",
    "Vancouver Canucks": "VAN\nCanucks",
    "Vegas Golden Knights": "VGK\nGolden Knights",
    "Washington Capitals": "WAS\nCapitals",
    "Winnipeg Jets": "WPG\nJets"
]

let nbaTeams = [
    "Atlanta Hawks": "ATL Hawks",
    "Boston Celtics": "BOS Celtics",
    "Brooklyn Nets": "BKN Nets",
    "Charlotte Hornets": "CHA Hornets",
    "Chicago Bulls": "CHI Bulls",
    "Cleveland Cavaliers": "CLE Cavaliers",
    "Dallas Mavericks": "DAL Mavericks",
    "Denver Nuggets": "DEN Nuggets",
    "Detroit Pistons": "DET Pistons",
    "Golden State Warriors": "GSW Warriors",
    "Houston Rockets": "HOU Rockets",
    "Indiana Pacers": "IND Pacers",
    "LA Clippers": "LAC Clippers",
    "Los Angeles Lakers": "LAL Lakers",
    "Memphis Grizzlies": "MEM Grizzlies",
    "Miami Heat": "MIA Heat",
    "Milwaukee Bucks": "MIL Bucks",
    "Minnesota Timberwolves": "MIN Timberwolves",
    "New Orleans Pelicans": "NOP Pelicans",
    "New York Knicks": "NY Knicks",
    "Oklahoma City Thunder": "OKC Thunder",
    "Orlando Magic": "ORL Magic",
    "Philadelphia 76ers": "PHI 76ers",
    "Phoenix Suns": "PHX Suns",
    "Portland Trail Blazers": "POR Trail Blazers",
    "Sacramento Kings": "SAC Kings",
    "San Antonio Spurs": "SAS Spurs",
    "Toronto Raptors": "TOR Raptors",
    "Utah Jazz": "UTA Jazz",
    "Washington Wizards": "WAS Wizards"
]

let nbaTeams2 = [
    "Atlanta Hawks": "ATL\nHawks",
    "Boston Celtics": "BOS\nCeltics",
    "Brooklyn Nets": "BKN\nNets",
    "Charlotte Hornets": "CHA\nHornets",
    "Chicago Bulls": "CHI\nBulls",
    "Cleveland Cavaliers": "CLE\nCavaliers",
    "Dallas Mavericks": "DAL\nMavericks",
    "Denver Nuggets": "DEN\nNuggets",
    "Detroit Pistons": "DET\nPistons",
    "Golden State Warriors": "GSW\nWarriors",
    "Houston Rockets": "HOU\nRockets",
    "Indiana Pacers": "IND\nPacers",
    "LA Clippers": "LAC\nClippers",
    "Los Angeles Lakers": "LAL\nLakers",
    "Memphis Grizzlies": "MEM\nGrizzlies",
    "Miami Heat": "MIA\nHeat",
    "Milwaukee Bucks": "MIL\nBucks",
    "Minnesota Timberwolves": "MIN\nTimberwolves",
    "New Orleans Pelicans": "NOP\nPelicans",
    "New York Knicks": "NY\nKnicks",
    "Oklahoma City Thunder": "OKC\nThunder",
    "Orlando Magic": "ORL\nMagic",
    "Philadelphia 76ers": "PHI\n76ers",
    "Phoenix Suns": "PHX\nSuns",
    "Portland Trail Blazers": "POR\nTrail Blazers",
    "Sacramento Kings": "SAC\nKings",
    "San Antonio Spurs": "SAS\nSpurs",
    "Toronto Raptors": "TOR\nRaptors",
    "Utah Jazz": "UTA\nJazz",
    "Washington Wizards": "WAS\nWizards"
]
