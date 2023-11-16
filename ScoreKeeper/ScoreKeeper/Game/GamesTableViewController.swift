//
//  GamesTableViewController.swift
//  ScoreKeeper
//
//  Created by Ethan Archibald on 10/31/23.
//

import UIKit

class GamesTableViewController: UITableViewController {
    
    var games = [Game]()
    
    let cellSpacing: CGFloat = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        
        games = Game.LoadFromFiles()
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "pxfuel-2"))
        
    }

    @IBSegueAction func addGame(_ coder: NSCoder, sender: Any?) -> GameDetailViewController? {
        return GameDetailViewController(coder: coder, game: nil)
    }
    
    @IBSegueAction func editGame(_ coder: NSCoder, sender: Any?) -> GameDetailViewController? {
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else { return nil }
        
        let game = games[indexPath.row]
        
        return GameDetailViewController(coder: coder, game: game)
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameTableViewCell

        let game = games[indexPath.row]
        
        cell.layer.borderWidth = 3
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.cornerRadius = 30
        
        cell.update(with: game)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacing
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            games.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            Game.saveGame(games)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? GameDetailViewController else { return }
        vc.delegate = self
    }
}

extension GamesTableViewController: AddGameDelegate {
    func addGame(_ game: Game) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            games[selectedIndexPath.row] = game
            Game.saveGame(games)
        } else {
            self.games.insert(game, at: games.startIndex)
            Game.saveGame(games)
        }
        tableView.reloadData()
    }
}
