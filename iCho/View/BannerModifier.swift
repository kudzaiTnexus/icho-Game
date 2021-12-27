//
//  BannerModifier.swift
//  iCho
//
//  Created by Kudzaiishe Mhou on 2021/12/27.
//

import Foundation
import SwiftUI

struct BannerModifier: ViewModifier {
    
    @EnvironmentObject var gameViewModel: GameViewModel
    
    @Binding var show: Bool
    @Binding var gameOver: Bool
    
    @Binding var selectedMonsterIndex: Int
    @Binding var selectedPlayerIndex: Int
    @Binding var mode: Int
    
    var gameState: String {
        gameViewModel.isWon ? "You Won" : (gameOver ? "You Lost" : "New Game")
    }
    
    var gameStateColor: Color {
        gameViewModel.isWon ? Color("RastaGreen") : (gameOver ? Color.red : Color.white)
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if show {
                VStack(alignment: .center, spacing: 0) {
                    Text(gameState)
                        .font(Font.custom("Noteworthy-Light", size: 22.0, relativeTo: .title2))
                        .fontWeight(.heavy)
                        .foregroundColor(gameStateColor)
                        .padding([.top, .bottom], 4)
                    
                    Picker(selection: $mode, label: Text(""), content: {
                                    Text("Easy").tag(0)
                                    Text("Medium").tag(1)
                                    Text("Hard").tag(2)
                                }).pickerStyle(SegmentedPickerStyle())
                        .padding([.leading, .trailing], 30)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Select a player")
                            .font(.subheadline)
                            .fontWeight(.heavy)
                            .foregroundColor(.gray)
                            .padding()
                        HStack {
                            ForEach([1,2,3,4,5].indices,id:\.self) { index in
                                SelectionView(index: index,
                                        isPlayer: true,
                                        selected: .constant(selectedPlayerIndex == index)) { cellIndex in
                                    selectedPlayerIndex = cellIndex
                                }
                            }
                        }
                    }.padding(.bottom, 16)
                    
                    Button(action: {
                        withAnimation {

                            if mode == 0 {
                                gameViewModel.settings.numberOfMonsters = 10
                            } else if mode == 1 {
                                gameViewModel.settings.numberOfMonsters = 20
                            } else {
                                gameViewModel.settings.numberOfMonsters = 35
                            }
                            
                            self.show = false
                            gameViewModel.reset()
                            
                            gameViewModel.settings.gamesPlayed = gameViewModel.settings.gamesPlayed + 1
                        }
                    }) {
                        Text(gameOver ? "Play Again" :"Play Game")
                            .padding([.leading, .trailing], 40)
                            .padding([.top, .bottom], 8)
                    }
                    .background(Capsule()
                        .stroke(LinearGradient(gradient: Gradient(colors: [Color("accent"), Color("background4")]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2)
                        .saturation(1.8))
                    .padding(.top, 16)
                    
                }
                .frame(width: 350, height: 300)
                .background(Image("bac").scaledToFill())
                .cornerRadius(8)
                .animation(.easeInOut)
                .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
            }
        }
        
    }
    
}



