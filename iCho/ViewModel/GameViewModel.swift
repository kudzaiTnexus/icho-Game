//
//  Game.swift
//  iCho
//
//  Created by Kudzaiishe Mhou on 2021/12/27.
//

import Foundation
import SwiftUI

final class GameViewModel: ObservableObject {
    
    @Published var settings: Settings
    
    @Published var isWon: Bool = false;
    @Published var showResult: Bool = true
    @Published var isGameOver: Bool = false;
    
    @Published var board: [[GridItem]]
    @Published var playerPositions: [Point2D] = []
    @Published var finishPosition: Point2D = Point2D(x: 0, y: 0)
    @Published var monsterPositions: [Point2D] = []
    
    private var playerDirection: Direction = .none
    
    init(from settings: Settings) {
        self.settings = settings
        board = Self.board(from: settings)
        
        placeComponentsOnboard()
    }
    
    func click(on gridItem: GridItem?) {
        
        guard let gridItem = gridItem else {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            return
        }
        
        if isAllowedMove(to: Point2D(x: gridItem.row, y: gridItem.column)) &&
            gridItem.status != .monster && gridItem.status != .exitPoint {
            playerPositions.append(Point2D(x: gridItem.row, y: gridItem.column))
            moveComponents()
        } else if gridItem.status == .monster {
            isWon = false
            showResult = true
            isGameOver = true
            return
        } else if gridItem.status == .exitPoint {
            // If the player shares the same grid space as the exit, the player wins
            isWon = true
            isGameOver = true
            showResult = true
            settings.gamesWon = settings.gamesWon + 1
            return
        } else {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            return
        }
        
        self.objectWillChange.send()
    }
    
    // MARK: Components moves
    
    func playerMove(in direction: Direction) {
        
        playerDirection = direction
        
        switch direction {
        case .up:
            click(on: board[safe: playerPositions.last!.x - 1]?[safe: playerPositions.last!.y])
        case .down:
            click(on: board[safe: playerPositions.last!.x + 1]?[safe: playerPositions.last!.y])
        case .left:
            click(on: board[safe: playerPositions.last!.x]?[safe: playerPositions.last!.y - 1])
        case .right:
            click(on: board[safe: playerPositions.last!.x]?[safe: playerPositions.last!.y + 1])
        default: break
        }
    }
    
    // Player can move up/down and left/right one 'tile' each turn, but not diagonally
    private func isAllowedMove(to selectedPoint: Point2D) -> Bool {
        guard let currentPosition = playerPositions.last else {
            return false
        }
        
        let isSingleMove = (selectedPoint.x - currentPosition.x).magnitude < 2 && (selectedPoint.y - currentPosition.y).magnitude < 2
        
        return !isDiagonal(from: currentPosition, to: selectedPoint) &&
        isSingleMove
    }
    
    private func isDiagonal(from startPoint: Point2D, to endPoint: Point2D) -> Bool {
        return (startPoint.x - endPoint.x).magnitude == (startPoint.y - endPoint.y).magnitude
    }
    
    // Whenever the player moves, all the monsters will move in the closest direction of
    // the player
    private func moveComponents() {
        
        guard let currentPosition = playerPositions.last else {
            return
        }
        
        board[currentPosition.x][currentPosition.y].status = .player
        
        playerPositions.forEach { position in
            if position != currentPosition {
                board[position.x][position.y].status = .normal
            }
        }
        
        monsterPositions.forEach { monster in
            var moveDirection = direction(from: monster,
                                  to:  aStarShortestPath(from: monster,
                                                         to: playerPositions[playerPositions.count - 1])?.first ?? monster)
            
            
            let latestPlayerPosition = playerPositions.last ?? Point2D(x: 0, y: 0)
            
            // If both direction and distances are the same, choose one randomly for the monster
            if isDiagonal(from: monster, to: latestPlayerPosition) {
                
                if (monster.y - latestPlayerPosition.y) >= 0 && (monster.x - latestPlayerPosition.x) < 0 {
                    moveDirection =  [.up, .right].randomElement() ?? moveDirection
                } else if (monster.y - latestPlayerPosition.y) >= 0 && (monster.x - latestPlayerPosition.x) >= 0 {
                    moveDirection =   [.up, .left].randomElement() ?? moveDirection
                } else if (monster.y - latestPlayerPosition.y) < 0 && (monster.x - latestPlayerPosition.x) < 0 {
                    moveDirection =   [.down, .right].randomElement() ?? moveDirection
                } else if (monster.y - latestPlayerPosition.y) < 0 && (monster.x - latestPlayerPosition.x) >= 0 {
                    moveDirection =  [.down, .left].randomElement() ?? moveDirection
                }
            }
            
            movePieceInDirection(moveDirection, piece: monster)
        }
        
        //If the monster shares the same grid ‘tile’ as the player, the game is over
        if monsterPositions.contains(where: { $0 == playerPositions[playerPositions.count - 1] }) {
            showResult = true
            isGameOver = true
        } else {
            let duplicates = Dictionary(grouping: monsterPositions, by: {$0}).filter { $1.count > 1 }.keys
            
            // kill all duplicate monsters
            monsterPositions.forEach { aliveMonster in
                if duplicates.contains(aliveMonster) {
                    // If 2 or more monsters share the same grid space, all monsters fight between
                    // themselves and all die
                    board[aliveMonster.x][aliveMonster.y].status = .dead
                }
            }
            
            monsterPositions = monsterPositions.filter { !duplicates.contains($0) }
        }
    }
    
