//
//  BetButton.swift
//  lines
//
//  Created by Desmond Fitch on 2/12/24.
//

import SwiftUI

struct BetButton: View {
    @Environment(GameService.self) var gameService
    
    @State var odds: Int
    @State var image: Image
    
    var body: some View {
        ZStack {
            Text(odds > 0 ? "+\(odds)" : "\(odds)")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                .overlay {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 44, height: 44)
                        .clipShape(.rect(cornerRadius: 8, style: .continuous))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .fontWeight(.heavy)
                .frame(height: 44)
                .foregroundStyle(.white)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.penk.opacity(0.7))
                )
        }
    }
}

extension BetButton {
    func setBookLogo(_ bookTitle: String) {
        image = Image(bookTitle)
    }
}

#Preview {
    BetButton(odds: 100, image: Image(.betRivers))
        .environment(GameService())
        .padding()
}
