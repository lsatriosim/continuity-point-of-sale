//
//  AnalyticsView.swift
//  ContinuityPointOfSale
//
//  Created by Liefran Satrio Sim on 03/09/24.
//

import SwiftUI
import SwiftData

struct AnalyticsView: View {
    @Query var suppliers: [Supplier]
    @Query var orderItems: [PersistentOrderItem]
    @Query var wallets: [Wallet]
    @Query var cashFlows: [CashFlow]
    @EnvironmentObject var router: Router

    var body: some View {
        VStack{
            VStack{
                HStack{
                    Text("Supplier").font(.title).bold()
                    Spacer()
                }
                List{
                    ForEach(suppliers, id: \.id){ supplier in
                        Button(action: {
                            router.supplierAnalyticsChosen = supplier
                            router.navigate(to: .supplierAnalytics)
                        }){
                            HStack{
                                Text(supplier.name)
                                Spacer()
                                Text("\(supplier.totalRevenue(orderItems: orderItems))")
                            }
                        }
                    }
                }.listStyle(.plain)
            }.padding()
            
            VStack{
                HStack{
                    Text("Wallet Balance").font(.title).bold()
                    Spacer()
                }.padding()
                List{
                    ForEach(wallets, id: \.id){ wallet in
                        HStack{
                            Text(wallet.walletName)
                            Spacer()
                            Text("\(wallet.totalBalance(cashFlows: cashFlows))")
                        }
                    }
                }.listStyle(.plain)
            }.padding()
        }.background(.surface)
    }
}

#Preview{
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Supplier.self,
                                           Product.self,
                                           Transaction.self,
                                           PersistentOrder.self,
                                           PersistentOrderItem.self,
                                           Wallet.self
                                           , configurations: config)
        
        return tempView()
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container: \(error.localizedDescription)")
    }
    
    struct tempView: View{
        @Environment(\.modelContext) var modelContext: ModelContext
        
        var body: some View{
            NavigationStack{
                AnalyticsView()
                    .environmentObject(Router())
                    .environmentObject(Order())
                    .task {
                        Seeder.seedData(modelContext: modelContext)
                    }
            }
        }
    }
    
    return tempView()
}
