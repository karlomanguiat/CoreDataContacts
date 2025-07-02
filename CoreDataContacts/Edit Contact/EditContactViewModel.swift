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
    
    private let context: NSManagedObjectContext
    
    init(contact: Contact? = nil, provider: ContactsProvider) {
        self.context = provider.newContext
        self.contact = Contact(context: self.context)
    }
    
    func save() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}
