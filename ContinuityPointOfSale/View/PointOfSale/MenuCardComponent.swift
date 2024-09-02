//
//  MenuCardComponent.swift
//  ContinuityPointOfSale
//
//  Created by Liefran Satrio Sim on 02/09/24.
//

import SwiftUI

struct MenuCardComponent: View {
    var proxy: GeometryProxy
    var product: Product
    var body: some View {
        ZStack{
            RoundedRectangle(cornerSize: CGSize(width: 13, height: 13)).fill(.white)
                .frame(width: proxy.size.width * 0.16, height: proxy.size.height * 0.24)
            VStack(alignment: .leading){
                if(product.image != nil){
                    Image(uiImage: UIImage(data: product.image ?? Data()) ?? UIImage()).resizable().aspectRatio(contentMode: .fill).frame(width: proxy.size.width * 0.145, height: proxy.size.height * 0.145)
                        .cornerRadius(13)
                        .padding(.horizontal, 18)
                }else{
                    Image("noProduct").resizable().aspectRatio(contentMode: .fill).frame(width: proxy.size.width * 0.145, height: proxy.size.height * 0.145)
                        .cornerRadius(13)
                        .border(Color.black)
                        .padding(.horizontal, 18)
                }
                Text("\(product.name)").font(.headline).bold()
                    .padding(.horizontal, 18).foregroundStyle(.black)
                Text("Rp \(product.price) / \(product.unit)").font(.body)
                    .padding(.horizontal, 18).foregroundStyle(.black)
            }.frame(width: proxy.size.width * 0.18, height: proxy.size.height * 0.27).padding(18)
        }.frame(width: proxy.size.width * 0.18, height: proxy.size.height * 0.24)
    }
}

#Preview {
    GeometryReader{ proxy in
        ZStack{
            Rectangle().fill(.surface).frame(width: .infinity, height: .infinity)
            MenuCardComponent(proxy: proxy, product: Product(id: UUID(), name: "Nama Makanan", price: 50000, supplier: Supplier(id: UUID(), name: "Joko"), image: nil, unit: "1 pcs"))
        }
    }
}
