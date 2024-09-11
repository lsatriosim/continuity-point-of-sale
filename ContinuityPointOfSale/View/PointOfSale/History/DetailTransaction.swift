//
//  DetailTransaction.swift
//  ContinuityPointOfSale
//
//  Created by Liefran Satrio Sim on 09/09/24.
//

import SwiftUI
import SwiftData

struct DetailTransaction: View {
    @EnvironmentObject var router: Router
    @Environment(\.modelContext) var modelContext: ModelContext
    @State private var showAlert: Bool = false

    var body: some View {
        GeometryReader{proxy in
            VStack{
                VStack(alignment: .leading, spacing: 2){
                    HStack{
                        Text("\(router.transactionChosen?.timeStamp ?? .now)").font(.title3)
                        Spacer()
                    }.padding(.horizontal, 24)
                }.frame(width: proxy.size.width)
                HStack{
                    Spacer()
                    DetailOrderHistory(proxy: proxy)
                    Spacer()
                }.frame(width: proxy.size.width)
            }
        }.navigationTitle("\(router.transactionChosen?.customerName ?? "Unknown Customer")")
            .navigationBarTitleDisplayMode(.large)
            .background(.surface)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showAlert = true
                    }) {
                        Text("Delete")
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Delete Transaction"),
                    message: Text("Are you sure you want to delete this transaction?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let transaction = router.transactionChosen {
                            transaction.delete(context: modelContext)
                            router.transactionChosen = nil
                            router.navigateBack(stackType: .pointOfSale)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
    }
}

#Preview {
    NavigationStack{
        DetailTransaction().environmentObject(Router())
    }
}
