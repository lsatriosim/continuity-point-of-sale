//
//  ContinuityPointOfSaleApp.swift
//  ContinuityPointOfSale
//
//  Created by Liefran Satrio Sim on 30/08/24.
//

import SwiftUI
import SwiftData

@main
struct ContinuityPointOfSaleApp: App {
    @StateObject var router: Router = Router()
    @StateObject var order: Order = Order()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Supplier.self,
            Product.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environmentObject(router)
        .environmentObject(order)
        .modelContainer(sharedModelContainer)
    }
}
