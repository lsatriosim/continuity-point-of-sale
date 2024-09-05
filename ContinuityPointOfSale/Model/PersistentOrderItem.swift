//
//  PersistentOrderItem.swift
//  ContinuityPointOfSale
//
//  Created by Liefran Satrio Sim on 03/09/24.
//

import Foundation
import SwiftData

@Model
final class PersistentOrderItem {
    @Attribute(.unique) var id: UUID
    var productName: String
    var productPrice: Int
    var quantity: Int
    
    var supplierName: String
    
    init(id: UUID = UUID(), productName: String, productPrice: Int, quantity: Int, supplierName: String) {
        self.id = id
        self.productName = productName
        self.productPrice = productPrice
        self.quantity = quantity
        self.supplierName = supplierName
    }
}
