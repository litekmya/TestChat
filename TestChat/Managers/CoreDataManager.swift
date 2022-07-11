//
//  CoreDataManager.swift
//  TestChat
//
//  Created by Владимир Ли on 09.07.2022.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TestChat")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {}
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func save(message: String, imageData: Data) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Message", in: context) else { return }
        guard let userMessage = NSManagedObject(entity: entityDescription, insertInto: context) as? Message else { return }
        
        userMessage.text = message
        userMessage.imageData = imageData
        userMessage.date = Date()
                
        saveContext()
    }
    
    func fetchData() -> [Message] {
        var messages: [Message] = []
        let fetchRequest: NSFetchRequest<Message> = Message.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            messages = try context.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
        
        return messages
    }
    
    func delete(message: Message) {
        context.delete(message)
        saveContext()
    }
}
