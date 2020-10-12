//
//  ViewController.swift
//  Quiz
//
//  Created by Tariq Almazyad on 10/12/20.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "Reset_Passcode_Page")
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to the\nQuiz App"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 42)
        label.adjustsFontSizeToFitWidth = true
        label.setHeight(height: 80)
        return label
    }()
    
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to the\nQuiz App"
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 42)
        label.adjustsFontSizeToFitWidth = true
        label.setHeight(height: 100)
        return label
    }()
    
    private lazy var nextQuestionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setHeight(height: 50)
        button.layer.cornerRadius = 50 / 2
        button.semanticContentAttribute = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        button.backgroundColor = .white
        button.tintColor = .black
        button.setTitle("Next  ", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.black, for: .normal)
        button.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        button.addTarget(self, action: #selector(handleNextQuestionPressed), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var answerLabel: UILabel = {
        let label = UILabel()
        label.text = "???"
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 42)
        label.adjustsFontSizeToFitWidth = true
        label.setHeight(height: 100)
        return label
    }()
    
    private lazy var showAnswerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setHeight(height: 50)
        button.layer.cornerRadius = 50 / 2
        button.semanticContentAttribute = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        button.backgroundColor = #colorLiteral(red: 0.2431372549, green: 0.2666666667, blue: 0.3137254902, alpha: 1)
        button.tintColor = .white
        button.setTitle("Show answer    ", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(handleShowAnswerTapped), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        button.setImage(UIImage(systemName: "doc.text.magnifyingglass"), for: .normal)
        return button
    }()
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [questionLabel,
                                                       nextQuestionButton])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.setDimensions(height: 200, width: 400)
        return stackView
    }()
    
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [answerLabel,
                                                       showAnswerButton])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.setDimensions(height: 200, width: 400)
        return stackView
    }()
    
    let questions = [
        QuestionBank(question: "4 + 4 = 8", answer: "true"),
        QuestionBank(question: "4 - 4 = 8", answer: "false"),
        QuestionBank(question: "4 + 4 = 8", answer: "true"),
        QuestionBank(question: "4 + 5 = 9", answer: "true"),
        QuestionBank(question: "What is 7+7?", answer: "It is 14")
        
    ]
    
    var questionIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureQuestion()
    }
    
    func configureUI(){
        view.addSubview(backgroundImageView)
        backgroundImageView.fillSuperview()
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        titleLabel.anchor(left: view.leftAnchor, right: view.rightAnchor)
        view.addSubview(topStackView)
        topStackView.centerX(inView: titleLabel, topAnchor: titleLabel.bottomAnchor, paddingTop: 12)
        view.addSubview(bottomStackView)
        bottomStackView.centerX(inView: topStackView, topAnchor: topStackView.bottomAnchor, paddingTop: 50)
    }
    
    func configureQuestion(){
        questionLabel.text = questions[questionIndex].question
    }
    
    @objc private func handleShowAnswerTapped(){
        answerLabel.text = questions[questionIndex].answer
    }
    
    @objc private func handleNextQuestionPressed(){
        questionIndex += 1
        if questionIndex == questions.count {
            questionIndex = 0
            self.showAlertMessage("The End", "You have reached to the end of the questions\nPress okay to begin again")
        }
        let nextQuestion = questions[questionIndex].question
        questionLabel.text = nextQuestion
        answerLabel.text = "???"
    }
    
    
}

