//
//  PointOfSalePage.swift
//  ContinuityPointOfSale
//
//  Created by Liefran Satrio Sim on 01/09/24.
//

import SwiftUI

struct PointOfSaleView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var order: Order
    @State private var searchKeywords: String = ""
    var body: some View {
        GeometryReader{ proxy in
            VStack{
                ToolbarComponent(searchKeywords: $searchKeywords,proxy: proxy, resetOrder: resetOrder, openHistory: openHistory, analytics: analytics)
                    .frame(width: proxy.size.width, height: proxy.size.height * 0.06)
                HStack{
                    MenuListView(proxy: proxy, searchText: $searchKeywords)
                        .frame(width: proxy.size.width * 0.7, height: proxy.size.height * 0.94)
                    CurrentOrderView(proxy: proxy)
                        .frame(width: proxy.size.width * 0.27, height: proxy.size.height * 0.94)
                }.frame(width: proxy.size.width, height: proxy.size.height * 0.94)
                
            }.frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
    
    private func resetOrder(){
        withAnimation{
            order.clearOrder()
        }
    }
    
    private func openHistory(){
        print("Open history")
    }
    
    private func analytics(){
        print("analytics")
    }
}

struct PointOfSale_Previews: PreviewProvider {
    static var previews: some View {
        // Initialize the Router as a StateObject and pass it to ContentView
        PointOfSaleView()
            .environmentObject(Router())
    }
}
