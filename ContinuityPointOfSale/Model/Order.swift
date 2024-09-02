//
//  Order.swift
//  ContinuityPointOfSale
//
//  Created by Liefran Satrio Sim on 02/09/24.
//

import Foundation

class Order: ObservableObject {
    @Published var items: [OrderItem] = []
    
    @Published var totalPrice : Int = 0
    
    // Add a product to the order or increment its quantity
    func addProduct(_ product: Product) {
        if let existingItem = items.first(where: { $0.product.id == product.id }) {
            existingItem.quantity += 1
        } else {
            let newItem = OrderItem(product: product)
            items.append(newItem)
        }
        totalPrice += product.price
    }
    
    // Subtract the quantity of a product in the order, and remove it if the quantity reaches 0
    func subtractProduct(_ product: Product) {
        if let existingItem = items.first(where: { $0.product.id == product.id }) {
            existingItem.quantity -= 1
            if existingItem.quantity <= 0 {
                removeItem(existingItem)
            }
        }
        totalPrice -= product.price
    }
    
    // Remove an item from the order
    private func removeItem(_ orderItem: OrderItem) {
        if let index = items.firstIndex(where: { $0.id == orderItem.id }) {
            items.remove(at: index)
        }
    }
    
    // Clear the entire order
    func clearOrder() {
        items.removeAll()
        totalPrice = 0
    }
}
