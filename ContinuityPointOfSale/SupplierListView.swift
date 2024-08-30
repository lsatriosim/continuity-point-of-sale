//
//  SupplierListView.swift
//  ContinuityPointOfSale
//
//  Created by Liefran Satrio Sim on 30/08/24.
//

import SwiftUI
import SwiftData

struct SupplierListView: View {
    @State private var searchText: String = ""
    @Query private var supplierFromSwiftData: [Supplier]
    @State private var addModalPresented : Bool = false
    @EnvironmentObject var router: Router
    
    var filteredSupplier: [Supplier] {
        if searchText.isEmpty {
            return supplierFromSwiftData
        } else {
            return supplierFromSwiftData.filter { supplier in
                return supplier.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                if filteredSupplier.isEmpty{
                    //no data view
                    HStack(alignment: .center){
                        Spacer()
                        VStack(alignment: .center){
                            Spacer()
                            Text("No Supplier").font(.largeTitle)
                            Spacer()
                        }
                        Spacer()
                    }
                }else{
                    List{
                        ForEach(filteredSupplier, id: \.self){ supplier in
                            Button(action: {
                                //add supplier into router if need detail
                            }, label: {
                                HStack{
                                    Text(supplier.name)
                                    Spacer()
                                    Image(systemName: "chevron.forward")
                                }
                            })
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Supplier List")
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
        }
        .sheet(isPresented: $addModalPresented){
            //addModalView
        }
        .onAppear{
            //add supplier into router if need detail
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    NavigationStack{
        SupplierListView()
    }
}
