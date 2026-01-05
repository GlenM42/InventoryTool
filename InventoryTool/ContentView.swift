//
//  ContentView.swift
//  InventoryTool
//
//  Created by Hlib Myasnychenko on 1/4/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var store = PantryStore()
    @State private var showingAdd = false

    var body: some View {
        NavigationStack {
            List {
                Section("Expiring soon") {
                    ForEach(store.items) { item in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.name)
                                    .font(.headline)
                                Text("Qty: \(item.quantity)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Text(item.expiresOn, style: .date)
                                .font(.subheadline)
                        }
                    }
                    .onDelete(perform: store.delete)
                }
            }
            .navigationTitle("Inventory")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddItemView(store: store)
            }
        }
    }
    
    private func daysRemainingText(_ date: Date) -> String {
        let start = Calendar.current.startOfDay(for: Date())
        let end = Calendar.current.startOfDay(for: date)
        let days = Calendar.current.dateComponents([.day], from: start, to: end).day ?? 0

        if days < 0 { return "Expired" }
        if days == 0 { return "Today" }
        if days == 1 { return "1 day left" }
        return "\(days) days left"
    }

}

#Preview {
    ContentView()
}
