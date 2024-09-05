//
//  Seeder.swift
//  ContinuityPointOfSale
//
//  Created by Liefran Satrio Sim on 05/09/24.
//

import Foundation
import SwiftData

struct Seeder{
    static func seedData(modelContext: ModelContext){
        //seed the supplier
        let supplierName = ["Devica", "Liefran", "Eko", "Kenji", "Sandro"]
        var supplierList = [Supplier]()
        for supplier in supplierName{
            let newSupplier = Supplier(id: UUID(), name: supplier)
            newSupplier.save(context: modelContext)
            supplierList.append(newSupplier)
        }
        
        //seed the product
        let productName = ["Bakso", "Nasi Goreng", "Klepon", "Es Krim", "Churros"]
        let productPrice = [15000, 18000, 10000, 20000, 12000]
        var productList = [Product]()
        
        for (index, name) in productName.enumerated(){
            let newProduct = Product(id: UUID(), name: name, price: productPrice[index], supplier: supplierList[index], image: nil, unit: "1 pcs")
            newProduct.save(context: modelContext)
            productList.append(newProduct)
        }
        
        //seed the wallet
        let walletName = ["Qris", "Rekening BCA", "Cash"]
        for name in walletName{
            let newWallet = Wallet(walletName: name, balance: 0)
            newWallet.save(context: modelContext)
        }
        
        //seed the transaction
        let orderItem1 = PersistentOrderItem(productName: "Bakso", productPrice: 15000, quantity: 2, supplierName: "Devica")
        let orderItem2 = PersistentOrderItem(productName: "Nasi Goreng", productPrice: 18000, quantity: 1, supplierName: "Liefran")
        let order = PersistentOrder(items: [orderItem1, orderItem2], totalPrice: 48000)
        let cashFlow1 = CashFlow(id: UUID(), walletName: "Coupon", cashValue: 30000)
        let cashFlow2 =  CashFlow(id: UUID(), walletName: "Qris", cashValue: 18000)
        
        let transaction = Transaction(id: UUID(), order: order, customerName: "John", timeStamp: .now, cashFlows: [cashFlow1, cashFlow2])
        transaction.save(context: modelContext)
    }
}
