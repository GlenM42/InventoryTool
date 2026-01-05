//
//  PantryStore.swift
//  InventoryTool
//
//  Created by Hlib Myasnychenko on 1/4/26.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class PantryStore: ObservableObject {
    @Published var items: [PantryItem] = []
    
    private var cancellables = Set<AnyCancellable>() // What is this?
    
    init() {
        // Load existing data from disk
        do {
            items = try loadItems()
            items.sort { $0.expiresOn < $1.expiresOn }
        } catch {
            // First run or corrupted file: start empty (or with sample data if you want)
            items = []
            print("Load failed:", error)
        }

        // Auto-save whenever items change (debounced to avoid excessive writes)
        $items
            .dropFirst()
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] newItems in
                guard let self else { return }
                do {
                    try self.saveItems(newItems)
                } catch {
                    print("Save failed:", error)
                }
            }
            .store(in: &cancellables)
    }

    func addItem(_ item: PantryItem) {
        items.append(item)
        items.sort { $0.expiresOn < $1.expiresOn }
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
}

// MARK: - Disk Persistence
private extension PantryStore {
    var fileURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent("pantry_items.json")
    }

    func loadItems() throws -> [PantryItem] {
        let data = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([PantryItem].self, from: data)
    }

    func saveItems(_ items: [PantryItem]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601

        let data = try encoder.encode(items)
        try data.write(to: fileURL, options: [.atomic])
    }
}

