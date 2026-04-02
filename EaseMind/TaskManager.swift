//
//  TaskManager.swift
//  EaseMind
//
//  Created by Rahul Sharma on 2026-02-05.
//

import Foundation

class TaskManager {
    static let shared = TaskManager()
    private init() {}

    func fetchTasks(completion: @escaping ([DailyTask]?) -> Void) {
        guard let url = URL(string: "https://raw.githubusercontent.com/SwatiSharma29194/easeMind/main/tasks.json?version=2") else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching JSON:", error)
                completion(nil)
                return
            }

            guard let data = data else {
                completion(nil)
                return
            }

            do {
                print(String(data: data, encoding: .utf8) ?? "nil")
                let tasks = try JSONDecoder().decode([DailyTask].self, from: data)
                completion(tasks)
            } catch {
                print("Decoding error:", error)
                completion(nil)
            }
        }.resume()
    }
}
