//
//  Untitled.swift
//  EaseMind
//
//  Created by Rahul Sharma on 2026-02-14.
//

import UIKit
import CoreData

struct MoodItem {
    let mood: String?
    let taskName: String?
    let date: Date?
}
class CoreDataManager {

    static let shared = CoreDataManager()
    private init() {}

    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate)
            .persistentContainer.viewContext
    }

    func saveMood(taskName: String, mood: String) {
        let entry = NSEntityDescription.insertNewObject(
            forEntityName: "MoodHistory",
            into: context
        )

        entry.setValue(Date(), forKey: "date")
        entry.setValue(taskName, forKey: "taskName")
        entry.setValue(mood, forKey: "mood")

        do {
            try context.save()
            print("Saved")
        } catch {
            print("Save error:", error)
        }
    }
    
    func fetchMoodHistory() -> [MoodItem] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MoodHistory")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        do {
            let results = try context.fetch(request) as! [NSManagedObject]

            return results.map {
                MoodItem(
                    mood: $0.value(forKey: "mood") as? String ?? "",
                    taskName: $0.value(forKey: "taskName") as? String ?? "",
                    date: $0.value(forKey: "date") as? Date ?? Date()
                )
            }

        } catch {
            print(" Fetch error:", error)
            return []
        }
    }

}
