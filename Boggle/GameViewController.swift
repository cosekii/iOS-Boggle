//
//  GameViewController.swift
//  Boggle
//
//  Created by Shuo Huang on 10/15/17.
//  Copyright © 2017 Shuo Huang. All rights reserved.
//

import Foundation
import UIKit

protocol GameViewControllerDelegate {
    func updateScore(score: Int)
}

class GameViewController: UIViewController, ProgressBarViewDelegate {
    
    @IBOutlet weak var gridButton1: UIButton!
    @IBOutlet weak var gridButton2: UIButton!
    @IBOutlet weak var gridButton3: UIButton!
    @IBOutlet weak var gridButton4: UIButton!
    @IBOutlet weak var gridButton5: UIButton!
    @IBOutlet weak var gridButton6: UIButton!
    @IBOutlet weak var gridButton7: UIButton!
    @IBOutlet weak var gridButton8: UIButton!
    @IBOutlet weak var gridButton9: UIButton!
    @IBOutlet weak var gridButton10: UIButton!
    @IBOutlet weak var gridButton11: UIButton!
    @IBOutlet weak var gridButton12: UIButton!
    @IBOutlet weak var gridButton13: UIButton!
    @IBOutlet weak var gridButton14: UIButton!
    @IBOutlet weak var gridButton15: UIButton!
    @IBOutlet weak var gridButton16: UIButton!

    @IBOutlet weak var seeSolutionButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var curWordLabel: UILabel!
    @IBOutlet weak var progressBarView: ProgressBarView!
    
