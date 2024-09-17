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
    var categories : [String] = ["All", "Food", "Desert", "Snack", "Beverages"]
    @State private var selectedCategory : String = "All"
    @EnvironmentObject var order: Order
    
    var filteredProduct: [Product] {
        if searchText.isEmpty {
            return product
        } else {
            return product.filter { product in
                return product.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        HStack{
            VStack {
                if filteredProduct.isEmpty{
                    //no data view
                    HStack(alignment: .center){
                        Spacer()
                        VStack(alignment: .center){
                            Spacer()
                            Text("No Product").font(.largeTitle)
                            Spacer()
                        }
                        Spacer()
                    }
                }else{
//                    HStack{
//                        Picker("Categories", selection: $selectedCategory){
//                                            ForEach(categories, id: \.self) { category in
//                                                Text(category)
//                                            }
//                                        }
//                        .pickerStyle(.segmented)
//                        .frame(width: proxy.size.width * (356/834))
//                        .padding(.horizontal,14)
//                        .padding(.top, 8)
//                        
//                        Spacer()
//                    }
                    
                    ScrollView{
                        LazyVGrid(columns: [GridItem(.flexible()),
                                            GridItem(.flexible()),
                                            GridItem(.flexible()),
                                            GridItem(.flexible())
                                            ], content: {
                            ForEach(filteredProduct, id: \.self){ product in
                                Button(action: {
                                    withAnimation{
                                        order.addProduct(product)
                                    }
                                }, label: {
                                    MenuCardComponent(proxy: proxy, product: product).padding(12)
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
