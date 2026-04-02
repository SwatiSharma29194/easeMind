//
//  Untitled.swift
//  EaseMind
//
//  Created by Rahul Sharma on 2026-02-15.
//

import UIKit

class WeeklyProgressView: UIView {

    private let backgroundCircle = CAShapeLayer()
    private let progressCircle = CAShapeLayer()
    private let percentageLabel = UILabel()
    private let infoLabel = UILabel()
    
    // completed / total
    var completedTasks: Double = 0 {
        didSet { setProgress() }
    }
    var totalTasks: Double = 1 {
        didSet { setProgress() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        // Background Circle
        backgroundCircle.strokeColor = UIColor.darkGray.cgColor
        backgroundCircle.fillColor = UIColor.clear.cgColor
        backgroundCircle.lineWidth = 12
        layer.addSublayer(backgroundCircle)
        
        // Progress Circle
        progressCircle.strokeColor = UIColor.white.cgColor
        progressCircle.fillColor = UIColor.clear.cgColor
        progressCircle.lineWidth = 12
        progressCircle.lineCap = .round
        progressCircle.strokeEnd = 0
        layer.addSublayer(progressCircle)
        
        // Percentage Label
        percentageLabel.font = UIFont.boldSystemFont(ofSize: 20)
        percentageLabel.textAlignment = .center
        percentageLabel.textColor = .black
        addSubview(percentageLabel)
        
        // Info Label
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        infoLabel.textAlignment = .center
        infoLabel.textColor = .gray
        infoLabel.numberOfLines = 2
        addSubview(infoLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let centerPoint = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height)/2
        let circularPath = UIBezierPath(arcCenter: centerPoint, radius: radius, startAngle: -CGFloat.pi/2, endAngle: 3*CGFloat.pi/2, clockwise: true)
        
        backgroundCircle.path = circularPath.cgPath
        progressCircle.path = circularPath.cgPath
        
        percentageLabel.frame = CGRect(x: 0, y: bounds.midY - 20, width: bounds.width, height: 30)
        infoLabel.frame = CGRect(x: 0, y: bounds.midY + radius/2, width: bounds.width, height: 40)
    }
    
    private func setProgress() {
        let progress = totalTasks == 0 ? 0 : completedTasks / totalTasks
        progressCircle.strokeEnd = CGFloat(progress)
        if(completedTasks > totalTasks)
        {
            percentageLabel.text = "100%"
        }
        else
        {
            percentageLabel.text = "\(Int(progress * 100))%"
        }
        percentageLabel.textColor = .white
//        infoLabel.text = "\(Int(completedTasks)) / \(Int(totalTasks)) Tasks Completed\nGreat job! Keep it up 🌟"
        //infoLabel.text = "Great job! Keep it up"
        // Optional: Animate the stroke
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = progress
        animation.duration = 0.7
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        progressCircle.add(animation, forKey: "progressAnim")
    }
}
