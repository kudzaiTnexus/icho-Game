//
//  GameSettings.swift
//  iCho
//
//  Created by Kudzaiishe Mhou on 2021/12/27.
//

import Foundation
import SwiftUI

/*
 Number of monsters should be a fixed number based on difficulty +/- 10%:
 • easy: 10 monsters
 • medium: 20 monsters
 • hard: 35 monsters
 */
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
