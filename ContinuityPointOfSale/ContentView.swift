//
//  ContentView.swift
//  ContinuityPointOfSale
//
//  Created by Liefran Satrio Sim on 30/08/24.
//

import SwiftUI
import SwiftData

private enum SidebarItem: String, CaseIterable, Identifiable {
    case pointOfSale = "Point Of Sale"
    case supplier = "Supplier"
    case product = "Product"
    case bundling = "Bundling"
    
    var id: String { self.rawValue }
}

private func iconForItem(_ item: SidebarItem) -> String {
    switch item {
    case .supplier: "person.fill"
    case .product: "takeoutbag.and.cup.and.straw.fill"
    case .pointOfSale: "cart.fill"
    case .bundling: "bag.fill"
    }
}

struct ContentView: View {
    @State private var selectedSidebarItem: SidebarItem? = .pointOfSale
    @EnvironmentObject var router: Router
    
    var body: some View {
        NavigationSplitView(columnVisibility: $router.splitViewVisibility) {
            sidebar
        } detail: {
            detailView
        }.disabled(router.disableSideBar)
            .onAppear{
                router.splitViewVisibility = .detailOnly
            }
    }
    
    var sidebar: some View {
        List(SidebarItem.allCases, selection: $selectedSidebarItem) { item in
            NavigationLink(value: item) {
                Label(item.rawValue, systemImage: iconForItem(item))
            }
        }
        .onChange(of: selectedSidebarItem){oldValue, newValue in
            if oldValue == SidebarItem.supplier{
                router.navigateToRoot(stackType: .supplier)
            }else if oldValue == SidebarItem.product{
                router.navigateToRoot(stackType: .product)
            }else if oldValue == SidebarItem.pointOfSale{
                router.navigateToRoot(stackType: .pointOfSale)
            }else{
                router.navigateToRoot(stackType: .bundling)
            }
        }
        .navigationTitle("CPOS")
    }
    
    @ViewBuilder
    var detailView: some View {
        switch selectedSidebarItem {
        case .supplier:
            NavigationStack(path: $router.supplyPath){
                SupplierListView()
                    .navigationDestination(for: Router.SupplierDestination.self){ destination in
                        switch destination{
                        case .supplierList :
                            SupplierListView()
                        }
                    }
            }
        case .product:
            NavigationStack(path: $router.productPath){
                ProductListView()
                    .navigationDestination(for: Router.ProductDestination.self){ destination in
                        switch destination{
                        case .productList :
                            ProductListView()
                        }
                    }
            }
        case .pointOfSale:
            NavigationStack(path: $router.pointOfSalePath){
                PointOfSaleView()
                    .navigationDestination(for: Router.PointOfSaleDestination.self){ destination in
                        switch destination{
                        case .pointOfSale :
                            PointOfSaleView()
                        case .historicTransaction :
                            TransactionHistoryView()
                        case .analyticsTransasction :
                            AnalyticsView()
                        case .detailTransaction:
                            DetailTransaction()
                        case .supplierAnalytics:
                            SupplierAnalyticsView()
                        }
                    }
            }
            
        case .bundling:
            NavigationStack(path: $router.bundlingPath){
                Text("Bundling Page")
                    .navigationDestination(for: Router.BundlingDestination.self){ destination in
                        switch destination{
                        case .bundling :
                            Text("Bundling Page")
                        }
                    }
            }
        case .none:
            Text("None")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        // Initialize the Router as a StateObject and pass it to ContentView
        ContentView()
            .environmentObject(Router())
    }
}
