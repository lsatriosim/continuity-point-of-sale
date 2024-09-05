//
//  CashFlow.swift
//  ContinuityPointOfSale
//
//  Created by Liefran Satrio Sim on 04/09/24.
//

import Foundation
import SwiftData

@Model
final class CashFlow {
    @Attribute(.unique) var id: UUID
    var walletName: String
    var cashValue: Int
    
    init(id: UUID, walletName: String, cashValue: Int) {
        self.id = id
        self.walletName = walletName
        self.cashValue = cashValue
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
