//
//  ContentView.swift
//  CoreDataContacts
//
//  Created by Glenn Karlo Manguiat on 7/1/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isShowingNewContact = false
    
    @FetchRequest(fetchRequest: Contact.all()) private var contacts
    
    var provider = ContactsProvider.shared
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(contacts) { contact in
                    ZStack(alignment: .leading) {
                        NavigationLink(destination: ContactDetailView(contact: contact)) {
                            EmptyView()
                        }
                        .opacity(0)
                        
                        ContactRowView(contact: contact)
                    }
                   
                }
            }
            .navigationTitle("Contacts")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isShowingNewContact.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingNewContact) {
                NavigationStack {
                    AddNewContactView(viewModel: .init(provider: provider))
                }
            }
        }
    }
}

#Preview {
    let preview = ContactsProvider.shared
    ContentView(provider: preview)
        .environment(\.managedObjectContext, preview.viewContext)
        .onAppear {
            Contact.makePreview(count: 4, context: preview.viewContext)
        }
}

#Preview {
    let emptyPreview = ContactsProvider.shared
    ContentView(provider: emptyPreview)
        .environment(\.managedObjectContext, emptyPreview.viewContext)
}
