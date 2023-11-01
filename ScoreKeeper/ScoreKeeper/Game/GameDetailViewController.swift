//
//  GameDetailViewController.swift
//  ScoreKeeper
//
//  Created by Ethan Archibald on 10/31/23.
//

import UIKit

protocol AddGameDelegate {
    func addGame(_ game: Game)
}

class GameDetailViewController: UIViewController {
    
    @IBOutlet weak var addPlayerButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortPlayersSegmentedControl: UISegmentedControl!
    @IBOutlet weak var whoWinsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    var sortedPlayers = [Player]()
    
    var sortingByLargest = true
    
    var greatestIsTheWinner = true
    
    var delegate: AddGameDelegate?
    
    func sortMyPlayers() {
        if sortingByLargest {
            sortedPlayers = sortedPlayers.sorted(by: >)
            tableView.reloadData()
//            reorderCellsBasedOnDataSource()
        } else {
            sortedPlayers = sortedPlayers.sorted(by: <)
            tableView.reloadData()
//            reorderCellsBasedOnDataSource()
        }
    }
    
    func updateSaveButtonState() {
        if sortedPlayers.isEmpty && ((titleLabel.text?.isEmpty) != nil) {
            saveBarButton.isEnabled = false
        } else {
            saveBarButton.isEnabled = true
        }
    }
    
    func reorderCellsBasedOnDataSource() {
            // Store the old order
            let oldOrder = sortedPlayers
            // Sort the data source based on the updated property
            sortedPlayers.sort(by: { $0.score < $1.score })
            // Animate the changes
            tableView.beginUpdates()
            for (oldIndex, item) in oldOrder.enumerated() {
                if let newIndex = sortedPlayers.firstIndex(where: { $0.id == item.id }) {
                    if oldIndex != newIndex {
                        tableView.moveRow(at: IndexPath(row: oldIndex, section: 0), to: IndexPath(row: newIndex, section: 0))
                    }
                }
            }
            tableView.endUpdates()
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sortedPlayers.append(Player(name: "Player John", score: 9))
        sortedPlayers.append(Player(name: "John Bloodborne", score: 10))
        
        updateSaveButtonState()
        sortMyPlayers()

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func titleTextFieldChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    @IBAction func sortPlayersBySegmented(_ sender: UISegmentedControl) {
        switch sortPlayersSegmentedControl.selectedSegmentIndex {
        case 0:
            sortedPlayers = sortedPlayers.sorted(by: >)
            sortingByLargest = true
            sortMyPlayers()
        case 1:
            sortedPlayers = sortedPlayers.sorted(by: <)
            sortingByLargest = false
            sortMyPlayers()
        default:
            break;
        }
    }
    
    @IBAction func whoWinsSegmented(_ sender: UISegmentedControl) {
        switch whoWinsSegmentedControl.selectedSegmentIndex {
        case 0:
            greatestIsTheWinner = true
        case 1:
            greatestIsTheWinner = false
        default:
            break;
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        guard let title = titleLabel.text else { return }
        
        var currentWinner: Player?
        
        if greatestIsTheWinner {
            if sortingByLargest {
                currentWinner = sortedPlayers.first
            } else {
                currentWinner = sortedPlayers.last
            }
        } else {
            if sortingByLargest {
                currentWinner = sortedPlayers.last
            } else {
                currentWinner = sortedPlayers.first
            }
        }
        
        delegate?.addGame(Game(title: title, currentWinner: currentWinner?.name ?? "Player", players: sortedPlayers))
        
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
            sortedPlayers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        Player.saveToFile(player: sortedPlayers)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? ViewController else { return }
        vc.delegate = self
    }
    
    func addPlayer(_ playerName: String, _ playerScore: Int) {
        sortedPlayers.append(Player(name: playerName, score: playerScore))
        sortMyPlayers()
        updateSaveButtonState()
        Player.saveToFile(player: sortedPlayers)
    }
    
    func playerUpdated(player: Player?) {
        guard let player else { return }
        if let row = sortedPlayers.firstIndex(of: player) {
            sortedPlayers[row] = player
        }
        sortMyPlayers()
        updateSaveButtonState()
        Player.saveToFile(player: sortedPlayers)
    }
}
