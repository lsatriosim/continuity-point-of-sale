//
//  Transaction.swift
//  ContinuityPointOfSale
//
//  Created by Liefran Satrio Sim on 03/09/24.
//

import Foundation
import SwiftData

@Model
final class Transaction {
    @Attribute(.unique) var id: UUID
    
    @Relationship(deleteRule: .cascade, inverse: nil)
    var order: PersistentOrder?
    var customerName: String
    
    
    var timeStamp: Date
    @Relationship(deleteRule: .cascade, inverse: nil)
    var cashFlows: [CashFlow]
    
    init(id: UUID, order: PersistentOrder? = nil, customerName: String, timeStamp: Date? = Date.now, cashFlows: [CashFlow] = [CashFlow]()) {
        self.id = id
        self.order = order
        self.customerName = customerName
        self.timeStamp = timeStamp ?? .now
        self.cashFlows = cashFlows
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
