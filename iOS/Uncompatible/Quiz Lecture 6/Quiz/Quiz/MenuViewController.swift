//
//  ViewController.swift
//  Quiz
//
//  Created by J. Ruof, Meruca on 23/03/16.
//  Copyright © 2016 RuMe Academy. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var recentScoreLabel: UILabel!
    @IBOutlet weak var highscoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recentScoreLabel.text = "Recent Score: " + String(UserDefaults.standard.integer(forKey: "RecentScore"))
        highscoreLabel.text = "Highscore: " + String(UserDefaults.standard.integer(forKey: "Highscore"))
    }
    
    @IBAction func startGameButtonHandler(_ sender: AnyObject?) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "QuizController") {
            present(vc, animated: true, completion: nil)
        } else {
            print("Something went wrong with the view controller presentation")
        }
    }

}

