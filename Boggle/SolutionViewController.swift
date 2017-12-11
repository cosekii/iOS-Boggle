//
//  SolutionViewController.swift
//  Boggle
//
//  Created by Shuo Huang on 10/29/17.
//  Copyright © 2017 Shuo Huang. All rights reserved.
//

import UIKit

class SolutionViewController: UITableViewController {
    
    //var grids: [[String]]?
    var solutionWords: [String] = []
    let bgImageView = UIImageView(image: UIImage(named: "BackgroundImage"))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
 
        tableView.backgroundView = bgImageView
        //solutionWords.removeAll()
        //findSolutions()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return solutionWords.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.backgroundColor = UIColor.clear
        
        // Configure the cell...
        cell.textLabel?.text = solutionWords[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = cell.textLabel?.font.withSize(25.0)
        return cell
    }
    /*
    func findSolutions() {
        var solutionSet = Set<String>()
        var visited = Array(repeating: Array(repeating: false, count: 4), count: 4)
        for i in 0...3 {
            for j in 0...3 {
                search(grids: &grids!, solutionSet: &solutionSet, word: String(), i: i, j: j, visited: &visited)
            }
        }
            
        for s in solutionSet {
            solutionWords.append(s)
        }
        solutionWords.sort()
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
    }*/
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
