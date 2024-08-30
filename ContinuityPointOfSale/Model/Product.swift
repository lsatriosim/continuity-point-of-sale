//
//  Product.swift
//  ContinuityPointOfSale
//
//  Created by Liefran Satrio Sim on 30/08/24.
//

import Foundation
import SwiftData

@Model
final class Product {
    @Attribute(.unique) var id: UUID
    var name: String
    var price: Int
    
    var supplier: Supplier?
    
    init(id: UUID, name: String, price: Int, supplier: Supplier?) {
        self.id = id
        self.name = name
        self.price = price
        
        if let supplier = supplier{
            self.supplier = supplier
        }
    }
    
    func save(context: ModelContext) {
        context.insert(self)
        do {
            try context.save()
        } catch {
            print("Error saving product: \(error)")
        }
    }
    
    func delete(context: ModelContext) {
        context.delete(self)
        do {
            try context.save()
        } catch {
            print("Error deleting product: \(error)")
        }
    }
}
