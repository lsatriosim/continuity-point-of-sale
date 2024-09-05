//
//  ProductListView.swift
//  ContinuityPointOfSale
//
//  Created by Liefran Satrio Sim on 30/08/24.
//

import SwiftUI
import SwiftData

struct ProductListView: View {
    @State private var searchText: String = ""
    @Query private var productFromSwiftData: [Product]
    @State private var addModalPresented : Bool = false
    @EnvironmentObject var router: Router
    
    
    var filteredProduct: [Product] {
        if searchText.isEmpty {
            return productFromSwiftData
        } else {
            return productFromSwiftData.filter { product in
                return product.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
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
                        ScrollView{
                            LazyVGrid(columns: [GridItem(.flexible()),
                                                GridItem(.flexible()),
                                                GridItem(.flexible()),
                                                GridItem(.flexible()),
                                                GridItem(.flexible())], content: {
                                ForEach(filteredProduct, id: \.self){ product in
                                    Button(action: {
                                        //add supplier into router if need detail
                                        router.productChosen = product
                                        addModalPresented = true
                                    }, label: {
                                        ProductCardComponent(product: product)
                                    })
                                }
                            })
                        }
                    }
                }
                .background(.surface)
                .scrollContentBackground(.hidden)
                .navigationTitle("Product List")
                .searchable(
                    text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .always)
                )
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            addModalPresented = true
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .onAppear{
                    router.geometryProxy = geometry
                }
            }
        }
        .sheet(isPresented: $addModalPresented){
            //addModalView
            AddProductModal(isPresented: $addModalPresented)
        }
        .onAppear{
            //add supplier into router if need detail
            router.productChosen = nil
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Supplier.self, Product.self, configurations: config)
        
        return tempView()
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container: \(error.localizedDescription)")
    }
    
    struct tempView: View {
        var body: some View {
            NavigationStack{
                ProductListView()
                    .environmentObject(Router())
            }
        }
    }
    return tempView()
}
