//
//  GameTableViewCell.swift
//  ScoreKeeper
//
//  Created by Ethan Archibald on 10/31/23.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var currentWinnerLabel: UILabel!
    
    var game: Game?
    
    func update(with game: Game) {
        gameTitleLabel.text = game.title
        currentWinnerLabel.text = "Current Winner: \(game.currentWinner)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
