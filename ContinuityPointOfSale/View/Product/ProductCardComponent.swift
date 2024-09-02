//
//  ProductCardComponent.swift
//  ContinuityPointOfSale
//
//  Created by Liefran Satrio Sim on 30/08/24.
//

import SwiftUI

struct ProductCardComponent: View {
    var product: Product
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack{
            if(product.image == nil){
                Image("noProduct")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: ((router.geometryProxy?.size.width ?? 2000) / 7), maxHeight: ((router.geometryProxy?.size.width ?? 2000) / 9))
                    .cornerRadius(10)
                    .padding(.top, 20)
            }else{
                Image(uiImage: UIImage(data: product.image ?? Data()) ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: ((router.geometryProxy?.size.width ?? 2000) / 7), maxHeight: ((router.geometryProxy?.size.width ?? 2000) / 9))
                    .background(.blue)
                    .cornerRadius(10)
                    .padding(.top, 20)
            }
            VStack(alignment: .center, spacing: 4){
                Text("\(product.name)").font(.title).bold()
                HStack{
                    Text("\(product.price)").font(.title)
                    Text("/ \(product.unit)").font(.headline)
                }
            }.foregroundStyle(.black)
            Spacer()
            
        }.frame(width: ((router.geometryProxy?.size.width ?? 2000) / 5.5), height: ((router.geometryProxy?.size.width ?? 2000) / 5))
            .background(.white)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
    }
}

struct ProductCard_Previews: PreviewProvider {
    static var previews: some View {
        // Initialize the Router as a StateObject and pass it to ContentView
        GeometryReader{proxy in
            ProductCardComponent(product: Product(id: UUID(), name: "Klepon", price: 50000, supplier: Supplier(id: UUID(), name: "Vica"), image: nil, unit: "1 pcs"))
                .environmentObject(Router())
                .offset(x: (proxy.size.width / 2) - 200, y: (proxy.size.height / 2) - 200)
        }.background(.surface)
    }
}
