//
//  GamesTableViewController.swift
//  ScoreKeeper
//
//  Created by Ethan Archibald on 10/31/23.
//

import UIKit

class GamesTableViewController: UITableViewController {
    
    var game = [Game]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        game.append(Game(title: "Egyptian Rat Screw", currentWinner: "Player 4", players: [Player(name: "Player 4", score: 38)]))
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return game.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameTableViewCell

        let game = game[indexPath.row]
        
        cell.update(with: game)

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? GameDetailViewController else { return }
        vc.delegate = self
    }
}

extension GamesTableViewController: AddGameDelegate {
    func addGame(_ game: Game) {
        self.game.append(game)
        tableView.reloadData()
    }
    
    
}
