//
//  Player.swift
//  ScoreKeeper
//
//  Created by Ethan Archibald on 10/27/23.
//

import Foundation
import UIKit

struct Player: Equatable, Comparable {
    var id: String
    var name: String
    var score: Int
    
    init(name: String, score: Int) {
        self.id = UUID().uuidString
        self.name = name
        self.score = score
    }
    
    static func ==(lhs: Player, rhs: Player) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func <(lhs: Player, rhs: Player) -> Bool {
        lhs.score < rhs.score
    }
}
