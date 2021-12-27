//
//  CellView.swift
//  iCho
//
//  Created by Kudzaiishe Mhou on 2021/12/27.
//

import SwiftUI

struct GridItemView: View {

    @EnvironmentObject var gameViewModel: GameViewModel
    
    var gridItem: GridItem
    let selectedMonsterIndex: Int
    let selectedPlayerIndex: Int

    var imageName : String {
        gridItem.status == .monster ? "monster-\(selectedMonsterIndex)" : (gridItem.status == .player ? "player-\(selectedPlayerIndex)" : gridItem.image)
    }
    
    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: gameViewModel.settings.squareSize,
                   height: gameViewModel.settings.squareSize,
                   alignment: .center)
           // .overlay(Text("\(gridItem.row),\(gridItem.column)").font(.caption2))
            .onTapGesture {
                gameViewModel.click(on: gridItem)
            }
    }
}

