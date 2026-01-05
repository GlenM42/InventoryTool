//
//  Models.swift
//  InventoryTool
//
//  Created by Hlib Myasnychenko on 1/4/26.
//

import Foundation

struct PantryItem: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var quantity: Int
    var expiresOn: Date
    var notes: String = ""
}
