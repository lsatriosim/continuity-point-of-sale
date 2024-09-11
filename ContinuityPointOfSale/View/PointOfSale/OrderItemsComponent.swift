//
//  OrderItemsComponent.swift
//  ContinuityPointOfSale
//
//  Created by Liefran Satrio Sim on 02/09/24.
//

import SwiftUI

struct OrderItemsComponent: View {
    var proxy: GeometryProxy
    @ObservedObject var orderItem: OrderItem
    @EnvironmentObject var order: Order
    
    var body: some View {
        HStack{
            if(orderItem.product.image == nil){
                Image("noProduct")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: proxy.size.width * (75 / 834), maxHeight: proxy.size.width * (75 / 834))
                    .cornerRadius(10)
                    .padding(20)
            }else{
                Image(uiImage: UIImage(data: orderItem.product.image ?? Data()) ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: proxy.size.width * (75 / 834), maxHeight: proxy.size.width * (75 / 834))
                    .background(.blue)
                    .cornerRadius(10)
                    .padding(20)
            }
            VStack(alignment: .leading, spacing: 4){
                Text("\(orderItem.product.name)").font(.headline).truncationMode(.tail)
                Text("Rp \(orderItem.product.price * orderItem.quantity)").font(.title3)
                HStack{
                    Spacer()
                    Button(action: {
                        withAnimation{
                            order.subtractProduct(orderItem.product)
                        }
                    }, label: {
                        Image(systemName: "minus.circle").resizable().frame(width: 36,height: 36).foregroundStyle(.red)
                    })
                    Text("\(orderItem.quantity)").font(.title)
                    Button(action: {
                        withAnimation{
                            order.addProduct(orderItem.product)
                        }
                    }, label: {
                        Image(systemName: "plus.circle").resizable().frame(width: 36,height: 36).foregroundStyle(.green)
                    })
                }
            }.foregroundStyle(.black)
            Spacer()
        }.frame(width: proxy.size.width * (230 / 834), height: proxy.size.height * (160 / 1194))
            .background(.surface)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
            .padding(.horizontal, 12)
    }
}

#Preview {
    GeometryReader{ proxy in
        OrderItemsComponent(proxy: proxy, orderItem: OrderItem(product: Product(id: UUID(), name: "Klepon", price: 50000, supplier: Supplier(id: UUID(), name: "Vica"), image: nil, unit: "1 pcs"), quantity: 1))
            .offset(x: (proxy.size.width / 2) - 200, y: (proxy.size.height / 2) - 200)
    }.background(.surface)
}
