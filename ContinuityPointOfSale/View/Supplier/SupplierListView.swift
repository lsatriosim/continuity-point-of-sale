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
    @Environment(\.modelContext) private var modelContext
    
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
                                router.supplierChosen = supplier
                                addModalPresented = true
                            }, label: {
                                HStack{
                                    Text(supplier.name)
                                    Spacer()
                                    Image(systemName: "chevron.forward")
                                }
                            })
                        }
                        .onDelete(perform: delete)
                    }.foregroundStyle(.black)
                }
            }
            .background(.surface)
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
            AddSupplierModal(isPresented: $addModalPresented)
        }
        .onAppear{
            //add supplier into router if need detail
            router.supplierChosen = nil
        }
        .navigationBarBackButtonHidden()
    }
    
    func delete(_ offsets: IndexSet) {
        // delete the objects here
        for index in offsets {
            let supplier = supplierFromSwiftData[index]
            supplier.delete(context: modelContext)
        }
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
                SupplierListView()
            }
        }
    }
    return tempView()
}
