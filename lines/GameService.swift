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
    
    private var gameSubscription: AnyCancellable?
    
    var decoder = JSONDecoder()
    
    init() {
        decoder.dateDecodingStrategy = .iso8601
        getGamesLocally()
    }
    
    private func getGames() {
        guard let url = URL(string: "https://api.the-odds-api.com/v4/sports/icehockey_nhl/odds/?apiKey=4361370f2df59d9c4aabf5b7ff5fd438&regions=us&markets=h2h,spreads,totals&oddsFormat=american&bookmakers=fanduel,draftkings,betmgm") else {
            return
        }
        
        gameSubscription = download(url: url)
            .decode(type: [GameElement].self, decoder: decoder)
            .sink(receiveCompletion: handleCompletion, receiveValue: { [weak self] returnedGames in

                let games = returnedGames.map { Game(gameElement: $0) }
                self?.allGames = games
                
            })
    }
    
    private func getGamesLocally() {
        gameSubscription = loadLocalNHLData()
            .decode(type: [GameElement].self, decoder: decoder)
            .sink(receiveCompletion: handleCompletion, receiveValue: { [weak self] returnedGames in
                guard let self = self else { return }
                
                let games = returnedGames.map { Game(gameElement: $0) }
                self.allGames = games
            })
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
    
    private func loadLocalNHLData() -> AnyPublisher<Data, Error> {
        guard let url = Bundle.main.url(forResource: "nhlOdds", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return Fail(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to locate nflOddsData.json"]))
                .eraseToAnyPublisher()
        }
        
        return Just(data)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
