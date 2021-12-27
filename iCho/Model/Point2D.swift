//
//  Point2D.swift
//  iCho
//
//  Created by Kudzaiishe Mhou on 2021/12/27.
//

import Foundation

struct Point2D: Hashable {
    var x : Int = 0
    var y : Int = 0

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.x)
        hasher.combine(self.y)
    }

    static func == (lhs: Point2D, rhs: Point2D) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}
