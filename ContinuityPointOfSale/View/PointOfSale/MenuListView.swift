//
//  MenuListView.swift
//  ContinuityPointOfSale
//
//  Created by Liefran Satrio Sim on 02/09/24.
//

import SwiftUI
import SwiftData

struct MenuListView: View {
    var proxy: GeometryProxy
    @Binding var searchText : String
    @Query(sort: [SortDescriptor(\Product.name, order: .forward)]) var product: [Product]
    @EnvironmentObject var order: Order
    
    // Add a list of suppliers for filtering
        var suppliers: [String] {
            let allSuppliers = Set(product.compactMap { $0.supplier?.name }) // Extract unique supplier names
            return ["Select Supplier"] + allSuppliers.sorted() // Add "All" to the list for showing all products
        }
        
        @State private var selectedSupplier: String = "Select Supplier" // Default to "All"
    
    var filteredProduct: [Product] {
            var filtered = product
            
            // Filter by search text
            if !searchText.isEmpty {
                filtered = filtered.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
            }
            
            // Filter by supplier name
            if selectedSupplier != "Select Supplier" {
                filtered = filtered.filter { $0.supplier?.name == selectedSupplier }
            }
            
            return filtered
        }
    
    var body: some View {
            HStack {
                VStack {
                    // Display picker to select supplier
                    HStack {
                        Picker("Suppliers", selection: $selectedSupplier) {
                            ForEach(suppliers, id: \.self) { supplier in
                                Text(supplier)
                            }
                        }
                        .pickerStyle(.menu) // Use a menu-style picker for supplier selection
                        .frame(width: proxy.size.width * (800 / 1134))
                        .padding(.horizontal, 14)
                        .padding(.top, 8)
                        
                        Spacer()
                    }
                    
                    if filteredProduct.isEmpty {
                        // No data view
                        HStack(alignment: .center) {
                            Spacer()
                            VStack(alignment: .center) {
                                Spacer()
                                Text("No Product").font(.largeTitle)
                                Spacer()
                            }
                            Spacer()
                        }
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.flexible()),
                                                GridItem(.flexible()),
                                                GridItem(.flexible()),
                                                GridItem(.flexible())
                            ], content: {
                                ForEach(filteredProduct, id: \.self) { product in
                                    Button(action: {
                                        withAnimation {
                                            order.addProduct(product)
                                        }
                                    }, label: {
                                        MenuCardComponent(proxy: proxy, product: product)
                                            .padding(12)
                                    })
                                }
                            })
                        }
                    }
                }
                .background(.surface)
                .scrollContentBackground(.hidden)
                .navigationTitle("Menu List")
            }
        }
}

#Preview {
    GeometryReader{ proxy in
        MenuListView(proxy: proxy, searchText: .constant(""))
    }
}
