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
    
    
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var IncramentTextField: UITextField!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerScoreLabel: UILabel!
    
    var delegate: ChangeScoreDelegate?
    var incramentScoreBy = 1
    var score = 0
    
    private var player: Player?
    
    func update(with player: Player) {
        self.player = player
        playerNameLabel.text = player.name
        playerScoreLabel.text = String(player.score)
        score = player.score
    }
    
    @IBAction func incramentValueChanged(_ sender: UITextField) {
        incramentScoreBy = Int(IncramentTextField.text ?? "1") ?? 1
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if sender == addButton {
            score += incramentScoreBy
            playerScoreLabel.text = String(score)
        }
        
        if sender == minusButton {
            score -= incramentScoreBy
            playerNameLabel.text = String(score)
        }
        
        player?.score = score
        delegate?.playerUpdated(player: player)
    }
}