    func reset() {
        playerPositions.removeAll()
        monsterPositions.removeAll()
        board = Self.board(from: settings)
        placeComponentsOnboard()
        showResult = false
        isWon = false
        isGameOver = false
    }
    
    // MARK: Board Setup
    
    private static func board(from settings: Settings) -> [[GridItem]] {
        var newBoard = [[GridItem]]()
        
        for row in 0..<settings.gameWorldNumberOfRows {
            var column = [GridItem]()
            for col in 0..<settings.gameWolrdNumberOfColumns {
                column.append(GridItem(row: row, column: col))
            }
            newBoard.append(column)
        }
        return newBoard
    }
    
    private func placeComponentsOnboard() {
        
        // The player starts at a random location in the top left 3x3 grid
        playerPositions.append(GameViewModel.randomPoint(from: (row: 3, column: 3),
                                                         within: (row: settings.gameWorldNumberOfRows, column: settings.gameWolrdNumberOfColumns),
                                                         on: .topLeft) ?? Point2D(x: 0, y: 0) )
        
        // The exit to the cave is in a random location at the bottom right 3x3 grid
        finishPosition = GameViewModel.randomPoint(from: (row: 3, column: 3),
                                                   within: (row: settings.gameWorldNumberOfRows, column: settings.gameWolrdNumberOfColumns),
                                                   on: .bottomRight) ?? Point2D(x: 0, y: 0)
        
        guard let playerPosition = playerPositions.last else {
            return
        }
        
        board.forEach { gridItems in
            gridItems.forEach { gridItem in
                if gridItem.row == playerPosition.x &&
                    gridItem.column == playerPosition.y {
                    gridItem.status = .player
                }
                
                if gridItem.row == finishPosition.x &&
                    gridItem.column == finishPosition.y {
                    gridItem.status = .exitPoint
                }
            }
        }
        
        var numberOfMonstersPlaced = 0
        while numberOfMonstersPlaced < settings.numberOfMonsters {

            // Initial monster positions are random, but enough spread should be guaranteed
            // (monsters shouldn't spawn too close to each other
            let randomRow = Int.random(in: 0..<settings.gameWorldNumberOfRows)
            let randomCol = Int.random(in: 0..<settings.gameWolrdNumberOfColumns)
            
            let currentRandomGridItemlStatus = board[randomRow][randomCol].status
            if currentRandomGridItemlStatus == .normal {
                board[randomRow][randomCol].status = .monster
                monsterPositions.append(Point2D(x: randomRow, y: randomCol))
                numberOfMonstersPlaced += 1
            }
        }
    }
    
    private static func randomPoint(from gridSize: (row: Int, column: Int),
                                    within grid: (row: Int, column: Int),
                                    on position: Position) -> Point2D? {
        
        var startPoint = (x: 0, y:0)
        
        if gridSize.row > grid.row || gridSize.column > grid.column {
            return nil
        }
        
        switch position {
        case .topLeft:
            break
        case .topRight:
            startPoint = (x: 0, y: grid.column - 1)
        case .bottomRight:
            startPoint = (x: grid.row - 1, y: grid.column - 1)
        case .bottomLeft:
            startPoint = (x: grid.row - 1, y:0)
        }
        
        var allpointsInGrid = [Point2D]()
        
        for xPosition in 0...(gridSize.row - 1) {
            var xCoordinates = 0
            switch position {
            case .topLeft, .topRight:
                xCoordinates = startPoint.x + xPosition
            case .bottomRight, .bottomLeft:
                xCoordinates = startPoint.x - xPosition
            }
            
            for yPosition in 0...(gridSize.column - 1) {
                var yCoordinates = 0
                switch position {
                case .topLeft, .bottomLeft:
                    yCoordinates = startPoint.y + yPosition
                case .topRight, .bottomRight:
                    yCoordinates = startPoint.y - yPosition
                }
                
                allpointsInGrid.append(Point2D(x: xCoordinates, y: yCoordinates))
            }
        }
        
        return allpointsInGrid.randomElement()
    }
    
    // MARK: Direction
    
