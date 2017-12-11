//
//  ViewController.swift
//  Boggle
//
//  Created by Shuo Huang on 10/15/17.
//  Copyright © 2017 Shuo Huang. All rights reserved.
//

import UIKit



class MainScreenViewController: UIViewController, GameViewControllerDelegate {

    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    var highScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(VocabDB.sharedDB.dictTrie.root.isWord)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGameView" {
            let dest = segue.destination as! GameViewController
            dest.delegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateScore(score: Int) {
        if score > highScore {
            highScore = score
            highScoreLabel.text = "High Score: " + String(highScore)
            print(highScoreLabel.text!)
        }
    }
}

