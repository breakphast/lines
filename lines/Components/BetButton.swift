//
//  BetButton.swift
//  lines
//
//  Created by Desmond Fitch on 2/12/24.
//

import SwiftUI

enum TotalType {
    case over
    case under
}

struct BetButton: View {
    @Environment(GameService.self) var gameService
    
    @State var odds: Int
    @State var line: Double? = nil
    @State var book: String
    @State var total: TotalType? = nil
    
    var body: some View {
        HStack {
            Text(lineText)
                .font(.system(.caption, design: .monospaced))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, total == nil ? 24 : gameService.activeSport == .nba ? 14 : 20)
                .fontWeight(.heavy)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
        }
        .frame(height: 44)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(book).opacity(0.7))
                .shadow(color: Color(book).opacity(0.3), radius: 2, x: 1, y: 1)
        )
        .overlay { imageOverlay }
    }
    
    private var lineText: String {
        let formattedOdds = odds > 0 ? "+\(odds)" : "\(odds)"
        if let line = line {
            if let total {
                let formattedLine = "\(total == .over ? "O \(line)" : "U \(line)")"
                return "\(formattedLine)\n\(formattedOdds)"
            } else {
                let formattedLine = line > 0 ? "+\(line)" : "\(line)"
                return "\(formattedLine)\n\(formattedOdds)"
            }
        } else {
            return formattedOdds
        }
    }
    
    private var imageOverlay: some View {
        Image(book)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 44)
            .clipShape(.rect(cornerRadius: 8, style: .continuous))
            .frame(maxWidth: .infinity, alignment: .trailing)
            .shadow(color: Color(book).opacity(0.8), radius: 2, x: -2, y: 0)
    }
}

extension BetButton {
    func setBookLogo(_ bookTitle: String) {
        book = bookTitle
    }
}

#Preview {
    VStack {
        HStack {
            BetButton(odds: 100, book: "FanDuel")
        }
        HStack {
            BetButton(odds: 100, book: "FanDuel")
        }
    }
    .environment(GameService())
    .padding()
}
