//
//  TaskService.swift
//  TestApp
//
//  Created by Ramazan Iusupov on 26/7/23.
//

import Foundation
import CoreData

class DataManager {
    
    static let shared = DataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Tasks")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
  
    func removeTask(_ task: Task) {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.sortDescriptors = [.init(key: "creationDate", ascending: true)]
        persistentContainer.viewContext.delete(task)
        save()
    }
    
    func fetchTasks() -> [Task] {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.sortDescriptors = [.init(key: "creationDate", ascending: true)]
        var fetchedTasks: [Task] = []
        
        do {
            fetchedTasks = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print(error.localizedDescription)
        }
        return fetchedTasks
            .compactMap { $0 }
            .filter {
                $0.title != nil &&
                $0.creationDate != nil &&
                $0.creationTime != nil
            }
    }
    
    func fetchTasksByDate() -> [String: Int] {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.sortDescriptors = [.init(key: "creationDate", ascending: true)]
        var fetchedTasks: [Task] = []
        
        do {
            fetchedTasks = try persistentContainer
                .viewContext
                .fetch(request)
                .compactMap { $0 }
                .filter {
                    $0.title != nil &&
                    $0.creationDate != nil &&
                    $0.creationTime != nil
                }
        } catch let error {
            print(error.localizedDescription)
        }
        
        let date = fetchedTasks.map {
            ($0.creationDate ?? Date()).format(format: .yyyyMMMMdd)
        }
        
        let sortedData = date.reduce(into: [String: Int]()) {
            if $0.keys.contains($1) {
                $0[$1]! += 1
            } else {
                $0[$1] = 1
            }
        }
        return sortedData
    }
    
    func save() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("❗️Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
