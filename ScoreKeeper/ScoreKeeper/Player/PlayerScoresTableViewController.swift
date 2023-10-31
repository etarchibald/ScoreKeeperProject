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
        players = Player.loadFromFiles()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? ViewController else { return }
        vc.delegate = self
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedPlayers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerScoreCard", for: indexPath) as! PlayerScoreTableViewCell
        
        cell.delegate = self

        let player = sortedPlayers[indexPath.row]
        cell.update(with: player)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            players.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        Player.saveToFile(player: players)
    }

}

extension PlayerScoresTableViewController: AddPlayerDelegate {
    
    func addPlayer(_ playerName: String, _ playerScore: Int) {
        players.append(Player(name: playerName, score: playerScore))
        tableView.reloadData()
        Player.saveToFile(player: players)
    }
}

extension PlayerScoresTableViewController: ChangeScoreDelegate {
    func playerUpdated(player: Player?) {
        guard let player else { return }
        if let row = players.firstIndex(of: player) {
            players[row] = player
        }
        tableView.reloadData()
        Player.saveToFile(player: players)
    }
}
