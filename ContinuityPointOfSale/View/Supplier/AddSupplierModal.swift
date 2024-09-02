//
//  AddSupplierModal.swift
//  ContinuityPointOfSale
//
//  Created by Liefran Satrio Sim on 30/08/24.
//

import SwiftUI

struct AddSupplierModal: View {
    @State private var supplierName : String = ""
    @Binding var isPresented: Bool
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var router: Router
    
    var body: some View {
        NavigationStack{
            Form{
                VStack(alignment: .leading){
                    HStack{
                        Text("Supplier Name")
                        TextField("Supplier Name", text: $supplierName)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal, 12)
                    }
                }.padding(.horizontal, 24)
            }
            .formStyle(.columns)
            .navigationTitle("Add Supplier")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        saveData()
                        isPresented = false
                        router.supplierChosen = nil
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                        router.supplierChosen = nil
                    }
                }
            }
        }
        .onAppear{
            supplierName = router.supplierChosen?.name ?? ""
        }
    }
    
    private func saveData(){
        if(router.supplierChosen == nil){
            let supplier = Supplier(id: UUID(), name: supplierName)
            supplier.save(context: modelContext)
        }else{
            router.supplierChosen?.name = supplierName
            router.supplierChosen?.save(context: modelContext)
        }
    }
}

struct AddSupplierModal_Previews: PreviewProvider {
    static var previews: some View {
        // Initialize the Router as a StateObject and pass it to ContentView
        AddSupplierModal(isPresented: .constant(true))
            .environmentObject(Router())
    }
}
