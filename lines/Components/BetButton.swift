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
    @State var image: Image
    @State var total: TotalType? = nil
    
    var body: some View {
        ZStack {
            Text(lineText)
                .font(.system(.body, design: .monospaced))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                .overlay {
                    imageOverlay
                }
                .fontWeight(.heavy)
                .frame(height: 55)
                .foregroundStyle(.white)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.penk.opacity(0.7))
                )
        }
    }
    
    private var lineText: String {
        let formattedOdds = odds > 0 ? "+\(odds)" : "\(odds)"
        if let line = line {
            if let total {
                let formattedLine = "\(total == .over ? "O\(line)" : "U\(line)")"
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
        image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 55)
            .clipShape(.rect(cornerRadius: 8, style: .continuous))
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

extension BetButton {
    func setBookLogo(_ bookTitle: String) {
        image = Image(bookTitle)
    }
}

#Preview {
    VStack {
        HStack {
            BetButton(odds: 100, image: Image(.betRivers))
            BetButton(odds: 100, image: Image(.betRivers))
            BetButton(odds: 100, image: Image(.betRivers))
        }
        HStack {
            BetButton(odds: -100, image: Image(.betRivers))
            BetButton(odds: 100, image: Image(.betRivers))
            BetButton(odds: 100, image: Image(.betRivers))
        }
    }
    .environment(GameService())
    .padding()
}
