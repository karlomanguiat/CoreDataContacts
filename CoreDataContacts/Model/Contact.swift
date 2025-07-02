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
    
    var isBirthday: Bool {
        Calendar.current.isDateInToday(birthDate)
    }
    
    var formattedName: String {
        "\(isBirthday ? "🎉 " : "")\(name)"
    }
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        setPrimitiveValue(Date.now, forKey: "birthDate")
        setPrimitiveValue(false, forKey: "isFavorite")
    }
}

extension Contact {
    private static var fetchRequest: NSFetchRequest<Contact> {
        NSFetchRequest(entityName: "Contact")
    }
    
    static func all() -> NSFetchRequest<Contact> {
        let request: NSFetchRequest<Contact> = fetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Contact.name, ascending: true)
        ]
        return request
    }
}

extension Contact {
    
    @discardableResult
    
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
    
    static func preview(context: NSManagedObjectContext = ContactsProvider.shared.viewContext) -> Contact {
        return makePreview(count: 1, context: context)[0]
    }
    
    static func empty(context: NSManagedObjectContext = ContactsProvider.shared.viewContext) -> Contact {
        return Contact(context: context)
    }
}
