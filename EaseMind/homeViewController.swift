//
//  homeViewController.swift
//  EaseMind
//
//  Created by Rahul Sharma on 2026-01-20.
//

import UIKit

class homeViewController: UIViewController {

    @IBOutlet weak var musicPlayPause: UIButton!
    @IBOutlet weak var choodeMoodView: UIView!
    @IBOutlet weak var angryImg: UIImageView!
    @IBOutlet weak var sadImg: UIImageView!
    @IBOutlet weak var neutralImg: UIImageView!
    @IBOutlet weak var relaxedImg: UIImageView!
    @IBOutlet weak var happyBtn: UIButton!
    @IBOutlet weak var happyImg: UIImageView!
    @IBOutlet weak var moodView: UIView!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var taskImg: UIImageView!
    @IBOutlet weak var taskDescription: UILabel!
    @IBOutlet weak var taskName: UILabel!
    var moodName = ""
    var playBtn = false
    private var tasks: [DailyTask] = []
    
       private var remainingTasks: [DailyTask] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        AudioManager.shared.setupAudio()
        addSwipeGesture()
     
        TaskManager.shared.fetchTasks { [weak self] fetchedTasks in
                    guard let self = self, let fetchedTasks = fetchedTasks else { return }
                    DispatchQueue.main.async {
                        self.tasks = fetchedTasks

                             if self.remainingTasks.isEmpty {
                                 self.remainingTasks = self.tasks
                             }

                             self.showRandomTask()
        
                      
                    }
                }
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        playBtn = false
        musicPlayPause.setImage(UIImage(named: "play"), for: .normal)
        AudioManager.shared.pause()
        AudioManager.shared.alreadyPlayed = false
    }
    @objc func handleSwipe() {
     
        showRandomTask()
    }
    func addSwipeGesture() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeUp.direction = .left
        self.outerView.addGestureRecognizer(swipeUp)
        
        
    }
    func showRandomTask() {

        // Reset only AFTER all tasks are used
        if tasks.isEmpty {
        
            return
        }
            
        if remainingTasks.isEmpty {
            remainingTasks = tasks
        }

        let index = Int.random(in: 0..<remainingTasks.count)
        let task = remainingTasks[index]
        remainingTasks.remove(at: index)
        self.taskName.text = task.taskName
        self.taskDescription.text = task.taskDescription
        let url = URL(string: task.image ?? "")!

        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data:data){
                    DispatchQueue.main.async{
                        self?.taskImg.image = image
                    }
                }
            }
        }
    }

    @IBAction func gamesBtnTap(_ sender: Any) {
    }
    @IBAction func nextModdBtnTap(_ sender: Any) {
        if(happyImg.tintColor == .black && relaxedImg.tintColor == .black && neutralImg.tintColor == .black && sadImg.tintColor == .black && angryImg.tintColor == .black)
        {
                    let alert  = UIAlertController(title: "", message: "It’s okay if you don’t want to share your feeling. But if you do, it might help you feel a little better. Maybe give it a try next time.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
        }
        else if(happyImg.tintColor == .red || relaxedImg.tintColor == .red)
        {
            let alert  = UIAlertController(title: "", message: "Its nice getting to know that you are happy and relaxed", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if(neutralImg.tintColor == .red)
        {
            let alert  = UIAlertController(title: "", message: "You are having neutral feeling. So, You can try more if you want", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "", message: "I’m really sorry you’re feeling this way. Thanks for letting us know. If you’d like, you can try another task.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        moodView.isHidden = true
        choodeMoodView.isHidden = true
       

            if  happyImg.tintColor == .red
            {
              moodName = "happy"
          }
        else if  relaxedImg.tintColor == .red
        {
          moodName = "relaxed"
      }
      else  if  neutralImg.tintColor == .red
        {
          moodName = "neutral"
      }
        else if  sadImg.tintColor == .red
        {
          moodName = "sad"
      }
       else if  angryImg.tintColor == .red
        {
          moodName = "angry"
      }
     else
        {
         moodName = "Not shared"
     }
        CoreDataManager.shared.saveMood(
            taskName: taskName.text ?? "",
            mood: moodName
        )
        showRandomTask()
    }
    @IBAction func happyBtnTap(_ sender: Any) {
      //  happyImg.tintColor = UIColor(red: 0.69, green: 0.96, blue: 0.03, alpha: 1.00)
        happyImg.tintColor = .red
        relaxedImg.tintColor = .black
        neutralImg.tintColor = .black
        sadImg.tintColor = .black
        angryImg.tintColor = .black
    }
    
    @IBAction func relaxedBtnTap(_ sender: Any) {
        happyImg.tintColor = .black
        relaxedImg.tintColor = .red
        neutralImg.tintColor = .black
        sadImg.tintColor = .black
        angryImg.tintColor = .black
    }
    @IBAction func neutralBtntAp(_ sender: Any)
    {
        happyImg.tintColor = .black
        relaxedImg.tintColor = .black
        neutralImg.tintColor = .red
        sadImg.tintColor = .black
        angryImg.tintColor = .black
    }
    
    @IBAction func sadBtnTap(_ sender: Any) {
        happyImg.tintColor = .black
        relaxedImg.tintColor = .black
        neutralImg.tintColor = .black
        sadImg.tintColor = .red
        angryImg.tintColor = .black
    }
    @IBAction func angryBtnTap(_ sender: Any) {
        happyImg.tintColor = .black
        relaxedImg.tintColor = .black
        neutralImg.tintColor = .black
        sadImg.tintColor = .black
        angryImg.tintColor = .red
    }
    @IBAction func doneBtnTap(_ sender: Any) {
//        let alert  = UIAlertController(title: "Complete Task !", message: "Did you complete this task and feel relaxed?", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
        let alertController = UIAlertController(title: "Complete Task!", message: "Did you manage to complete this task?", preferredStyle: .alert)

        // Create the actions
        let okAction = UIAlertAction(title: "YES", style: .default) { action in
            self.moodView.isHidden = false
            self.choodeMoodView.isHidden = false
            self.happyImg.tintColor = .black
            self.relaxedImg.tintColor = .black
            self.neutralImg.tintColor = .black
            self.sadImg.tintColor = .black
            self.angryImg.tintColor = .black
        }

        let cancelAction = UIAlertAction(title: "NO", style: .cancel) { action in
            let alert2 = UIAlertController(title: "No worries", message: "Okay, no worries, try this again or try another.", preferredStyle: .alert)
            
            alert2.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            // Present the second alert
            self.present(alert2, animated: true, completion: nil)
        }

        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        // Present the first alert
        self.present(alertController, animated: true, completion: nil)



    }
    
    @IBAction func musicPlayPauseBtnTap(_ sender: Any) {
        if(playBtn == false)
        {
            AudioManagerList.shared.stop()
            AudioManager.shared.play()
            playBtn = true
            musicPlayPause.setImage(UIImage(named: "pause"), for: .normal)
            AudioManager.shared.alreadyPlayed = true
        }
        else
        {
            playBtn = false
            musicPlayPause.setImage(UIImage(named: "play"), for: .normal)
            AudioManager.shared.pause()
            AudioManager.shared.alreadyPlayed = false
        }
    }
    @IBAction func historyBtnTap(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "moodHistoryViewController")
        self.navigationController?.pushViewController(vc!, animated: true)
             
        
    }
    @IBAction func listGamesBtnTap(_ sender: Any) {

        
        let alert = UIAlertController(
            title: "Relax & Refresh",
            message: "Would you like to play a small calming game to relax your mind?",
            preferredStyle: .alert
        )

        // Play action
        alert.addAction(UIAlertAction(title: "Play", style: .default, handler: { _ in
            // Navigate to MemoryGameViewController
            let vc = self.storyboard?.instantiateViewController(identifier: "listGamesViewController")
            self.navigationController?.pushViewController(vc!, animated: true)
        }))

        // Cancel action
        alert.addAction(UIAlertAction(title: "Maybe Later", style: .cancel, handler: nil))

        present(alert, animated: true)
    }
    
    
    @IBAction func nextTaskBtnTap(_ sender: Any) {
        showRandomTask()
      }
  
    @IBAction func musicList(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "musicListViewController") as! musicListViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addReminderBtnTap(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "reminderViewController") as! reminderViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AudioManager.shared.pause()
        AudioManager.shared.alreadyPlayed = false
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
