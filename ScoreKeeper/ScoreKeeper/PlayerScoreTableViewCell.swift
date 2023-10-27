//
//  PlayerScoreTableViewCell.swift
//  ScoreKeeper
//
//  Created by Ethan Archibald on 10/27/23.
//

import UIKit

protocol ChangeScoreDelegate {
    func changeScore(_ score: Int)
}

class PlayerScoreTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerStepper: UIStepper!
    @IBOutlet weak var playerScoreLabel: UILabel!
    
    var delegate: ChangeScoreDelegate?
    
    var index = 1
    
    @IBAction func stepperPressed(_ sender: UIStepper) {
        
        var startingScore = Int(playerScoreLabel.text ?? "0")
        
//        playerStepper.value = 1
//
//        var score = Int(playerScoreLabel.text!)
//
//        if index == Int(playerStepper.value) {
//            score = Int(score!) + Int(playerStepper.value)
//            index += 1
//        } else if index != Int(playerStepper.value) {
//            score = Int(score!) - Int(playerStepper.value)
//            index -= 1
//        }
//
//        playerScoreLabel.text = String(score!)
//
//        print(index)
//        print(playerStepper.value)
//        print(score)
        
        playerScoreLabel.text = String(Int(sender.value))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.playerStepper.value = Double(playerScoreLabel.text!)!
        stepperPressed(playerStepper!)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
