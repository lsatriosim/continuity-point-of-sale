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
    
    var products = [Product]()
    @Relationship(deleteRule: .cascade, inverse: \Product.supplier)
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
    
    func totalRevenue(orderItems: [PersistentOrderItem]) -> Int {
        return orderItems
                .filter { $0.supplierName == self.name }
                .reduce(0) { $0 + ($1.productPrice * $1.quantity) }
        }
    
    func productSell(orderItems: [PersistentOrderItem]) -> [PersistentOrderItem]{
        return orderItems.filter{ $0.supplierName == self.name }
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
