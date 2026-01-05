//
//  AddItemView.swift
//  InventoryTool
//
//  Created by Hlib Myasnychenko on 1/4/26.
//

import SwiftUI

struct AddItemView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var store: PantryStore

    @State private var name: String = ""
    @State private var quantity: Int = 1
    @State private var expiresOn: Date = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
    @State private var notes: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Item") {
                    TextField("Name", text: $name)
                    Stepper("Quantity: \(quantity)", value: $quantity, in: 1...999)
                }

                Section("Expiration") {
                    DatePicker("Expires on", selection: $expiresOn, displayedComponents: .date)
                }

                Section("Notes") {
                    TextField("Optional", text: $notes)
                }
            }
            .navigationTitle("Add Item")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let item = PantryItem(name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                                              quantity: quantity,
                                              expiresOn: expiresOn,
                                              notes: notes)
                        store.addItem(item)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
