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
    private var hardModeTimer = Timer()
    
    @IBOutlet private weak var playField: UIView!
    @IBOutlet private weak var redSquare: UIButton!
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var switchLevel: UISegmentedControl!
    @IBOutlet private weak var scores: UIButton!
    
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
            
            let disabledSegmentIndex = isHardMode ? 0 : 1
            switchLevel.setEnabled(false, forSegmentAt: disabledSegmentIndex)
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
        if secondsRemaining > 0 {
            secondsRemaining -= 1
        } else {
            timer.invalidate()
            showAlert()
            secondsRemaining = secondsPerGame
            count = 0
            hardModeTimer.invalidate()
            redSquare.frame.origin = CGPoint(x: 8, y: 8)
            switchLevel.setEnabled(true, forSegmentAt: 1)
            switchLevel.setEnabled(true, forSegmentAt: 0)
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
        print("Game: 10")
    }
}

