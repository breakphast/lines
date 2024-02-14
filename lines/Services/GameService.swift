//
//  GameService.swift
//  lines
//
//  Created by Desmond Fitch on 2/10/24.
//

import SwiftUI
import Combine

@Observable
class GameService {
    var allGames = [Game]()
    var bookiesRanked: [(title: String, odds: Int)]?
    var activeSport: SportTitle = .nba
    var apiKey: String?
    
    private var gameSubscription: AnyCancellable?
    
    private let decoder = JSONDecoder()
    
    init() {
        decoder.dateDecodingStrategy = .iso8601
        if let key = Setup.apiKey {
            self.apiKey = key
            getGames(sport: activeSport == .nba ? .basketball_nba : .icehockeyNhl)
        } else {
            getGamesLocally(sport: activeSport)
        }
    }
    
    private func getGames(sport: SportKey) {
        guard let apiKey else { return }
        
        let url = Helpers.sportURL(sportKey: sport, apiKey: apiKey)
                
        gameSubscription = download(url: url)
            .decode(type: [GameElement].self, decoder: decoder)
            .sink(receiveCompletion: handleCompletion, receiveValue: { [weak self] returnedGames in
                let games = returnedGames.map { Game(gameElement: $0) }
                self?.allGames = games
            })
    }
    
    func getGamesLocally(sport: SportTitle) {
        gameSubscription = loadLocalOddsData(sport: sport)
            .decode(type: [GameElement].self, decoder: decoder)
            .sink(receiveCompletion: handleCompletion, receiveValue: { [weak self] returnedGames in
                guard let self = self else { return }
                let games = returnedGames.map { Game(gameElement: $0) }
                self.allGames = games
            })
    }
    
    func loadLocalOddsData(sport: SportTitle) -> AnyPublisher<Data, Error> {
        let fileName = sport == .nba ? "nbaOdds" : "nhlOdds"
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return Fail(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to locate json file"]))
                .eraseToAnyPublisher()
        }
        
        return Just(data)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func download(url: URL) -> AnyPublisher<Data, any Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({ try self.handleURLResponse(output: $0, url: url) })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingError.badURLResponse(url: url)
        }
        return output.data
    }
    
    func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(NetworkingError.unknown, error.localizedDescription)
        }
    }
    
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url): "[🔥] Bad response from URL: \(url)"
            case .unknown: "[🤷🏽‍♂️] Unknown error occured"
            }
        }
    }
}

extension Date {
    func toEasternTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "America/New_York")
        dateFormatter.dateFormat = "h:mm a"
        
        return dateFormatter.string(from: self)
    }
    func headerDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "America/New_York")
        dateFormatter.dateFormat = "MMM. d, yyyy"
        
        return dateFormatter.string(from: self)
    }
}
