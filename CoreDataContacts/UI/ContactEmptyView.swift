//
//  ContactEmptyView.swift
//  CoreDataContacts
//
//  Created by Glenn Karlo Manguiat on 7/1/25.
//

import SwiftUI

struct ContactEmptyView: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("No contacts found!")
                .font(.headline)
            Text("Tap the plus (+) button to add a new contact.")
                .font(.caption)
        }

    }
}

#Preview {
    ContactEmptyView()
}
