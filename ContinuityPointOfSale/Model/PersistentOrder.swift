//
//  PersistentOrder.swift
//  ContinuityPointOfSale
//
//  Created by Liefran Satrio Sim on 03/09/24.
//

import Foundation
import SwiftData

@Model
final class PersistentOrder {
    @Attribute(.unique) var id: UUID
    
    @Relationship(deleteRule: .cascade, inverse: nil)
    var items: [PersistentOrderItem]
    
    var totalPrice: Int

    init(id: UUID = UUID(), items: [PersistentOrderItem] = [], totalPrice: Int) {
        self.id = id
        self.items = items
        self.totalPrice = totalPrice
    }
}
