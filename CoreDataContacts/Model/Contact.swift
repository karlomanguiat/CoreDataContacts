//
//  Contact.swift
//  CoreDataContacts
//
//  Created by Glenn Karlo Manguiat on 7/1/25.
//

import Foundation
import CoreData

final class Contact: NSManagedObject, Identifiable {
    
    @NSManaged var birthDate: Date
    @NSManaged var name: String
    @NSManaged var email: String
    @NSManaged var phoneNumber: String
    @NSManaged var notes: String
    @NSManaged var isFavorite: Bool
    
    var isValid: Bool {
        !name.isEmpty && !email.isEmpty && !phoneNumber.isEmpty
    }
    
    var isBirthday: Bool {
        Calendar.current.isDateInToday(birthDate)
    }
    
    var formattedName: String {
        "\(isBirthday ? "🎉 " : "")\(name)"
    }
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        //Set initial values
        setPrimitiveValue(Date.now, forKey: "birthDate")
        setPrimitiveValue(false, forKey: "isFavorite")
    }
}

extension Contact {
    //Fetch entity
    private static var fetchRequest: NSFetchRequest<Contact> {
        NSFetchRequest(entityName: "Contact")
    }
    
    //Get all contacts
    static func all() -> NSFetchRequest<Contact> {
        let request: NSFetchRequest<Contact> = fetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Contact.name, ascending: true)
        ]
        return request
    }
    
    //Search filter
    static func filter(with config: SearchConfiguration) -> NSPredicate {
        switch config.filter {
            
        case .all:
            return config.query.isEmpty ? NSPredicate(value: true) : NSPredicate(format: "name CONTAINS[cd] %@", config.query)
            
        case .fave:
            return config.query.isEmpty ? NSPredicate(format: "isFavorite == %@", NSNumber(value: true)) : NSPredicate(format: "name CONTAINS[cd] %@ AND isFavorite == %@", config.query, NSNumber(value: true))
            
        }
    }
    
    //Sorting
    static func sort(order: Sort) -> [NSSortDescriptor] {
        [NSSortDescriptor(keyPath: \Contact.name, ascending: order == .ascending)]
    }
        
}

extension Contact {
    
    @discardableResult
    
    //Make a sample preview data
    static func makePreview(count: Int, context: NSManagedObjectContext) -> [Contact] {
        var contacts: [Contact] = []
        
        for _ in 0..<count {
            let contact = Contact(context: context)
            contact.name = "Preview \(Int.random(in: 1...1000))"
            contact.email = "preview@example.com"
            contact.phoneNumber = "+1234567890"
            contact.notes = "Lorem ipsum dolor sit amet."
            contact.isFavorite = Bool.random()
            contact.birthDate = Calendar.current.date(byAdding: .day, value: Int.random(in: -100...100), to: Date.now) ?? Date.now
            contacts.append(contact)
        }
        
        return contacts
    }
    
    //Preview Data with count
    static func preview(context: NSManagedObjectContext = ContactsProvider.shared.viewContext) -> Contact {
        return makePreview(count: 1, context: context)[0]
    }
    
    //Empty Preview
    static func empty(context: NSManagedObjectContext = ContactsProvider.shared.viewContext) -> Contact {
        return Contact(context: context)
    }
}