    var delegate: GameViewControllerDelegate?
    var currentWord = String()
    var wordGrids = [[String]]()
    var gridPos : [UIButton: [Int]] = [:]
    var grids:[[UIButton]] = []
    var visitedGrid : [UIButton: Bool] = [:]
    let date = Date()
    let calendar = Calendar.current
    var seconds = 0
    let letterProb = [9, 2, 3, 4, 9, 2, 2, 6, 7, 2, 2, 4, 3, 7, 8, 3, 2, 6, 9, 9, 3, 1, 3, 2, 3, 1]
    var solutionWords: [String] = []
    let alphabets: [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    var score = 0
    var wordsFound = Set<String>()
    var last_i = -1
    var last_j = -1
    var startTime = 0
    var lastTimeUpdate = 0
    let totalTime = 180
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        grids = [[gridButton1, gridButton2, gridButton3,
                 gridButton4], [gridButton5, gridButton6,
                 gridButton7, gridButton8], [gridButton9,
                 gridButton10, gridButton11, gridButton12],
                 [gridButton13, gridButton14, gridButton15,
                 gridButton16]]
        
        currentWord.removeAll()
        wordGrids = getRandomBoard()
        //wordGrids = [["A", "B", "C", "D"], ["A", "B", "C", "D"], ["A", "B", "C", "D"], ["A", "B", "C", "D"]]
        print(wordGrids)
        updateGridBoard(boardLetters: wordGrids)
        seconds = calendar.component(.second, from: date)
        curWordLabel.text = ""
        findSolutions()
        startTime = getCurTime()
        lastTimeUpdate = startTime
        monitorTimeUpdates()
        progressBarView.delegate = self
        seeSolutionButton.alpha = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addGridLetterToCurrentWord(_ sender: UIButton) {
        lastTimeUpdate = getCurTime()
        if visitedGrid[sender] == true {
            currentWord.removeAll()
            resetLastPos()
            resetVisited()
            curWordLabel.text = ""
            return
        } else {
            visitedGrid[sender] = true
        }
        
        markVisitedGrids()
        
        let curPos = gridPos[sender]
        
        if checkValidPosition(i: curPos![0], j: curPos![1]) == false {
            currentWord.removeAll()
            resetLastPos()
            resetVisited()
            visitedGrid[sender] = true
            curWordLabel.text = ""
        }
        currentWord.append((sender.titleLabel?.text)!)
        curWordLabel.text = currentWord
        last_i = curPos![0]
        last_j = curPos![1]
        
        print(currentWord)
        //print(gridPos[sender]!)
        print(checkValidWord(word: currentWord))
        if checkValidWord(word: currentWord) && wordsFound.contains(currentWord) == false {
            updateScore(word: currentWord)
            wordsFound.insert(currentWord)
            currentWord.removeAll()
            resetVisited()
            resetLastPos()
            
            UIView.animate(withDuration: 0.2, delay: 0,
                           usingSpringWithDamping: 0.1,
                           initialSpringVelocity: 5.0,
                           options: [.allowUserInteraction],
                           animations: {
                            self.curWordLabel.transform = self.curWordLabel.transform.scaledBy(x: 1.1, y: 1.1)
            }) { (finish: Bool) in
                UIView.animate(withDuration: 0.2, animations: { self.curWordLabel.transform = CGAffineTransform.identity }) }
        }
        /*UIView.animate(withDuration: 0.2, delay: 0,
             options: [.allowUserInteraction],
             animations: {
                sender.transform = .identity
        }) { (Bool) in}*/
        
        
        /* TODO: when time less than 10 seconds
         * grids will disappear
         */
        
        /*
        UIView.animate(withDuration: 0.6, animations: { sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6) }, completion: { (finish: Bool) in UIView.animate(withDuration: 0.6, animations: { sender.transform = CGAffineTransform.identity }) })*/
        
        UIView.animate(withDuration: 0.3, delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 5.0,
                       options: [.allowUserInteraction],
                       animations: {
                        sender.transform = sender.transform.rotated(by: 0.2)
        }) { (finish: Bool) in
            UIView.animate(withDuration: 0.2, animations: { sender.transform = CGAffineTransform.identity }) }
    }
    
    func getRandomBoard() -> [[String]] {
        var newGrid = [[String]]()
        var accProb = [8]
        for i in 1...25 {
            accProb.append(accProb[i - 1] + letterProb[i])
        }
        let upperbound = UInt32(accProb[25] - 1)
        
        for _ in 0...3 {
            var newRow = [String]()
            for _ in 0...3 {
                let randnum = Int(arc4random_uniform(upperbound))
                for k in 0...25 {
                    if accProb[k] >= randnum {
                        newRow.append(alphabets[k])
                        break
                    }
                }
            }
        
            newGrid.append(newRow)
        }
        
        return newGrid
    }
    
    func updateGridBoard(boardLetters: [[String]]) {
        for i in 0...3 {
            for j in 0...3 {
                grids[i][j].setTitle(boardLetters[i][j], for: [])
                gridPos[grids[i][j]] = [i, j]
                visitedGrid[grids[i][j]] = false
            }
        }
    }
    
    func checkValidPosition(i: Int, j: Int) -> Bool {
        if last_i != -1 && last_j != -1 {
            if i == last_i && j == last_j {
                return false
            }
            if j - last_j > 1 || j - last_j < -1 {
                return false
            }
            
            if i - last_i > 1 || i - last_i < -1 {
                return false
            }
            
            return true
        }
        return true
    }
    
    func getCurTime() -> Int {
        return Int(Date.init().timeIntervalSince1970)
    }
    
    func getProgress() -> Int? {
        return getCurTime() - startTime
    }
    
    func getTotalTime() -> Int? {
        return totalTime
    }
    
    func markVisitedGrids() {
        for r in grids {
            for c in r {
                if visitedGrid[c] == true {
                    c.backgroundColor = UIColor(red: 255.0 / 255.0, green: 230.0 / 255.0, blue: 230.0 / 255.0, alpha: 1)
                }
            }
        }
    }
    
    func monitorTimeUpdates() {
        let queue = DispatchQueue(label: "com.boggle.monitorqueue")
        queue.async {
            var curTime = self.getCurTime()
            while curTime - self.startTime < self.totalTime {
                let toEnd = self.totalTime - (curTime - self.startTime)
                print(toEnd)
                sleep(1)
                curTime = self.getCurTime()
                DispatchQueue.main.async {
                    self.progressBarView.setNeedsDisplay()
                }
                if curTime - self.lastTimeUpdate > 1 {
                    DispatchQueue.main.async {
                        self.currentWord.removeAll()
                        self.resetLastPos()
                        self.resetVisited()
                        self.curWordLabel.text = ""
                    }
                }
                if toEnd <= 17 {
                    DispatchQueue.main.async {
                        self.gridsDisapper()
                    }
                }
            }
            DispatchQueue.main.async {
                self.progressBarDisappear()
                self.solutionButtonShowUp()
                self.gameEndViewShowUp()
            }
        }
    }
    
    func resetLastPos() {
        last_i = -1
        last_j = -1
    }
    
    func resetVisited() {
        for r in grids {
            for c in r {
                visitedGrid[c] = false
                c.backgroundColor = UIColor.white
            }
        }
    }
    
    func checkValidWord(word: String) -> Bool {
        return VocabDB.sharedDB.dictTrie.search(word: word)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSolutionView" {
            let dest = segue.destination as! SolutionViewController
            dest.solutionWords = solutionWords
        }
    }
    
