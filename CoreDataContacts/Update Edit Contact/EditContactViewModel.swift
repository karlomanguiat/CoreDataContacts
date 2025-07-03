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
    
    private let provider: ContactsProvider
    private let context: NSManagedObjectContext
    
    init(contact: Contact? = nil, provider: ContactsProvider) {
        self.provider = provider
        self.context = provider.newContext
        
        //Check if existing already to edit/update
        //Else make a new contact
        if let contact, let existingContactCopy = provider.exists(contact, in: context) {
            self.contact = existingContactCopy
            self.isNew = false
        } else {
            self.contact = Contact(context: self.context)
            self.isNew = true
        }
        
    }
    
    //User provider to save data
    func save() throws {
        try provider.persist(in: context)
    }
}
