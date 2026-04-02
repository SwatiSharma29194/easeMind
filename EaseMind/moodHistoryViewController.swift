//
//  moodHistoryViewController.swift
//  EaseMind
//
//  Created by Rahul Sharma on 2026-02-14.
//

import UIKit
import CoreData

class moodHistoryViewController: UIViewController {
 
    @IBOutlet weak var resetBtn: UIButton!
    //    @IBOutlet weak var progressViewHeight: NSLayoutConstraint!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var moodCount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var items: [MoodItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
       
        loadData()
        let count = completedTasksThisWeek()
        if count == 0 {
            moodCount.text = "Start your first session today for this week"
        } else {
            moodCount.text = "You completed \(count) tasks this week. Keep going."
        }
        if(count == 41)
        {
            resetBtnFunc()
        }

        self.tableView.rowHeight = 120
        openProgress()
        //self.tableView.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
    }
    func openProgress()
    {
      
//    progressViewHeight.constant = 120
        let weeklyProgress = WeeklyProgressView()
        weeklyProgress.translatesAutoresizingMaskIntoConstraints = false
        progressView.addSubview(weeklyProgress)

        NSLayoutConstraint.activate([
            weeklyProgress.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            weeklyProgress.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            weeklyProgress.widthAnchor.constraint(equalTo: progressView.widthAnchor),
            weeklyProgress.heightAnchor.constraint(equalTo: progressView.heightAnchor)
        ])
        
//    let count = completedTasksThisWeek()
        let count =   items.count
    weeklyProgress.completedTasks = Double(count)
    weeklyProgress.totalTasks = 41

        if(count >= 41)
        {
            self.resetBtn.isHidden = false
        }
        else
        {
            self.resetBtn.isHidden = true
        }
}
    
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func resetBtnFunc()
    {
        let alert = UIAlertController(
              title: "Congratulations!",
              message: "You have completed 100% of your tasks. Do you want to reset your history?",
              preferredStyle: .alert
          )
          
          let resetAction = UIAlertAction(title: "Reset", style: .destructive) { _ in
              self.clearTasks()
         
          }
          
          let cancelAction = UIAlertAction(title: "Later", style: .cancel)
          
          alert.addAction(resetAction)
          alert.addAction(cancelAction)
          
          self.present(alert, animated: true)
    }
    @IBAction func resetBtnTap(_ sender: Any) {
        resetBtnFunc()
    }
    func clearTasks()
    {
        let alert = UIAlertController(
            title: "Clear All Data",
            message: "This will permanently erase your history. This action cannot be undone.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.clearCoreData()
        })

        present(alert, animated: true)
    }
    @IBAction func clearBtnTap(_ sender: Any) {
        clearTasks()

    }
    func clearCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext

        let entities = context.persistentStoreCoordinator?.managedObjectModel.entities

        entities?.forEach { entity in
            if let name = entity.name {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

                do {
                    try context.execute(deleteRequest)
                } catch {
                    print("Error clearing \(name): \(error)")
                }
            }
        }

        print("All data cleared")
        self.navigationController?.popViewController(animated: true)
    }
    func completedTasksThisWeek() -> Int {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return 0 }

        let context = appDelegate.persistentContainer.viewContext

        let range = startAndEndOfWeek()

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MoodHistory")
        request.predicate = NSPredicate(
            format: "date >= %@ AND date < %@",
            range.start as NSDate,
            range.end as NSDate
        )

        do {
            let count = try context.count(for: request)
            return count
        } catch {
            print("Count error:", error)
            return 0
        }
    }

    func loadData() {
           items = CoreDataManager.shared.fetchMoodHistory()
           tableView.reloadData()
       }
    func startAndEndOfWeek() -> (start: Date, end: Date) {
        let calendar = Calendar.current
        let now = Date()

        let start = calendar.dateInterval(of: .weekOfYear, for: now)!.start
        let end = calendar.date(byAdding: .day, value: 7, to: start)!

        return (start, end)
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
extension moodHistoryViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "moodHistoryTableViewCell", for: indexPath) as! moodHistoryTableViewCell
        let item = items[indexPath.row]

                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
        cell.taskName.text =  item.taskName
                
        cell.moodDate.text = formatter.string(from: item.date!)
        
        switch item.mood {
        case "happy":
            cell.moodImg.image = UIImage(named: "happy")
            break
        case "relaxed":
            cell.moodImg.image = UIImage(named: "relaxed")
            break
        case "neutral":
            cell.moodImg.image = UIImage(named: "neutral")
            break
        case "sad":
            cell.moodImg.image = UIImage(named: "sad")
        case "angry":
            cell.moodImg.image = UIImage(named: "angry")
            break
        case "Not shared":
            cell.moodImg.image = UIImage(named: "thoughtbubble")
        default: break
            
        }
        return cell
    }
}
