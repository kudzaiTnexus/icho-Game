//
//  ShortestPathStep.swift
//  iCho
//
//  Created by Kudzaiishe Mhou on 2021/12/27.
//

import Foundation
/** A single step on the computed path; used by the A* pathfinding algorithm */
class AstarStep: Hashable {
    let position: Point2D
    var parent: AstarStep?
    
    var gScore = 0
    var hScore = 0
    var fScore: Int { return gScore + hScore }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(position.y.hashValue)
        hasher.combine(position.x.hashValue)
    }
    
    init(position: Point2D) {
        self.position = position
    }
    
    func gScore(from step: AstarStep, withMoveCost moveCost: Int) {
        self.parent = step
        self.gScore = step.gScore + moveCost
    }
}

internal func ==(lhs: AstarStep, rhs: AstarStep) -> Bool {
    return lhs.position == rhs.position
}

