//
//  ContactProvider.swift
//  CoreDataContacts
//
//  Created by Glenn Karlo Manguiat on 7/1/25.
//

import Foundation
import CoreData
import SwiftUI

final class ContactsProvider {
    
    static let shared = ContactsProvider()
    
    private let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    var newContext: NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "ContactsDataModel")
        
        if EnvironmentValues.isPreview {
            persistentContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Unable to load store with error: \(error)")
            }
        }
    }
    
    //Check if contact exists
    func exists(_ contact: Contact, in context: NSManagedObjectContext) -> Contact? {
        try? context.existingObject(with: contact.objectID) as? Contact
    }
    
    //Delete contact with Task
    func delete(_ contact: Contact, in context: NSManagedObjectContext) throws {
        if let existingContact = exists(contact, in: context) {
            context.delete(existingContact)
            
            Task (priority: .background) {
                try await context.perform {
                    try context.save()
                }
            }
        }
    }
    
    //Save values whenever changes are received
    func persist(in context: NSManagedObjectContext) throws {
        if context.hasChanges {
            try context.save()
        }
    }
}
extension EnvironmentValues {
    static var isPreview: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
