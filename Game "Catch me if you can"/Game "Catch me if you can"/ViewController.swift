//
//  ViewController.swift
//  Game "Catch me if you can"
//
//  Created by Julia on 13.02.2023.
//

import UIKit

class ViewController: UIViewController {
    var count = 0
    let secondsPerGame = 10
    var secondsRemaining = 0
    var myTimer = Timer()
    
    
    @IBOutlet weak var playField: UIView!
    
    @IBOutlet weak var redSquare: UIButton!
    
    @IBOutlet weak var timer: UILabel!
    
    @IBOutlet weak var switchLevel: UISegmentedControl!
    
    
    @IBAction func tapSquare(_ sender: UIButton) {
        let maxX = playField.frame.size.width - redSquare.frame.size.width
        let maxY = playField.frame.size.height - redSquare.frame.size.height
        redSquare.frame.origin = CGPoint(x: .random(in: 0...maxX), y: .random(in: 0...maxY))
        if count == 0 {
            secondsRemaining = secondsPerGame
            runTimer()
        }
        count += 1
    }

    func runTimer() {
        myTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if secondsRemaining > 0 {
            secondsRemaining -= 1
        } else {
            myTimer.invalidate()
            showAlert(count: count, time: secondsPerGame)
            secondsRemaining = secondsPerGame
            count = 0
            redSquare.frame.origin = CGPoint(x: 8, y: 8)
        }
        timer.text = timeString(time: TimeInterval(secondsRemaining))
    }
    
    func timeString(time: TimeInterval) -> String {
        let minutes = (Int(time) / 60) % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    func showAlert(count: Int, time: Int) {
        let alertController = UIAlertController(title: "", message: "You clicked \(count) times for \(time) seconds", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true)
    }
}

