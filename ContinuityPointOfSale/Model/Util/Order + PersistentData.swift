//
//  Order + PersistentData.swift
//  ContinuityPointOfSale
//
//  Created by Liefran Satrio Sim on 03/09/24.
//

import Foundation

extension Order{
    func toPersistentOrder() -> PersistentOrder {
            let persistentItems = items.map { orderItem in
                PersistentOrderItem(
                    productName: orderItem.product.name,
                    productPrice: orderItem.product.price,
                    quantity: orderItem.quantity,
                    supplierName: orderItem.product.supplier?.name ?? "Unknown"
                )
            }
            return PersistentOrder(id: UUID(), items: persistentItems, totalPrice: self.totalPrice)
        }
}
