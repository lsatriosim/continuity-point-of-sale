//
//  TransactionHistoryView.swift
//  ContinuityPointOfSale
//
//  Created by Liefran Satrio Sim on 03/09/24.
//

import SwiftUI
import SwiftData

struct TransactionHistoryView: View {
    @Query(sort: [SortDescriptor(\Transaction.timeStamp, order: .reverse)]) var transactions : [Transaction]
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
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    ShareLink(item:generateCSV()) {
                                    Text("Export CSV")
                                }
                }
            }
        }
        .searchable(text: $searchKeyword, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("Search customer name..."))
        .onAppear{
            router.transactionChosen = nil
        }
    }
    
    func generateCSV() -> URL {
        var fileURL: URL!
        
        // Define the CSV heading
        let heading = "Timestamp, ID, Customer Name, Product Name, Quantity, Price, Total Price\n"
        
        // Initialize an array to hold each row of the CSV
        var rows: [String] = []
        
        // Iterate through all transactions
        for transaction in transactions {
            let customerName = transaction.customerName
            let timeStamp = transaction.timeStamp
            let orderItems = transaction.order?.items ?? []
            
            // Iterate through each order item in the transaction
            for item in orderItems {
                let productName = item.productName
                let quantity = item.quantity
                let productPrice = item.productPrice
                let totalPrice = productPrice * quantity
                
                // Create a row for each order item in the format of the CSV
                let row = "\(timeStamp), \(transaction.id),\(customerName), \(productName), \(quantity), \(productPrice), \(totalPrice)"
                rows.append(row)
            }
        }
        
        // Combine the heading with all the rows
        let stringData = heading + rows.joined(separator: "\n")
        
        do {
            // Create the path for the file in the document directory
            let path = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            
            fileURL = path.appendingPathComponent("Transaction-Data.csv")
            
            // Write the CSV data to the file
            try stringData.write(to: fileURL, atomically: true, encoding: .utf8)
            print("CSV file created at: \(fileURL!)")
            
        } catch {
            print("Error generating CSV file: \(error)")
        }
        
        return fileURL
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
