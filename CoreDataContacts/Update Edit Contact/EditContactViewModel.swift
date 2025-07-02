//
//  File.swift
//  CoreDataContacts
//
//  Created by Glenn Karlo Manguiat on 7/1/25.
//

import Foundation
import CoreData

final class EditContactViewModel: ObservableObject {
    
    @Published var contact: Contact
    
    var isNew: Bool
    
    private let context: NSManagedObjectContext
    
    init(contact: Contact? = nil, provider: ContactsProvider) {
        self.context = provider.newContext
        
        if let contact, let existingContactCopy = try? context.existingObject(with: contact.objectID) as? Contact {
            self.contact = existingContactCopy
            self.isNew = false
        } else {
            self.contact = Contact(context: self.context)
            self.isNew = true
        }
        
    }
    
    
    func save() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}
