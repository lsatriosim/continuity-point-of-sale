//
//  CurrentOrderView.swift
//  ContinuityPointOfSale
//
//  Created by Liefran Satrio Sim on 02/09/24.
//

import SwiftUI

struct CurrentOrderView: View {
    var proxy: GeometryProxy
    @EnvironmentObject var order: Order
    var body: some View {
        VStack{
            Text("Current Order").font(.title2).bold()
            ScrollView{
                ForEach(order.items, id: \.id){ orderItem in
                    OrderItemsComponent(proxy: proxy, orderItem: orderItem)
                }
            }
            .frame(height: proxy.size.height * (900 / 1194))
            .padding(.horizontal, 12)
            Spacer()
            HStack{
                Text("Total :").font(.headline).bold()
                Spacer()
                Text("\(order.totalPrice)").font(.headline).bold()
            }
            Button(action: {}, label: {
                ZStack{
                    RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                        .fill(.accent)
                        .frame(width: proxy.size.width * 0.2, height: proxy.size.height * 0.06)
                        .overlay(
                                    RoundedRectangle(cornerSize: CGSize(width: 7, height: 7))
                                        .stroke(.red, lineWidth: 1)
                                )
                    
                    Text("Print Bill")
                        .font(.body)
                        .bold()
                        .foregroundStyle(.white)
                }
            })
        }
    }
}

#Preview {
    GeometryReader{ proxy in
        CurrentOrderView(proxy: proxy)
    }
}
