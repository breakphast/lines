//
//  DropDownView.swift
//  UIPractice
//
//  Created by Desmond Fitch on 12/5/23.
//

import SwiftUI

struct DropDownView: View {
    var hint: String
    var options: [String]
    var anchor: Anchor = .bottom
    var maxWidth: CGFloat = 100
    var cornerRadius: CGFloat = 16
    @Binding var selection: String?
    @State private var showOptions = false
    @Environment(\.colorScheme) private var scheme
    @Environment(GameService.self) var gameService
    @SceneStorage("dropDownZIndex") private var index = 1000.0
    @State private var zIndex: Double = 1000.0
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            VStack {
                if showOptions && anchor == .top {
                    optionsView()
                }
                
                HStack(spacing: 0) {
                    Text(selection ?? hint)
                        .foregroundStyle(selection == nil ? .gray : .primary)
                        .lineLimit(1)
                    
                    Spacer(minLength: 0)
                    
                    Image(systemName: "chevron.down")
                        .font(.title3)
                        .foregroundStyle(.gray)
                        .rotationEffect(.degrees(showOptions ? -180.0 : 0))
                }
                .padding(.horizontal, 15)
                .frame(width: size.width, height: size.height)
                .background(scheme == .dark ? .black : .white)
                .contentShape(.rect)
                .onTapGesture {
                    index += 1
                    zIndex = index
                    withAnimation(.bouncy) {
                        if showOptions {
                            selection = nil
                        }
                        showOptions.toggle()
                    }
                }
                .zIndex(10)
                
                if showOptions && anchor == .bottom {
                    optionsView()
                }
            }
            .clipped()
            .contentShape(.rect)
            .background((scheme == .dark ? Color.black : Color.white).shadow(.drop(color: .primary.opacity(0.15), radius: 4)), in: .rect(cornerRadius: cornerRadius))
            .frame(height: size.height, alignment: anchor == .top ? .bottom : .top)
        }
        .frame(width: maxWidth, height: 50)
        .zIndex(zIndex)
    }
    
    @ViewBuilder
    func optionsView() -> some View {
        VStack(spacing: 10) {
            ForEach(options, id: \.self) { option in
                HStack(spacing: 0) {
                    Text(option)
                        .lineLimit(1)
                    
                    Spacer(minLength: 0)
                    
                    Image(systemName: "checkmark")
                        .opacity(selection == option ? 1 : 0)
                        .font(.caption)
                }
                .foregroundStyle(selection == option ? Color.primary : Color.gray)
                .animation(.none, value: selection)
                .frame(height: 40)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.snappy) {
                        selection = option
                        showOptions = false
                        if let selection {
                            if let sportTitle = SportTitle(rawValue: selection) {
                                guard gameService.activeSport != sportTitle else {
                                    return
                                }
                                gameService.activeSport = sportTitle
                                gameService.getGamesLocally(sport: sportTitle)
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 5)
        .transition(.move(edge: anchor == .top ? .bottom : .top))
    }
    
    enum Anchor {
        case top
        case bottom
    }
}
