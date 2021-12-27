//
//  GameSettings.swift
//  iCho
//
//  Created by Kudzaiishe Mhou on 2021/12/27.
//

import Foundation
import SwiftUI

class Settings: ObservableObject {
    @Published var gameWorldNumberOfRows = 15
    @Published var gameWolrdNumberOfColumns = 15
    @Published var numberOfMonsters = 5
    @Published var gamesPlayed = 0
    @Published var gamesWon = 0
    
    var squareSize: CGFloat {
        UIScreen.main.bounds.width / CGFloat(gameWolrdNumberOfColumns)
    }
}
