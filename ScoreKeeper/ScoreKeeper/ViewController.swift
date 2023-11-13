//
//  ViewController.swift
//  ScoreKeeper
//
//  Created by Ethan Archibald on 10/27/23.
//

import UIKit

protocol AddPlayerDelegate {
    func addPlayer(_ playerName: String, _ playerScore: Int)
}

class ViewController: UIViewController {

    @IBOutlet weak var playerNameTextField: UITextField!
    @IBOutlet weak var savePlayerButton: UIButton!
    @IBOutlet weak var currentScoreTextField: UITextField!
    
    var delegate: AddPlayerDelegate?
    
    var player: Player?
    
    required init?(coder: NSCoder, player: Player?) {
        self.player = player
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "pxfuel.com")!)
        
        savePlayerButton.layer.borderWidth = 5
        savePlayerButton.layer.borderColor = UIColor.black.cgColor
        savePlayerButton.layer.cornerRadius = 20
        
        updateView()
    }
    
    func updateView() {
        guard let player = player else { return }
        
        playerNameTextField.text = player.name
        currentScoreTextField.text = String(player.score)
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let player = playerNameTextField.text,
              let scoreString = currentScoreTextField.text,
              let score = Int(scoreString)
        else { return }
        
        delegate?.addPlayer(player, score)
        
        self.navigationController?.popViewController(animated: true)
    }
    
}

