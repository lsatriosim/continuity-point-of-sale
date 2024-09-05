//
//  Wallet.swift
//  ContinuityPointOfSale
//
//  Created by Liefran Satrio Sim on 04/09/24.
//

import Foundation
import SwiftData

@Model
final class Wallet  {
    @Attribute(.unique) var id: UUID
    var walletName: String
    var balance: Int
    
    init(id: UUID = UUID(), walletName: String, balance: Int) {
        self.id = id
        self.walletName = walletName
        self.balance = balance
    }
    
    func totalBalance(cashFlows: [CashFlow]) -> Int {
        return cashFlows
            .filter { $0.walletName == self.walletName }
            .reduce(0) { $0 + $1.cashValue }
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
