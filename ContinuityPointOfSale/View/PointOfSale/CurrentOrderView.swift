//
//  CurrentOrderView.swift
//  ContinuityPointOfSale
//
//  Created by Liefran Satrio Sim on 02/09/24.
//

import SwiftUI
import SwiftData

struct CurrentOrderView: View {
    var proxy: GeometryProxy
    @EnvironmentObject var order: Order
    @Environment(\.modelContext) var modelContext: ModelContext
    var payBill : () -> Void
    
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
            Button(action: payBill, label: {
                Text("Pay Bill")
                    .frame(width: proxy.size.width * 0.2, height: proxy.size.height * 0.06)
                    .foregroundColor(.white)
                    .background(order.items.count == 0 ? .gray : .accent)
                    .font(.body)
                    .bold()
                    .cornerRadius(12)
                    .padding()
            })
            .disabled(order.items.count == 0)
        }
    }
}

#Preview {
    GeometryReader{ proxy in
        CurrentOrderView(proxy: proxy, payBill: {})
    }
}