    private func movePieceInDirection(_ direction: Direction, piece: Point2D) {
        
        guard let monsterPreviousIndex = monsterPositions.firstIndex(where: { $0 == piece }) else {
            return
        }
        
        monsterPositions.remove(at: monsterPreviousIndex)
        
        switch direction {
        case .up:
            board[safe: piece.x]?[safe: piece.y]?.status = .normal
            
            guard let monsterToNextTile = board[safe: piece.x - 1]?[safe: piece.y] else {
                return
            }
            
            monsterToNextTile.status = .monster
            
            monsterPositions.append(Point2D(x: piece.x - 1, y: piece.y))
        case .down:
            board[safe: piece.x]?[safe: piece.y]?.status = .normal
            
            guard let monsterToNextTile = board[safe: piece.x + 1]?[safe: piece.y ] else {
                return
            }
            
            monsterToNextTile.status = .monster
            
            monsterPositions.append(Point2D(x: piece.x + 1, y: piece.y))
        case .left:
            board[safe: piece.x]?[safe: piece.y]?.status = .normal
            
            guard let monsterToNextTile = board[safe: piece.x]?[safe: piece.y - 1] else {
                return
            }
            
            monsterToNextTile.status = .monster
            
            monsterPositions.append(Point2D(x: piece.x, y: piece.y - 1))
        case .right:
            board[safe: piece.x]?[safe: piece.y]?.status = .normal
            
            guard let monsterToNextTile = board[safe: piece.x]?[safe: piece.y + 1] else {
                return
            }
            
            monsterToNextTile.status = .monster
            
            monsterPositions.append(Point2D(x: piece.x, y: piece.y + 1))
        default: break
        }
    }
    
    private func direction(from startingPoint: Point2D, to destinationPoint: Point2D) -> Direction {
        if destinationPoint == Point2D(x: startingPoint.x - 1 , y: startingPoint.y) {
            return .up
        } else if destinationPoint == Point2D(x: startingPoint.x + 1 , y: startingPoint.y) {
            return .down
        } else if destinationPoint == Point2D(x: startingPoint.x, y: startingPoint.y - 1) {
            return .left
        } else if destinationPoint == Point2D(x: startingPoint.x , y: startingPoint.y + 1) {
            return .right
        }
        
        return .none
    }
    
    // MARK: A* Shortest path algorithm
    // Whenever the player moves, all the monsters will move in the closest direction of
    // the player
    private func aStarShortestPath(from: Point2D, to: Point2D) -> [Point2D]? {
        
        var closedSteps = Set<AstarStep>()
        var openSteps = [AstarStep(position: from)]
        
        while !openSteps.isEmpty {
            
            let currentStep = openSteps.remove(at: 0)
            closedSteps.insert(currentStep)
            
            if currentStep.position == to {
                return convertStepsToShortestPath(lastStep: currentStep)
            }
            
            let adjacentTiles = walkableTiles(from: currentStep.position)
            
            for tile in adjacentTiles {
                let step = AstarStep(position: tile)
                
                if closedSteps.contains(step) { continue }
                
                let moveCost = 1
                
                if let existingIndex = openSteps.firstIndex(of: step) {
                    let step = openSteps[existingIndex]
                    
                    if currentStep.gScore + moveCost < step.gScore {
                        step.gScore(from: currentStep, withMoveCost: moveCost)
                        openSteps.remove(at: existingIndex)
                        insertStep(step: step, inOpenSteps: &openSteps)
                    }
                    
                } else {
                    step.gScore(from: currentStep, withMoveCost: moveCost)
                    step.hScore = manhattanDistance(from: step.position, to: to)
                    insertStep(step: step, inOpenSteps: &openSteps)
                }
            }
        }
        
        return nil
    }
    
    private func convertStepsToShortestPath(lastStep: AstarStep) -> [Point2D] {
        var shortestPath = [Point2D]()
        var currentStep = lastStep
        while let parent = currentStep.parent {
            shortestPath.insert(currentStep.position, at: 0)
            currentStep = parent
        }
        return shortestPath
    }
    
    private func insertStep(step: AstarStep, inOpenSteps openSteps: inout [AstarStep]) {
        openSteps.append(step)
        openSteps.sort { $0.fScore <= $1.fScore }
    }
    
    private func manhattanDistance(from: Point2D, to: Point2D) -> Int {
        return (abs(from.x - to.x) + abs(from.y - to.y))
    }
    
    private func walkableTiles(from point: Point2D) -> [Point2D] {
        
        var walkableTiles:  [Point2D] = []
        
        let possibleMoves = [Point2D(x: point.x, y: point.y+1),
                             Point2D(x: point.x + 1, y: point.y),
                             Point2D(x: point.x - 1, y: point.y),
                             Point2D(x: point.x, y: point.y - 1)]
        
        walkableTiles = possibleMoves.filter({
            ($0 != playerPositions.last! || $0 != finishPosition) &&
            ($0.x >= 0 && $0.y >= 0)
        })
        
        return walkableTiles
    }
}


