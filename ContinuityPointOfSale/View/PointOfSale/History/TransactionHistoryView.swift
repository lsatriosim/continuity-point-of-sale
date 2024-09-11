//
//  TransactionHistoryView.swift
//  ContinuityPointOfSale
//
//  Created by Liefran Satrio Sim on 03/09/24.
//

import SwiftUI
import SwiftData

struct TransactionHistoryView: View {
    @Query var transactions : [Transaction]
    @EnvironmentObject var router: Router
    @Environment(\.modelContext) var modelContext: ModelContext
    @State var searchKeyword: String = ""
    
    var filteredTransactions: [Transaction] {
        if searchKeyword.isEmpty {
            return transactions
        } else {
            return transactions.filter { transaction in
                return transaction.customerName.localizedCaseInsensitiveContains(searchKeyword)
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                if transactions.isEmpty{
                    //no data view
                    HStack(alignment: .center){
                        Spacer()
                        VStack(alignment: .center){
                            Spacer()
                            Text("No Transactions").font(.largeTitle)
                            Spacer()
                        }
                        Spacer()
                    }
                }else{
                    List{
                        ForEach(filteredTransactions, id: \.self){ transaction in
                            Button(action: {
                                router.transactionChosen = transaction
                                router.navigate(to: .detailTransaction)
                            }, label: {
                                HStack(alignment: .center){
                                    VStack(alignment: .leading){
                                        Text(transaction.timeStamp, format: .dateTime.hour().minute().day().month().year())
                                            .font(.headline)
                                        Text("\(transaction.customerName)")
                                        Text("\(transaction.order?.items.count ?? 0) items - Rp \(transaction.order?.totalPrice ?? 0)").font(.title3).bold()
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.forward")
                                }
                            })
                        }
                    }.foregroundStyle(.black)
                }
            }
            .background(.surface)
            .scrollContentBackground(.hidden)
            .navigationTitle("Transaction History")
        }
        .searchable(text: $searchKeyword, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("Search customer name..."))
        .onAppear{
            router.transactionChosen = nil
        }
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
            TransactionHistoryView()
                .environmentObject(Router())
                .environmentObject(Order())
                .task {
                    Seeder.seedData(modelContext: modelContext)
                }
        }
    }
    
    return tempView()
}
