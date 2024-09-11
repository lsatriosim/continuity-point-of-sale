//
//  SupplierAnalyticsView.swift
//  ContinuityPointOfSale
//
//  Created by Liefran Satrio Sim on 10/09/24.
//

import SwiftUI
import SwiftData

struct SupplierAnalyticsView: View {
    @Query var orderItems: [PersistentOrderItem]
    @EnvironmentObject var router: Router
    @Query private var transactions: [Transaction]
    @State private var groupedItems: [GroupedOrderItem] = []
    
    var body: some View {
        GeometryReader{proxy in
            VStack{
                HStack{
                    Spacer()
                    ZStack{
                        RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)).fill(.white)
                            .frame(width: proxy.size.width * (1146 / 1194), height: proxy.size.height * (750 / 834) )
                        VStack{
                            VStack(alignment: .leading){
                                Text("\(router.supplierAnalyticsChosen?.productSell(orderItems: orderItems).count ?? 0) Items").font(.title3).bold()
                                Rectangle()
                                    .frame(height: 1) // Set the height to 1 for a thin line
                                    .foregroundColor(.black) // Set the color to black
                                HStack{
                                    Text("Item Name").font(.headline).bold().frame(width: proxy.frame(in: .named("container")).size.width * 0.225, alignment: .leading)
                                    Spacer()
                                    Text("Quantity").font(.headline).bold().frame(width: proxy.frame(in: .named("container")).size.width * 0.225, alignment: .leading)
                                    Spacer()
                                    Text("Price").font(.headline).bold().frame(width: proxy.frame(in: .named("container")).size.width * 0.225, alignment: .leading)
                                    Spacer()
                                    Text("Total Price").font(.headline).bold().frame(width: proxy.frame(in: .named("container")).size.width * 0.225, alignment: .leading)
                                }
                                Rectangle()
                                    .frame(height: 1) // Set the height to 1 for a thin line
                                    .foregroundColor(.black) // Set the color to black
                                ForEach(groupedItems){ item in
                                    HStack {
                                        Text("\(item.productName)")
                                            .font(.headline)
                                            .frame(width: proxy.frame(in: .named("container")).size.width * 0.225, alignment: .leading)
                                        Spacer()
                                        Text("\(item.totalQuantity)")
                                            .font(.headline)
                                            .frame(width: proxy.frame(in: .named("container")).size.width * 0.225, alignment: .leading)
                                        Spacer()
                                        Text("\(item.productPrice)")
                                            .font(.headline)
                                            .frame(width: proxy.frame(in: .named("container")).size.width * 0.225, alignment: .leading)
                                        Spacer()
                                        Text("\(item.totalPrice)")
                                            .font(.headline)
                                            .frame(width: proxy.frame(in: .named("container")).size.width * 0.225, alignment: .leading)
                                    }
                                }
                                Spacer()
                            }.frame(height: proxy.size.height * (500 / 834)).padding(.horizontal, 24).padding(.top, 24)
                            VStack(alignment: .leading){
                                Rectangle()
                                    .frame(height: 1) // Set the height to 1 for a thin line
                                    .foregroundColor(.black) // Set the color to black
                                Spacer()
                                HStack(alignment: .center){
                                    //                                    VStack(alignment: .leading){
                                    //                                        Spacer()
                                    //                                        ForEach(router.transactionChosen?.cashFlows ?? [CashFlow](), id: \.id){(cashFlow: CashFlow) in
                                    //                                            if(cashFlow.walletName == "coupon"){
                                    //                                                Text("\(cashFlow.walletName) - \(cashFlow.cashValue / 3000) -\(cashFlow.cashValue)")
                                    //                                            }else{
                                    //                                                Text("\(cashFlow.walletName) - \(cashFlow.cashValue)")
                                    //                                            }
                                    //                                        }
                                    //                                        Spacer()
                                    //                                    }
                                    Spacer()
                                    VStack(alignment: .trailing){
                                        Text("\(router.supplierAnalyticsChosen?.totalRevenue(orderItems: orderItems) ?? 0)").font(.title).bold()
                                    }.frame(height: proxy.size.height * (190 / 834))
                                }.frame(width: proxy.size.width * (1098 / 1194))
                            }.frame(height: proxy.size.height * (190 / 834)).padding(.horizontal, 24).padding(.bottom, 24)
                        }.frame(width: proxy.size.width * (1146 / 1194), height: proxy.size.height * (750 / 834) )
                    }.frame(width: proxy.size.width * (1146 / 1194), height: proxy.size.height * (750 / 834)).coordinateSpace(name: "container")
                    Spacer()
                }.frame(width: proxy.size.width)
            }
        }.navigationTitle("\(router.supplierAnalyticsChosen?.name ?? "Unknown Customer")")
            .navigationBarTitleDisplayMode(.large)
            .background(.surface)
            .onDisappear{
                router.supplierAnalyticsChosen = nil
            }
            .onAppear{
                loadOrderItems()
            }
    }
    
    // Group and Sum the Order Items by Product Name
    private func loadOrderItems() {
        // Extract all PersistentOrderItems from transactions
        let allOrderItems = transactions.compactMap { $0.order?.items }.flatMap { $0 }
        print("allOrderItems: \(allOrderItems)")
        
        for orderItem in allOrderItems{
            print(orderItem.supplierName)
        }
        
        // Filter the items based on supplier name
        let supplierItems = allOrderItems.filter { $0.supplierName == (router.supplierAnalyticsChosen?.name ?? "") }
        print("SupplierItems: \(supplierItems)")
        
        // Group the items by both product name and product price (making sure to use Hashable types)
        let grouped = Dictionary(grouping: supplierItems, by: { ProductKey(productName: $0.productName, productPrice: $0.productPrice) })
            
            // Transform the grouped dictionary into an array of GroupedOrderItem
        // Transform the grouped dictionary into an array of GroupedOrderItem
           groupedItems = grouped.map { (key, items) in
               let totalQuantity = items.reduce(0) { $0 + $1.quantity }
               let totalPrice = totalQuantity * key.productPrice
               return GroupedOrderItem(productName: key.productName, totalQuantity: totalQuantity, productPrice: key.productPrice, totalPrice: totalPrice)
           }
    }
}

struct ProductKey: Hashable {
    let productName: String
    let productPrice: Int
}

// Helper Struct for Grouped Items
struct GroupedOrderItem : Identifiable {
    var id: String { "\(productName)-\(productPrice)" }
    let productName: String
    let totalQuantity: Int
    let productPrice: Int
    let totalPrice: Int
}

#Preview {
    SupplierAnalyticsView()
}
