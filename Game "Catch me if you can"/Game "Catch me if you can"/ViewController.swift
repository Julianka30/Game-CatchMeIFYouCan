//
//  ViewController.swift
//  Game "Catch me if you can"
//
//  Created by Julia on 13.02.2023.
//

import UIKit

class ViewController: UIViewController {
    private var count = 0
    private let secondsPerGame = 10
    private var secondsRemaining = 0
    private var timer = Timer()
    
    @IBOutlet private weak var playField: UIView!
    @IBOutlet private weak var redSquare: UIButton!
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var switchLevel: UISegmentedControl!
    
    @IBAction private func tapSquare(_ sender: UIButton) {
        let maxX = playField.frame.size.width - redSquare.frame.size.width
        let maxY = playField.frame.size.height - redSquare.frame.size.height
        redSquare.frame.origin = CGPoint(x: .random(in: 0...maxX), y: .random(in: 0...maxY))
        if count == 0 {
            secondsRemaining = secondsPerGame
            runTimer()
        }
        count += 1
    }

    private func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc
    private func updateTimer() {
        if secondsRemaining > 0 {
            secondsRemaining -= 1
        } else {
            timer.invalidate()
            showAlert()
            secondsRemaining = secondsPerGame
            count = 0
            redSquare.frame.origin = CGPoint(x: 8, y: 8)
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
}

