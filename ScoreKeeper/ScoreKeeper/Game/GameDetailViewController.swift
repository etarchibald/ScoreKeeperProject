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
    var game: Game?
    
    init?(coder: NSCoder, game: Game?) {
        self.game = game
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateView() {
        guard let game = game else { return }
        
        titleLabel.text = game.title
        sortedPlayers = game.players
        
        sortingByLargest = game.areWeSortingByLargest
        greatestIsTheWinner = game.isLargestWinning
        
        sortPlayersSegmentedControl.selectedSegmentIndex = sortingByLargest ? 0 : 1
        
        whoWinsSegmentedControl.selectedSegmentIndex = greatestIsTheWinner ? 0 : 1
        
        updateSaveButtonState()
        
    }
    
    func sortMyPlayers() {
        if sortingByLargest {
            reorderCellsBasedOnDataSource(true)
        } else {
            reorderCellsBasedOnDataSource(false)
        }
    }
    
    func reorderCellsBasedOnDataSource(_ greaterThanSorting: Bool) {
        let oldOrder = sortedPlayers
        
        if sortedPlayers.count > 1 {
            tableView.reloadData()
            
            if greaterThanSorting {
                sortedPlayers.sort(by: { $0.score > $1.score })
            } else {
                sortedPlayers.sort(by: {$0.score < $1.score })
            }
            
            tableView.beginUpdates()
            for (oldIndex, item) in oldOrder.enumerated() {
                if let newIndex = sortedPlayers.firstIndex(where: { $0.id == item.id }) {
                    if oldIndex != newIndex {
                        tableView.moveRow(at: IndexPath(row: oldIndex, section: 0), to: IndexPath(row: newIndex, section: 0))
                    }
                }
            }
            tableView.endUpdates()
        } else {
            tableView.reloadData()
        }
    }
    
    func updateSaveButtonState() {
        if sortedPlayers.count == 0 || titleLabel.text!.isEmpty{
            saveBarButton.isEnabled = false
        } else {
            saveBarButton.isEnabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "pxfuel.com")!)
        tableView.backgroundView = UIImageView(image: UIImage(named: "pxfuel.com"))
        
        addPlayerButton.layer.borderWidth = 5
        addPlayerButton.layer.borderColor = UIColor.black.cgColor
        addPlayerButton.layer.cornerRadius = 20
        
        updateSaveButtonState()
        
        updateView()

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func titleTextFieldChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    @IBAction func sortPlayersBySegmented(_ sender: UISegmentedControl) {
        switch sortPlayersSegmentedControl.selectedSegmentIndex {
        case 0:
            sortingByLargest = true
            sortMyPlayers()
        case 1:
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
            currentWinner = sortingByLargest ? sortedPlayers.first : sortedPlayers.last
        } else {
            currentWinner = sortingByLargest ? sortedPlayers.last : sortedPlayers.first
        }
        
        delegate?.addGame(Game(title: title, currentWinner: currentWinner?.name ?? "Player", players: sortedPlayers, areWeSortingByLargest: sortingByLargest, isLargestWinning: greatestIsTheWinner))
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBSegueAction func addPlayer(_ coder: NSCoder) -> ViewController? {
        return ViewController(coder: coder, player: nil )
    }
    
    @IBSegueAction func editPlayer(_ coder: NSCoder, sender: Any?) -> ViewController? {
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else { return nil }
        
        let player = sortedPlayers[indexPath.row]
        
        return ViewController(coder: coder, player: player)
    }
}

extension GameDetailViewController: UITableViewDataSource, UITableViewDelegate, AddPlayerDelegate, ChangeScoreDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedPlayers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerScoreCard", for: indexPath) as! PlayerScoreTableViewCell
        
        cell.delegate = self
        
        cell.layer.borderWidth = 5
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.cornerRadius = 40
        
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? ViewController else { return }
        vc.delegate = self
    }
    
    func addPlayer(_ playerName: String, _ playerScore: Int) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            sortedPlayers[selectedIndexPath.row] = Player(name: playerName, score: playerScore)
        } else {
            sortedPlayers.append(Player(name: playerName, score: playerScore))
        }
        sortMyPlayers()
        updateSaveButtonState()
    }
    
    func playerUpdated(player: Player?) {
        guard let player else { return }
        if let row = sortedPlayers.firstIndex(of: player) {
            sortedPlayers[row] = player
        }
        sortMyPlayers()
        updateSaveButtonState()
    }
}
