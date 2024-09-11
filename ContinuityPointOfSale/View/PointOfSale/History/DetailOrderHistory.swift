//
//  DetailOrderHistory.swift
//  ContinuityPointOfSale
//
//  Created by Liefran Satrio Sim on 09/09/24.
//

import Foundation
import SwiftUI

struct DetailOrderHistory: View{
    var proxy: GeometryProxy
    @EnvironmentObject var router: Router
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)).fill(.white)
                .frame(width: proxy.size.width * (1146 / 1194), height: proxy.size.height * (750 / 834) )
            VStack{
                VStack(alignment: .leading){
                    Text("\(router.transactionChosen?.order?.items.count ?? 0) Items").font(.title3).bold()
                    Rectangle()
                        .frame(height: 1) // Set the height to 1 for a thin line
                        .foregroundColor(.black) // Set the color to black
                    HStack{
                        Text("Name").font(.headline).bold().frame(width: proxy.frame(in: .named("container")).size.width * 0.225, alignment: .leading)
                        Spacer()
                        Text("Quantity").font(.headline).bold().frame(width: proxy.frame(in: .named("container")).size.width * 0.225, alignment: .leading)
                        Spacer()
                        Text("Price").font(.headline).bold().frame(width: proxy.frame(in: .named("container")).size.width * 0.225, alignment: .leading)
                        Spacer()
                        Text("Total Price").font(.headline).bold().frame(width: proxy.frame(in: .named("container")).size.width * 0.225, alignment: .leading)
                    }
                    Rectangle()
                        .frame(height: 1) // Set the height to 1 for a thin line
                        .foregroundColor(.black) // Set the color to black
                    ForEach(router.transactionChosen?.order?.items ?? [PersistentOrderItem](), id: \.id){ (item: PersistentOrderItem) in
                        HStack{
                            Text("\(item.productName)").font(.headline).frame(width: proxy.frame(in: .named("container")).size.width * 0.225, alignment: .leading)
                            Spacer()
                            Text("\(item.quantity)").font(.headline).frame(width: proxy.frame(in: .named("container")).size.width * 0.225, alignment: .leading)
                            Spacer()
                            Text("\(item.productPrice)").font(.headline).frame(width: proxy.frame(in: .named("container")).size.width * 0.225, alignment: .leading)
                            Spacer()
                            Text("\(item.productPrice * item.quantity)").font(.headline).frame(width: proxy.frame(in: .named("container")).size.width * 0.225, alignment: .leading)
                        }
                    }
                    Spacer()
                }.frame(height: proxy.size.height * (500 / 834)).padding(.horizontal, 24).padding(.top, 24)
                VStack(alignment: .leading){
                    Rectangle()
                        .frame(height: 1) // Set the height to 1 for a thin line
                        .foregroundColor(.black) // Set the color to black
                    Spacer()
                    HStack(alignment: .center){
                        VStack(alignment: .leading){
                            Spacer()
                            ForEach(router.transactionChosen?.cashFlows ?? [CashFlow](), id: \.id){(cashFlow: CashFlow) in
                                if(cashFlow.walletName == "coupon"){
                                    Text("\(cashFlow.walletName) - \(cashFlow.cashValue / 3000) -\(cashFlow.cashValue)")
                                }else{
                                    Text("\(cashFlow.walletName) - \(cashFlow.cashValue)")
                                }
                            }
                            Spacer()
                        }
                        Spacer()
                        VStack(alignment: .trailing){
                            Text("\(router.transactionChosen?.order?.totalPrice ?? 0)").font(.title).bold()
                        }.frame(height: proxy.size.height * (190 / 834))
                    }.frame(width: proxy.size.width * (1098 / 1194))
                }.frame(height: proxy.size.height * (190 / 834)).padding(.horizontal, 24).padding(.bottom, 24)
            }.frame(width: proxy.size.width * (1146 / 1194), height: proxy.size.height * (750 / 834) )
        }.frame(width: proxy.size.width * (1146 / 1194), height: proxy.size.height * (750 / 834)).coordinateSpace(name: "container")
    }
}
