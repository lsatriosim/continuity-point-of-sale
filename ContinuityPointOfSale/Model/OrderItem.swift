//
//  OrderItem.swift
//  ContinuityPointOfSale
//
//  Created by Liefran Satrio Sim on 02/09/24.
//

import Foundation

class OrderItem: ObservableObject, Identifiable {
    let id: UUID
    let product: Product
    @Published var quantity: Int
    
    init(id: UUID = UUID(), product: Product, quantity: Int = 1) {
        self.id = id
        self.product = product
        self.quantity = quantity
    }
}
