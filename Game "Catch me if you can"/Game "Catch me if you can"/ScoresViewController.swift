//
//  ScoresViewController.swift
//  Game "Catch me if you can"
//
//  Created by Julia on 10.03.2023.
//

import UIKit

struct GameResult {
    var date: Date
    var score: Int
}

class MyCell: UITableViewCell {
    @IBOutlet var dataLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
}

class ScoresViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    let cellIdentifier = "CellIdentifier"
    var scores: [GameResult] = []
    var bestResult = 0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = scores.count + 2
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MyCell
        guard indexPath.row > 0 else { return cell }
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        if indexPath.row == lastRowIndex {
            cell.dataLabel.text = "Best result: "
            cell.scoreLabel.text = "\(bestResult)"
        } else {
            let score = scores[indexPath.row - 1]
            cell.dataLabel.text = score.date.stringFormatted
            cell.scoreLabel.text = String(score.score)
        }
        return cell
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension Date {
    var stringFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d.MM.yy/HH:mm:ss"
        return formatter.string(from: self)
    }
}
