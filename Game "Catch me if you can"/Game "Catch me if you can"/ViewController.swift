//
//  ViewController.swift
//  Game "Catch me if you can"
//
//  Created by Julia on 13.02.2023.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    private var count = 0
    private var date = Date()
    private let secondsPerGame = 10
    private var secondsRemaining = 0
    private var timer = Timer()
    private var hardModeTimer = Timer()
    private var allScores: [GameResult] = []
    let container  = NSPersistentContainer(name: "CoreData")
    
    @IBOutlet private weak var playField: UIView!
    @IBOutlet private weak var redSquare: UIButton!
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var switchLevel: UISegmentedControl!
    @IBOutlet private weak var scores: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        container.loadPersistentStores { _, error in
            if let error {
                print(error)
            }
        }
        let stored = container.viewContext.load()
        print("Loaded \(stored.count) results:")
        stored.forEach {
            print($0)
        }
        allScores = stored
    }
    
    private var isHardMode: Bool {
        switchLevel.selectedSegmentIndex == 1
    }
    
    @IBAction private func tapSquare(_ sender: UIButton) {
        if isHardMode {
            hardModeTimer.invalidate()
            hardModeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateHardModeTimer)), userInfo: nil, repeats: true)
        }
        updateSquarePosition()
        if count == 0 {
            secondsRemaining = secondsPerGame
            runTimer()
            date = Date()
            let disabledSegmentIndex = isHardMode ? 0 : 1
            switchLevel.setEnabled(false, forSegmentAt: disabledSegmentIndex)
            scores.isEnabled = false
        }
        count += 1
    }
    
    @objc
    private func updateHardModeTimer() {
        updateSquarePosition()
    }
    
    private func updateSquarePosition() {
        let maxX = playField.frame.size.width - redSquare.frame.size.width
        let maxY = playField.frame.size.height - redSquare.frame.size.height
        UIView.animate(withDuration: 0.3) {
            self.redSquare.frame.origin = CGPoint(x: .random(in: 0...maxX), y: .random(in: 0...maxY))
        }
    }
    
    private func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc
    private func updateTimer() {
        let managedContext = container.viewContext
        if secondsRemaining > 0 {
            secondsRemaining -= 1
        } else {
            timer.invalidate()
            showAlert()
            secondsRemaining = secondsPerGame
            let currentResult = GameResult(date: date, score: count)
            allScores.append(currentResult)
            managedContext.save([currentResult])
            count = 0
            hardModeTimer.invalidate()
            redSquare.frame.origin = CGPoint(x: 8, y: 8)
            switchLevel.setEnabled(true, forSegmentAt: 1)
            switchLevel.setEnabled(true, forSegmentAt: 0)
            scores.isEnabled = true
        }
        timerLabel.text = formattedTime(time: TimeInterval(secondsRemaining))
    }
    
    private func formattedTime(time: TimeInterval) -> String {
        let minutes = (Int(time) / 60) % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "", message: "You clicked \(count) times for \(secondsPerGame) seconds", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
  
    @IBAction func showGameScore(_ sender: UIButton) {
        let scores = storyboard?.instantiateViewController(withIdentifier: "ScoresViewController") as! ScoresViewController
        scores.modalPresentationStyle = .pageSheet
        scores.scores = allScores.sorted(by: { $0.date < $1.date }).suffix(10)
        if let maxScore = allScores.max(by: { $0.score < $1.score }) {
            scores.bestResult = maxScore.score
        }
        present(scores, animated: true)
    }
}
private extension NSManagedObjectContext {
    
    func load() -> [GameResult] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Game")
        do {
            let scores = try self.fetch(fetchRequest)
            return scores.map { object in
                GameResult(
                    date: object.value(forKeyPath: "date") as! Date,
                    score: object.value(forKeyPath: "score") as! Int
                )
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
    
    func save(_ results: [GameResult]) {
        results.forEach { result in
            let entity = NSEntityDescription.entity(forEntityName: "Game", in: self)!
            let game = NSManagedObject(entity: entity, insertInto: self)
            game.setValue(result.date, forKeyPath: "date")
            game.setValue(result.score, forKeyPath: "score")
        }
        do {
            try save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}


