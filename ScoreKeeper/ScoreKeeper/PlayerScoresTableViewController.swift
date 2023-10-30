//
//  PlayerScoresTableViewController.swift
//  ScoreKeeper
//
//  Created by Ethan Archibald on 10/27/23.
//

import UIKit

class PlayerScoresTableViewController: UITableViewController {
    
    var players = [Player]()

    var sortedPlayers: [Player] {
        players.sorted(by: >)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        players.append(Player(name: "Player 1", score: 0))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? ViewController else { return }
        vc.delegate = self
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerScoreCard", for: indexPath) as! PlayerScoreTableViewCell
        
        cell.delegate = self

        let player = sortedPlayers[indexPath.row]
        cell.update(with: player)
        
        return cell
    }

}

extension PlayerScoresTableViewController: AddPlayerDelegate {
    
    func addPlayer(_ playerName: String, _ playerScore: Int) {
        players.append(Player(name: playerName, score: playerScore))
        tableView.reloadData()
    }
}

extension PlayerScoresTableViewController: ChangeScoreDelegate {
    func playerUpdated(player: Player?) {
        if let row = players.firstIndex(where: {$0.id == player?.id }) {
            players[row] = player!
        }
        tableView.reloadData()
    }
    
}
