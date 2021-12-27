//
//  Cell.swift
//  iCho
//
//  Created by Kudzaiishe Mhou on 2021/12/27.
//

import Foundation

class GridItem: ObservableObject {

    var row: Int
    var column: Int

    @Published var status: Status
    @Published var isOpened: Bool
    @Published var isFlagged: Bool

    var image: String {
        switch status {
        case .monster:
          return "monster-1"
        case .normal:
            return "path"
        case .player:
            return "player-1"
        case .exitPoint:
            return "flag"
        }
    }

    init(row: Int, column: Int) {
        self.row = row
        self.column = column
        self.status = .normal
        self.isOpened = false
        self.isFlagged = false
    }
}
