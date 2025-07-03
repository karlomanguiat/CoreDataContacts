//
//  ContentView.swift
//  CoreDataContacts
//
//  Created by Glenn Karlo Manguiat on 7/1/25.
//

import SwiftUI

struct ContentView: View {
    @State private var contactToEdit: Contact?
    @State private var searchText: SearchConfiguration = .init()
    
    @FetchRequest(fetchRequest: Contact.all()) private var contacts
    
    var provider = ContactsProvider.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                if contacts.isEmpty {
                    ContactEmptyView()
                } else {
                    List {
                        ForEach(contacts) { contact in
                            ZStack(alignment: .leading) {
                                NavigationLink(destination: ContactDetailView(contact: contact)) {
                                    EmptyView()
                                }
                                .opacity(0)
                                
                                ContactRowView(contact: contact, provider: provider)
                                    .swipeActions(allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            do {
                                                try provider.delete(contact, in: provider.newContext)
                                            } catch {
                                                print(error)
                                            }
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                        .tint(.red)
                                        
                                        Button {
                                            contactToEdit = contact
                                        } label: {
                                            Label("Edit", systemImage: "pencil")
                                        }
                                        .tint(.orange)

                                    }
                                
                                
                                
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText.query)
            .navigationTitle("Contacts")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        contactToEdit = .empty(context: provider.newContext)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(item: $contactToEdit, onDismiss: {
                contactToEdit = nil
                
            }, content: { contact in
                
                NavigationStack {
                    AddNewContactView(viewModel: .init(contact: contact, provider: provider))
                }
                
            })
            .onChange(of: searchText) { oldValue, newValue in
                contacts.nsPredicate = NSPredicate(format: "name CONTAINS[cd] %@", newValue.query)
            }
            
            
        }
    }
}

struct SearchConfiguration: Equatable {
    var query: String = ""
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
