//
//  ContactRowView .swift
//  CoreDataContacts
//
//  Created by Glenn Karlo Manguiat on 7/1/25.
//

import SwiftUI

struct ContactRowView: View {
    @Environment(\.managedObjectContext) private var managedObjContext
    
    @ObservedObject var contact: Contact
    
    let provider: ContactsProvider
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(contact.formattedName)
                .font(.headline)
            Text(contact.email)
                .font(.caption)
            Text(contact.phoneNumber)
                .font(.caption)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(alignment: .topTrailing) {
            Button {
                toggleFavorite()
            } label: {
                Image(systemName: "star")
                    .font(.title3)
                    .symbolVariant(.fill)
                    .foregroundColor(contact.isFavorite ? .yellow :.gray.opacity(0.3))
            }
            .buttonStyle(.plain)
        }
    }
}

private extension ContactRowView {
    
    func toggleFavorite() {
        contact.isFavorite.toggle()
        do {
            //Save changes
            try provider.persist(in: managedObjContext)
        } catch {
            print(error)
        }
    }
}

#Preview {
    let previewProvider = ContactsProvider.shared
    ContactRowView(contact: .preview(context: previewProvider.viewContext), provider: previewProvider)
}
