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
    @IBOutlet weak var currentScoreTextField: UITextField!
    
    var delegate: AddPlayerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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

