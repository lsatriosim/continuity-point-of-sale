//
//  Supplier.swift
//  ContinuityPointOfSale
//
//  Created by Liefran Satrio Sim on 30/08/24.
//

import Foundation
import SwiftData

@Model
final class Supplier {
    @Attribute(.unique) var id: UUID
    var name: String
    var revenue: Int
    
    var products = [Product]()
    @Relationship(deleteRule: .cascade, inverse: \Product.supplier)
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
        self.revenue = 0
    }
    
    func save(context: ModelContext) {
        context.insert(self)
        do {
            try context.save()
        } catch {
            print("Error saving supplier: \(error)")
        }
    }
    
    func delete(context: ModelContext) {
        context.delete(self)
        do {
            try context.save()
        } catch {
            print("Error deleting supplier: \(error)")
        }
    }
}
