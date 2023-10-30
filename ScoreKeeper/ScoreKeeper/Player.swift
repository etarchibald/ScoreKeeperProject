//
//  Player.swift
//  ScoreKeeper
//
//  Created by Ethan Archibald on 10/27/23.
//

import Foundation
import UIKit

var documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
var archiveURL = documentDirectory.appendingPathExtension("players").appendingPathExtension("json")

struct Player: Equatable, Comparable, Codable {
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
    
    static func saveFromFiles(player: [Player]) {
        let jsonEncoder = JSONEncoder()
        let encoded = try? jsonEncoder.encode(player)
        try? encoded?.write(to: archiveURL)
    }
    
    static func loadFromFiles() -> [Player] {
        let jsonDecoder = JSONDecoder()
        if let retrived = try? Data(contentsOf: archiveURL), let decoded = try? jsonDecoder.decode([Player].self, from: retrived) {
            return decoded
        }
        return []
    }
    
    
}
