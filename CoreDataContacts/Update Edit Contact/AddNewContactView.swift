//
//  AddNewContactView.swift
//  CoreDataContacts
//
//  Created by Glenn Karlo Manguiat on 7/1/25.
//

import SwiftUI

struct AddNewContactView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: EditContactViewModel
    
    @State private var hasError: Bool = false
    
    var body: some View {
        List {
            Section("General") {
                TextField("Name", text:$viewModel.contact.name)
                    .keyboardType(.namePhonePad)
                
                TextField("Email", text:$viewModel.contact.email)
                    .keyboardType(.emailAddress)
                
                TextField("Phone Number", text:$viewModel.contact.phoneNumber)
                    .keyboardType(.phonePad)
                
                DatePicker("Birthday",
                           selection: $viewModel.contact.birthDate,
                           displayedComponents: .date)
                .datePickerStyle(.compact)
                
                Toggle("Favorite", isOn: $viewModel.contact.isFavorite)
            }
            
            Section("Notes") {
                TextField("",
                          text: $viewModel.contact.notes,
                          axis: .vertical )
            }
        }
        .navigationTitle(viewModel.isNew ? "Add New Contact" : "Update Contact")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                   validateContact()
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .alert(isPresented: $hasError) {
            Alert(title: Text("Validation Error"),
                  message: Text("Please fill out all required fields."))
        }
    }
}

private extension AddNewContactView {
    func validateContact() {
        if viewModel.contact.isValid {
            do {
                try viewModel.save()
                dismiss()
            } catch {
                print(error)
            }
        } else {
            hasError = true
        }
    }
}

#Preview {
    NavigationStack {
        let preview = ContactsProvider.shared
        
        AddNewContactView(viewModel: .init(provider: preview))
            .environment(\.managedObjectContext, preview.viewContext)
    }
}