    func updateScore(word: String) {
        score += word.count
        scoreLabel.text = "Score " + String(score)
        delegate?.updateScore(score: score)
    }
    
    func gridsDisapper() {
        for r in grids {
            for c in r {
                if c.alpha == 1 {
                    UIView.animate(withDuration: 2.0, delay: 0,
                     usingSpringWithDamping: 0.2,
                     initialSpringVelocity: 6.0,
                     options: [.allowUserInteraction], animations: {
                     c.alpha = 0
                    }) { (Bool) in}
                    return
                }
            }
        }
    }
    
    func progressBarDisappear() {
        UIView.animate(withDuration: 1.0, delay: 0.5,
                       options: [.allowUserInteraction], animations: {
                        self.progressBarView.alpha = 0
        }) { (Bool) in}
    }
    
    func solutionButtonShowUp() {
        UIView.animate(withDuration: 1.0, delay: 2,
                        options: [.allowUserInteraction], animations: {
                        self.seeSolutionButton.alpha = 1
        }) { (Bool) in}
    }
    
    func gameEndViewShowUp() {
        let gameOverLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        gameOverLabel.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY - 50)
        gameOverLabel.textAlignment = .center
        gameOverLabel.text = "Game Over"
        gameOverLabel.textColor = UIColor.white
        gameOverLabel.font = UIFont(name: gameOverLabel.font.fontName, size: 50.0)
        gameOverLabel.alpha = 0
        
        let wordCountLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        wordCountLabel.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY + 25)
        wordCountLabel.textAlignment = .center
        wordCountLabel.text = "You Found " + String(wordsFound.count) + " Words!"
        wordCountLabel.textColor = UIColor.white
        wordCountLabel.font = UIFont(name: wordCountLabel.font.fontName, size: 25.0)
        wordCountLabel.alpha = 0
        
        
        self.view.addSubview(gameOverLabel)
        self.view.addSubview(wordCountLabel)
        
        UIView.animate(withDuration: 1.0, delay: 2,
                       options: [.allowUserInteraction], animations: {
                        gameOverLabel.alpha = 1
                        wordCountLabel.alpha = 1
        }) { (Bool) in}
    }
    
    func findSolutions() {
        let queue = DispatchQueue(label: "com.boggle.fsqueue")
        queue.async {
            var solutionSet = Set<String>()
            var visited = Array(repeating: Array(repeating: false, count: 4), count: 4)
            for i in 0...3 {
                for j in 0...3 {
                    self.search(grids: &self.wordGrids, solutionSet: &solutionSet, word: String(), i: i, j: j, visited: &visited)
                }
            }
            
            for s in solutionSet {
                self.solutionWords.append(s)
            }
            self.solutionWords.sort()
            print(self.solutionWords)
            print(self.getCurTime() - self.startTime)
        }
    }
    
    func search(grids: inout [[String]], solutionSet: inout Set<String>, word: String, i: Int, j: Int, visited: inout [[Bool]]) {
        if i < 0 || i > 3 {
            return
        }
        
        if j < 0 || j > 3 {
            return
        }
        visited[i][j] = true
        let curWord = word + grids[i][j]
        if(VocabDB.sharedDB.dictTrie.search(word: curWord)) {
            solutionSet.insert(curWord)
        }
        
        let d = [[-1, -1], [0, -1], [1, -1], [-1, 1], [0, 1], [1, 1], [-1, 0], [1, 0]]
        
        for k in 0...7 {
            let next_i = i + d[k][0]
            let next_j = j + d[k][1]
            
            if next_i < 0 || next_i > 3 {
                continue
            }
            
            if next_j < 0 || next_j > 3 {
                continue
            }
            
            if(visited[next_i][next_j] == false) {
                search(grids: &grids, solutionSet: &solutionSet, word: curWord, i: next_i, j: next_j, visited: &visited)
                visited[next_i][next_j] = false
            }
        }
        visited[i][j] = false
    }
}
