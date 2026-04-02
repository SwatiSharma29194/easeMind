//
//  cardGameViewController.swift
//  EaseMind
//
//  Created by Rahul Sharma on 2026-03-03.
//



import UIKit
import AudioToolbox

class cardGameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var gameBoardView: UIView!
  

    @IBOutlet weak var collectionView: UICollectionView!
   

        var cardDeck = [Card]()
        var firstFlippedIndex: IndexPath?
        
        // 8 calming images, each will have a pair → 16 cards
        let icons = ["matchGame1","matchGame2","matchGame3","matchGame4",
                     "matchGame5","matchGame6","matchGame7","matchGame8"]

        override func viewDidLoad() {
            super.viewDidLoad()
            
            collectionView.delegate = self
            collectionView.dataSource = self
            
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cardCell")
            
            setupDeck()
        }

        func setupDeck() {
            cardDeck.removeAll()
            for (index, icon) in icons.enumerated() {
                cardDeck.append(Card(id: index*2, imageName: icon))
                cardDeck.append(Card(id: index*2+1, imageName: icon))
            }
            cardDeck.shuffle()
            collectionView.reloadData()
        }

        // MARK: - UICollectionViewDataSource

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return cardDeck.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let card = cardDeck[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath)
            
            for view in cell.contentView.subviews { view.removeFromSuperview() }
            
            let imageView = UIImageView(frame: cell.contentView.bounds)
            imageView.contentMode = .scaleAspectFit
            imageView.layer.cornerRadius = 5
            imageView.clipsToBounds = true
            imageView.layer.borderWidth = 1
            imageView.layer.borderColor = UIColor.white.cgColor
            
            if card.isFlipped || card.isMatched {
                imageView.image = UIImage(named: card.imageName ?? "")
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
            } else {
                imageView.image = UIImage(named: "mingMainImg")
                imageView.contentMode = .scaleAspectFit
            }
            
            cell.contentView.addSubview(imageView)
            cell.backgroundColor = UIColor.clear
            return cell
        }

        // MARK: - UICollectionViewDelegate

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let card = cardDeck[indexPath.row]
            if card.isFlipped || card.isMatched { return }

            flipCard(at: indexPath)
            
            if firstFlippedIndex == nil {
                firstFlippedIndex = indexPath
            } else {
                checkForMatch(secondIndex: indexPath)
            }
        }

        // MARK: - Flip & Match Logic with Animation

        func flipCard(at indexPath: IndexPath) {
            cardDeck[indexPath.row].isFlipped = true
            guard let cell = collectionView.cellForItem(at: indexPath) else { return }
            
            let imageView = UIImageView(frame: cell.contentView.bounds)
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 5
            imageView.clipsToBounds = true
            imageView.layer.borderWidth = 1
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.image = UIImage(named: cardDeck[indexPath.row].imageName ?? "")

            UIView.transition(with: cell.contentView,
                              duration: 0.4,
                              options: .transitionFlipFromLeft,
                              animations: {
                                for view in cell.contentView.subviews { view.removeFromSuperview() }
                                cell.contentView.addSubview(imageView)
                              }, completion: nil)
        }

        func unflipCard(at indexPath: IndexPath) {
            cardDeck[indexPath.row].isFlipped = false
            guard let cell = collectionView.cellForItem(at: indexPath) else { return }

            let backImageView = UIImageView(frame: cell.contentView.bounds)
            backImageView.contentMode = .scaleAspectFit
            backImageView.layer.cornerRadius = 5
            backImageView.clipsToBounds = true
            backImageView.layer.borderWidth = 1
            backImageView.layer.borderColor = UIColor.white.cgColor
            backImageView.image = UIImage(named: "mingMainImg")

            UIView.transition(with: cell.contentView,
                              duration: 0.4,
                              options: .transitionFlipFromRight,
                              animations: {
                                for view in cell.contentView.subviews { view.removeFromSuperview() }
                                cell.contentView.addSubview(backImageView)
                              }, completion: nil)
        }

        func checkForMatch(secondIndex: IndexPath) {
            guard let firstIndex = firstFlippedIndex else { return }

            let firstCard = cardDeck[firstIndex.row]
            let secondCard = cardDeck[secondIndex.row]

            if firstCard.imageName == secondCard.imageName {
                cardDeck[firstIndex.row].isMatched = true
                cardDeck[secondIndex.row].isMatched = true
                playMatchSound()
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    self.unflipCard(at: firstIndex)
                    self.unflipCard(at: secondIndex)
                }
            }

            firstFlippedIndex = nil
            checkGameCompletion()
        }

        func checkGameCompletion() {
            let allMatched = cardDeck.allSatisfy { $0.isMatched }
            if allMatched {
                let alert = UIAlertController(title: "Well Done!", message: "You matched all pairs!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { _ in
                    self.setupDeck()
                }))
                present(alert, animated: true)
            }
        }

        func playMatchSound() {
            let systemSoundID: SystemSoundID = 1104
            AudioServicesPlaySystemSound(systemSoundID)
        }

        // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero // remove padding
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5 // small spacing between rows
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5 // small spacing between columns
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 4
        let rows: CGFloat = 4
        let spacing: CGFloat = 5

        let cardWidth = (gameBoardView.frame.width - (columns + 1) * spacing) / columns
        let cardHeight = (gameBoardView.frame.height - (rows + 1) * spacing) / rows

        return CGSize(width: cardWidth, height: cardHeight)
    }

        @IBAction func backBtnTap(_ sender: Any) {
            self.navigationController?.popViewController(animated: true)
        }
    }
