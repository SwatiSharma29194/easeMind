//
//  listGamesViewController.swift
//  EaseMind
//
//  Created by Rahul Sharma on 2026-03-03.
//

import UIKit

class listGamesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    var nameArr = ["Mindful Match", "Focus Tap", "Mind Slide","Inhale Calm"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()

        // Padding for edges
        let padding: CGFloat = 10
        let interItemSpacing: CGFloat = 5
        let numberOfColumns: CGFloat = 2

        // Calculate item width dynamically
        let totalSpacing = (numberOfColumns - 1) * interItemSpacing + padding*2
        let itemWidth = (collectionView.frame.width - totalSpacing) / numberOfColumns
        let itemHeight = itemWidth  // Square cells, you can adjust if you want rectangle

        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        layout.minimumInteritemSpacing = interItemSpacing
        layout.minimumLineSpacing = interItemSpacing
        layout.scrollDirection = .vertical

        collectionView.collectionViewLayout = layout
        // Do any additional setup after loading the view.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nameArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listGamesCollectionViewCell", for: indexPath) as! listGamesCollectionViewCell
        cell.gameView.layer.borderColor = UIColor.white.cgColor
        cell.gameView.layer.borderWidth = 1
        cell.gameView.layer.cornerRadius = 5
        cell.gameView.clipsToBounds = true
        cell.gameNameLbl.text = nameArr[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.row == 0)
        {
            let alert = UIAlertController(
                title: "How to Play",
                message: """
            Flip the cards to find matching pairs.
            Take your time and focus calmly.
            Match all pairs to complete the game.
            """,
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "Start Playing", style: .default, handler: { _ in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "cardGameViewController")
                self.navigationController?.pushViewController(vc!, animated: true)
            }))

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

            present(alert, animated: true)
        }
        else if(indexPath.row == 1)
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FocusTapViewController")
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        else if (indexPath.row == 2)
        {
            let alert = UIAlertController(
                title: "How to Play",
                message: "Slide the tiles to complete the image and relax your mind.",
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "Start Playing", style: .default, handler: { _ in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "RandomImageSlidePuzzleViewController")
                self.navigationController?.pushViewController(vc!, animated: true)
            }))

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

            present(alert, animated: true)
        }
        else if (indexPath.row == 3)
        {
            let alert = UIAlertController(
                title: "How to Play",
                message: "Breathe in as the circle expands and breathe out as it gently shrinks.",
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "Start Playing", style: .default, handler: { _ in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "BreathingViewController")
                self.navigationController?.pushViewController(vc!, animated: true)
            }))

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

            present(alert, animated: true)
        }
//        {
//         
//                
//                let message = """
//                Tap only the correct shapes, stay calm, and focus gently to complete the game
//                """
//                
//                let alert = UIAlertController(
//                    title: "How to Play Focus Tap",
//                    message: message,
//                    preferredStyle: .alert
//                )
//                
//                alert.addAction(UIAlertAction(title: "Start Playing", style: .default, handler: { _ in
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "FocusTapViewController")
//                    self.navigationController?.pushViewController(vc!, animated: true)
//                }))
//                
//                alert.addAction(UIAlertAction(title: "Not Now", style: .cancel))
//                
//                present(alert, animated: true)
//            }
        
    }
    
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
