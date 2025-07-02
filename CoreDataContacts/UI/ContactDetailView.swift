//
//  ContactDetailView.swift
//  CoreDataContacts
//
//  Created by Glenn Karlo Manguiat on 7/1/25.
//

import SwiftUI

struct ContactDetailView: View {
    
    let contact: Contact
    
    var body: some View {
        List {
            Section("General") {
                LabeledContent {
                    Text(contact.email)
                } label : {
                    Text("Email")
                }
                
                LabeledContent {
                    Text(contact.phoneNumber)
                } label : {
                    Text("Phone Number")
                }
                
                LabeledContent {
                    Text(contact.birthDate, style: .date)
                } label : {
                    Text("Birthday")
                }
            }
            
            Section("Notes") {
                Text(contact.notes)
            }
        }
        .navigationTitle(contact.formattedName)
        .navigationBarTitleDisplayMode(.inline )
    }
}

#Preview {
    ContactDetailView(contact: .preview())
}
