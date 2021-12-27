//
//  BoardView.swift
//  iCho
//
//  Created by Kudzaiishe Mhou on 2021/12/27.
//

import SwiftUI

struct GameWorldView: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    
    @State private var mode: Int = 0
    @State private var selectedPlayerIndex: Int = 0
    @State private var selectedMonsterIndex: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            
            Image("results")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 140)
                .padding(.bottom, 100)
                .overlay(
                
                    VStack {
                        HStack{
                            Text("Games Played")
                                .font(Font.custom("Noteworthy-Light", size: 12.0, relativeTo: .headline))
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(.leading, 20)
                            
                            Spacer()
                            
                            Text("\(gameViewModel.settings.gamesPlayed - 1 )")
                                .font(Font.custom("Noteworthy-Light", size: 12.0, relativeTo: .headline))
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(.trailing, 24)
                        }
                        
                        HStack{
                            Text("Games Won")
                                .font(Font.custom("Noteworthy-Light", size: 12.0, relativeTo: .headline))
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(.leading, 20)
                            
                            Spacer()
                            
                            Text("\(gameViewModel.settings.gamesWon)")
                                .font(Font.custom("Noteworthy-Light", size: 12.0, relativeTo: .headline))
                                .fontWeight(.bold)
                                .foregroundColor(Color("RastaGreen"))
                                .padding(.trailing, 24)
                        }
                        
                        HStack{
                            Text("Games Lost")
                                .font(Font.custom("Noteworthy-Light", size: 12.0, relativeTo: .headline))
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(.leading, 20)
                            
                            Spacer()
                            
                            Text("\(gameViewModel.settings.gamesPlayed - gameViewModel.settings.gamesWon - 1)")
                                .font(Font.custom("Noteworthy-Light", size: 12.0, relativeTo: .headline))
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                                .padding(.trailing, 24)
                        }
                    }.offset(x: 0, y: -50)
                
                )
            
            
            VStack(spacing: 0) {
                ForEach(0..<gameViewModel.board.count, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<gameViewModel.board[row].count, id: \.self) { col in
                            GridItemView(gridItem: gameViewModel.board[row][col],
                                     selectedMonsterIndex: selectedMonsterIndex,
                                     selectedPlayerIndex: selectedPlayerIndex)
                        }
                    }
                }
                
                JoyStick() { direction in
                    gameViewModel.playerMove(in: direction)
                }
               
            }
            
            Spacer()
        }
        .isHidden(gameViewModel.showResult)
        .overlay(
        
            Image("board")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 70)
                .offset(x: -UIScreen.main.bounds.width/2.6, y: UIScreen.main.bounds.height/3.1)
                .isHidden(gameViewModel.showResult)
                .overlay(
                    Text("Exit")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .offset(x: -UIScreen.main.bounds.width/2.6, y: UIScreen.main.bounds.height/3.2)
                )
                .onTapGesture {
                    gameViewModel.showResult = true
                }
       
        )
        .banner(mode: $mode,
                show: $gameViewModel.showResult,
                gameOver: $gameViewModel.isGameOver,
                selectedMonsterIndex: $selectedMonsterIndex,
                selectedPlayerIndex: $selectedPlayerIndex)
    }
}

struct BoardView_Previews: PreviewProvider {
    private static var gameSettings = Settings()
    static var previews: some View {
        GameWorldView()
            .environmentObject(GameViewModel(from: gameSettings))
    }
}
