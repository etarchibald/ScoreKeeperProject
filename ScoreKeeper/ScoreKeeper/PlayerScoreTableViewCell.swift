//
//  PlayerScoreTableViewCell.swift
//  ScoreKeeper
//
//  Created by Ethan Archibald on 10/27/23.
//

import UIKit

protocol ChangeScoreDelegate {
    func playerUpdated(player: Player?)
}

class PlayerScoreTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerStepper: UIStepper!
    @IBOutlet weak var playerScoreLabel: UILabel!
    
    var delegate: ChangeScoreDelegate?
    
    private var player: Player?
    
    func update(with player: Player) {
        self.player = player
        playerNameLabel.text = player.name
        playerScoreLabel.text = String(player.score)
        playerStepper.value = Double(player.score)
    }
    
    @IBAction func stepperPressed(_ sender: UIStepper) {
        let newScoreInt = Int(sender.value)
        playerScoreLabel.text = String(newScoreInt)
        player?.score = newScoreInt
        delegate?.playerUpdated(player: player)
    }
    
}
