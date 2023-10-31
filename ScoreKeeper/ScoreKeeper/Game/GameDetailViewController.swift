//
//  GameDetailViewController.swift
//  ScoreKeeper
//
//  Created by Ethan Archibald on 10/31/23.
//

import UIKit

class GameDetailViewController: UIViewController {
    
    @IBOutlet weak var addPlayerButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortPlayersSegmentedControl: UISegmentedControl!
    @IBOutlet weak var whoWinsSegmentedControl: UISegmentedControl!
    
    var players = [Player]()
    
    var sortedPlayers: [Player] {
        players.sorted(by: >)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        players.append(Player(name: "Player John", score: 9))

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func sortPlayersBySegmented(_ sender: UISegmentedControl) {
        print("Sorted Players by has been changed to \(sender)")
    }
    
    @IBAction func whoWinsSegmented(_ sender: UISegmentedControl) {
        print("Who Wins has been changed to \(sender)")
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension GameDetailViewController: UITableViewDataSource, UITableViewDelegate, AddPlayerDelegate, ChangeScoreDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedPlayers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerScoreCard", for: indexPath) as! PlayerScoreTableViewCell
        
        cell.delegate = self
        
        let player = sortedPlayers[indexPath.row]
        
        cell.update(with: player)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            players.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        Player.saveToFile(player: players)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? ViewController else { return }
        vc.delegate = self
    }
    
    func addPlayer(_ playerName: String, _ playerScore: Int) {
        players.append(Player(name: playerName, score: playerScore))
        tableView.reloadData()
        Player.saveToFile(player: players)
    }
    
    func playerUpdated(player: Player?) {
        guard let player else { return }
        if let row = players.firstIndex(of: player) {
            players[row] = player
        }
        tableView.reloadData()
        Player.saveToFile(player: players)
    }
}
