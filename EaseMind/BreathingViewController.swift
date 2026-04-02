//
//  BreathingViewController.swift
//  EaseMind
//
//  Created by Rahul Sharma on 2026-03-04.
//

import UIKit

class BreathingViewController: UIViewController {

    private let circleView = UIView()
    private let instructionLabel = UILabel()
    private let startButton = UIButton(type: .system)
    
    private var isBreathing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemMint.withAlphaComponent(0.1)
        setupUI()
    }
    
    private func setupUI() {
        
        // Circle View
        circleView.backgroundColor = UIColor.white
        circleView.layer.cornerRadius = 100
        circleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(circleView)
        
        // Instruction Label
        instructionLabel.text = "Tap Start to Begin"
        instructionLabel.font = UIFont(name: "GreatVibes-Regular", size: 30.0)
        instructionLabel.textAlignment = .center
        instructionLabel.textColor = UIColor(red: 0.69, green: 0.96, blue: 0.03, alpha: 1.00)
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(instructionLabel)
        
        // Start Button
        startButton.setTitle("Start Breathing", for: .normal)
        startButton.titleLabel?.font = UIFont(name: "GreatVibes-Regular", size: 30.0)
        startButton.tintColor = UIColor(red: 0.69, green: 0.96, blue: 0.03, alpha: 1.00)
        startButton.addTarget(self, action: #selector(startBreathing), for: .touchUpInside)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startButton)
        
        NSLayoutConstraint.activate([
            
            circleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            circleView.widthAnchor.constraint(equalToConstant: 200),
            circleView.heightAnchor.constraint(equalToConstant: 200),
            
            instructionLabel.bottomAnchor.constraint(equalTo: circleView.topAnchor, constant: -40),
            instructionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            startButton.topAnchor.constraint(equalTo: circleView.bottomAnchor, constant: 40),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func startBreathing() {
        isBreathing.toggle()
        
        if isBreathing {
            startButton.setTitle("Stop", for: .normal)
            breathingAnimation()
        } else {
            startButton.setTitle("Start Breathing", for: .normal)
            instructionLabel.text = "Tap Start to Begin"
            circleView.layer.removeAllAnimations()
            circleView.transform = .identity
        }
    }
    
    private func breathingAnimation() {
        guard isBreathing else { return }
        
        instructionLabel.text = "Breathe In..."
        
        UIView.animate(withDuration: 4, animations: {
            self.circleView.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        }) { _ in
            
            self.instructionLabel.text = "Breathe Out..."
            
            UIView.animate(withDuration: 4, animations: {
                self.circleView.transform = .identity
            }) { _ in
                self.breathingAnimation() // Loop forever
            }
        }
    }
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
