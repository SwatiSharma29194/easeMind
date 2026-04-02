//
//  FocusTapViewController.swift
//  EaseMind
//
//  Created by Rahul Sharma on 2026-03-03.
//

import UIKit
import AudioToolbox

class FocusTapViewController: UIViewController {

    private let instructionLabel = UILabel()
    
    // Image names for the game
    private let possibleImages = ["butterfly", "cloud", "flower", "heart", "leaf", "star", "sun"]
    
    // The current target image the user should tap
    private var targetImageName: String!
    
    private var totalItems = 20
    private var itemsSpawned = 0
    private var correctTaps = 0
    
    private var gameTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemMint.withAlphaComponent(0.15)
        setupInstructionLabel()
        showGameInfoPopup()
    }

    // MARK: - Setup

    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    private func setupInstructionLabel() {
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        instructionLabel.textAlignment = .center
        instructionLabel.numberOfLines = 0
        view.addSubview(instructionLabel)

        NSLayoutConstraint.activate([
            instructionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            instructionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    // MARK: - Game Info Popup

    func showGameInfoPopup() {
        let message = """
        This mini game helps improve focus and gently calm your thoughts.
        Tap only the target item. Ignore the others.
        There is no pressure. Just relax and focus 
        """
        let alert = UIAlertController(title: "How to Play Focus Tap", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Start Playing", style: .default, handler: { _ in
            self.startGame()
        }))
        alert.addAction(UIAlertAction(title: "Not Now", style: .cancel))
        present(alert, animated: true)
    }

    // MARK: - Game Logic

    private func startGame() {
        // Pick a random target image
        targetImageName = possibleImages.randomElement()!
        instructionLabel.text = "Tap only the \(targetImageName ?? "")"
        instructionLabel.textColor = UIColor.white
        instructionLabel.font = UIFont(name: "GreatVibes-Regular", size: 25.0)
        itemsSpawned = 0
        correctTaps = 0

        gameTimer = Timer.scheduledTimer(timeInterval: 1.2,
                                         target: self,
                                         selector: #selector(spawnItem),
                                         userInfo: nil,
                                         repeats: true)
    }

    @objc private func spawnItem() {
        if itemsSpawned >= totalItems {
            endGame()
            return
        }

        itemsSpawned += 1

        // Random image from possibleImages
        let imageName = possibleImages.randomElement()!
        let size: CGFloat = 60
        let x = CGFloat.random(in: 20...(view.frame.width - size - 20))
        let y = CGFloat.random(in: 100...(view.frame.height - 200))

        let itemView = createItemImage(named: imageName, size: size)
        itemView.frame.origin = CGPoint(x: x, y: y)
        itemView.tag = (imageName == targetImageName) ? 1 : 0 // 1 = correct

        let tap = UITapGestureRecognizer(target: self, action: #selector(itemTapped(_:)))
        itemView.addGestureRecognizer(tap)
        itemView.isUserInteractionEnabled = true

        view.addSubview(itemView)

        // Fade-in animation
        UIView.animate(withDuration: 0.5) {
            itemView.alpha = 1
        }

        // Remove after 3 seconds if not tapped
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            itemView.removeFromSuperview()
        }
    }

    @objc private func itemTapped(_ sender: UITapGestureRecognizer) {
        guard let itemView = sender.view else { return }

        if itemView.tag == 1 {
            correctTaps += 1
            playSuccessSound()
            gentleGlow(view: itemView)
        } else {
            gentleShake(view: itemView)
        }

        itemView.removeFromSuperview()
    }

    private func endGame() {
        gameTimer?.invalidate()

        let alert = UIAlertController(
            title: "Great Focus",
            message: "You tapped \(correctTaps) correct items.\nWell done!",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { _ in
            self.startGame() // New random target each time
        }))

        alert.addAction(UIAlertAction(title: "Done", style: .cancel))

        present(alert, animated: true)
    }

    // MARK: - Item Creation

    private func createItemImage(named imageName: String, size: CGFloat) -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.frame = CGRect(x: 0, y: 0, width: size, height: size)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.alpha = 0
        return imageView
    }

    // MARK: - Feedback Animations

    private func playSuccessSound() {
        AudioServicesPlaySystemSound(1104)
    }

    private func gentleGlow(view: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { _ in
            view.removeFromSuperview()
        }
    }

    private func gentleShake(view: UIView) {
        UIView.animate(withDuration: 0.1, animations: {
            view.transform = CGAffineTransform(translationX: 5, y: 0)
        }) { _ in
            view.transform = .identity
        }
    }
}
