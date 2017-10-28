//
//  QuizViewController.swift
//  Quiz
//
//  Created by J. Ruof, Meruca on 23/03/16.
//  Copyright © 2016 RuMe Academy. All rights reserved.
//

import UIKit

struct Question {
    let question: String
    let correctAnswer: String
    let answers: [String]
}

class QuizViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet var answerButtons: [UIButton]!
    
    var questionsArray = [Question]()
    var questionIndex = 0
    var currentQuestion: Question!
    
    var timer = Timer()
    var score = 0
    var highscore = UserDefaults.standard.integer(forKey: "Highscore")

    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 10)
        loadQuestions()
    }
    
    func loadQuestions() {
        if let path = Bundle.main.path(forResource: "Questions", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path) {
                let tempArray: Array = dict["Questions"]! as! [Dictionary<String,AnyObject>]
                for dictionary in tempArray {
                    let questionToAdd = Question(question: dictionary["Question"] as! String, correctAnswer: dictionary["CorrectAnswer"] as! String, answers: dictionary["Answers"] as! [String])
                    questionsArray.append(questionToAdd)
                }
                
                loadNextQuestion()
                
            }
        } else {
            print("There was an error")
        }
    }
    
    func loadNextQuestion() {
        currentQuestion = questionsArray[questionIndex]
        titlesForButtons()
    }
    
    func titlesForButtons() {
        for (index,button) in answerButtons.enumerated() {
            button.titleLabel?.lineBreakMode = .byWordWrapping
            button.setTitle(currentQuestion.answers[index], for: UIControlState())
            button.isEnabled = true
            button.backgroundColor = UIColor.white
        }
        
        questionLabel.text = currentQuestion.question
        startTimer()
    }
    
    func startTimer() {
        progressView.progressTintColor = UIColor.green
        progressView.progress = 1.0
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateProgressView), userInfo: nil, repeats: true)
    }
    
    func updateProgressView() {
        progressView.progress -= 0.01/30
        if progressView.progress <= 0 {
            outOfTime()
        } else if progressView.progress <= 0.2 {
            progressView.progressTintColor = UIColor.red
        } else if progressView.progress <= 0.5 {
            progressView.progressTintColor = UIColor.orange
        }
    }
    
    func outOfTime() {
        timer.invalidate()
        showAlert(1)
        for button in answerButtons {
            button.isEnabled = false
        }
    }
    
    @IBAction func questionButtonHandler(_ sender: AnyObject?) {
        questionButton.isEnabled = false
        questionIndex += 1
        if questionIndex < questionsArray.count {
            loadNextQuestion()
        } else {
            showAlert(2)
        }
    }
    
    @IBAction func answerButtonHandler(_ sender: UIButton) {
        timer.invalidate()
        if sender.titleLabel?.text == currentQuestion.correctAnswer {
            score += 1
            questionButton.isEnabled = true
        } else {
            sender.backgroundColor = UIColor.red
            showAlert(0)
        }
        for button in answerButtons {
            button.isEnabled = false
            if button.titleLabel?.text == currentQuestion.correctAnswer {
                button.backgroundColor = UIColor.green
            }
        }
    }
    
    func showAlert(_ reason: Int) {
        if score > highscore {
            highscore = score
            UserDefaults.standard.set(highscore, forKey: "Highscore")
        }
        UserDefaults.standard.set(score, forKey: "RecentScore")
        
        let alertController = UIAlertController()
        switch  reason {
        case 0:
            alertController.title = "You lost!"
            alertController.message = "You have answered a question wrong"
        case 1:
            alertController.title = "You lost!"
            alertController.message = "You ran out of time"
        case 2:
            alertController.title = "You won!"
            alertController.message = "You have answered all questions correctly"
        default:
            break
        }
        
        let ok = UIAlertAction(title: "OK", style: .default) { (alert: UIAlertAction!) -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(ok)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func menuButtonHandler(_ sender: AnyObject?) {
        timer.invalidate()
        dismiss(animated: true, completion: nil)
    }

}
