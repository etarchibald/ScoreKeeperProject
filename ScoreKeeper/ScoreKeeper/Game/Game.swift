//
//  Game.swift
//  ScoreKeeper
//
//  Created by Ethan Archibald on 10/31/23.
//

import Foundation

var documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
var archiveURL = documentDirectory.appendingPathExtension("players").appendingPathExtension("json")


struct Game: Codable {
    
    var title: String
    var currentWinner: String
    var players: [Player]
    var areWeSortingByLargest: Bool
    var isLargestWinning: Bool
    
    static func saveGame(_ game: [Game]) {
            let propertyListEncoder = JSONEncoder()
            let encoded = try? propertyListEncoder.encode(game)
            try? encoded?.write(to: archiveURL)
        }
        
    static func LoadFromFiles() -> [Game] {
        let propertyListDecoder = JSONDecoder()
        if let retrived = try? Data(contentsOf: archiveURL),
            let decoded = try? propertyListDecoder.decode([Game].self, from: retrived) {
            return decoded
        }
        return []
    }
    
}
