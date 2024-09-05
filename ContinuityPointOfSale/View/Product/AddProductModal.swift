//
//  AddProductModal.swift
//  ContinuityPointOfSale
//
//  Created by Liefran Satrio Sim on 30/08/24.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddProductModal: View {
    @State private var productName : String = ""
    @State private var productPrice : String = ""
    @Binding var isPresented: Bool
    @State private var selectedSupplier : Supplier = Supplier(id: UUID(), name: "None")
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var router: Router
    @Query var supplierFromSwiftData: [Supplier]
    @State private var selectedImage: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var unit: String = "1 pcs"
    
    var body: some View {
        NavigationStack{
            Form{
                VStack(alignment: .leading){
                    HStack{
                        Text("Product Name")
                        TextField("Product Name", text: $productName)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal, 12)
                    }
                    Picker("Supplier", selection: $selectedSupplier) {
                        Text("None").tag(Supplier(id: UUID(), name: "None")) // Default "None" option
                        ForEach(supplierFromSwiftData, id: \.self) { supplier in
                            Text(supplier.name)
                        }
                    }
                    HStack{
                        Text("Price")
                        TextField("Enter Price", text: $productPrice)
                            .keyboardType(.numberPad) // Show number pad keyboard
                            .onChange(of: productPrice) { oldValue, newValue in
                                // Remove non-digit characters
                                productPrice = StringFormatter.formatToRupiah(input: newValue)
                            }
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal, 12)
                    }
                    HStack{
                        Text("Unit")
                        TextField("Unit", text: $unit)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal, 12)
                    }
                    Section{
                        Text("Product's Photo")
                        if(selectedImageData != nil){
                            if let selectedImageData,
                               let uiImage = UIImage(data: selectedImageData){
                                HStack{
                                    Spacer()
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: 300, maxHeight: 300)
                                        .cornerRadius(20)
                                    Spacer()
                                }
                            }
                            HStack{
                                Spacer()
                                Button(role: .destructive){
                                    withAnimation{
                                        selectedImage = nil
                                        selectedImageData = nil
                                    }
                                }label: {
                                    Label("Remove Image", systemImage: "xmark").foregroundStyle(.red)
                                }
                                Spacer()
                            }
                        }else{
                            PhotosPicker(selection: $selectedImage, matching: .images, photoLibrary: .shared()){
                                Label("Add Image", systemImage: "photo")
                            }.padding(.top, 24)
                        }
                    }
                }.padding(.horizontal, 24)
            }
            .formStyle(.columns)
            .navigationTitle("Add Product")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if(router.productChosen != nil){
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Delete") {
                            deleteData()
                            isPresented = false
                            router.productChosen = nil
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        saveData()
                        isPresented = false
                        router.productChosen = nil
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                        router.productChosen = nil
                    }
                }
            }
        }
        .onAppear{
            productName = router.productChosen?.name ?? ""
            if(router.productChosen != nil){
                selectedSupplier = router.productChosen?.supplier ?? Supplier(id: UUID(), name: "None")
            }else{
                selectedSupplier = Supplier(id: UUID(), name: "None")
            }
            productPrice = String(router.productChosen?.price ?? 0)
            selectedImageData = router.productChosen?.image ?? nil
            unit = router.productChosen?.unit ?? "1 pcs"
        }
        .task(id: selectedImage){
            if let data = try? await selectedImage?.loadTransferable(type: Data.self){
                selectedImageData = data
            }
        }
    }
    
    private func saveData(){
        if(router.productChosen == nil){
            let rawPriceString = productPrice
                        .replacingOccurrences(of: "Rp", with: "")
                        .replacingOccurrences(of: ".", with: "")
                        .replacingOccurrences(of: " ", with: "")
            
            let formattedPrice = Int(rawPriceString) ?? 0
            
            let newProduct = Product(id: UUID(), name: productName, price: formattedPrice, supplier: selectedSupplier, image: selectedImageData, unit: unit)
        }else{
            router.productChosen?.name = productName
            let rawPriceString = productPrice
                        .replacingOccurrences(of: "Rp", with: "")
                        .replacingOccurrences(of: ".", with: "")
                        .replacingOccurrences(of: " ", with: "")
            
            let formattedPrice = Int(rawPriceString) ?? 0
            router.productChosen?.price = formattedPrice
            router.productChosen?.supplier = selectedSupplier
            router.productChosen?.image = selectedImageData
            router.productChosen?.unit = unit
            router.productChosen?.save(context: modelContext)
        }
    }
    
    private func deleteData(){
        if(router.productChosen != nil){
            router.productChosen?.delete(context: modelContext)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Supplier.self, Product.self, configurations: config)
        
        let supplier1 = Supplier(
            id: UUID(),
            name: "Tavi Bulat"
        )
        
        let supplier2 = Supplier(
            id: UUID(),
            name: "Tavi Tidak Bulat "
        )
        
        container.mainContext.insert(supplier1)
        container.mainContext.insert(supplier2)
        
        return tempView()
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container: \(error.localizedDescription)")
    }
    
    struct tempView: View {
        @State private var isPresented = true
        
        var body: some View {
            NavigationStack {
                VStack {
                    Button("Toggle") {
                        isPresented.toggle()
                    }
                }
                .sheet(isPresented: $isPresented, content: {
                    AddProductModal(isPresented: $isPresented)
                        .environmentObject(Router())
                })
            }
        }
    }
    return tempView()
}
