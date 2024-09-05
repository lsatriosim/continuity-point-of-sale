//
//  PointOfSalePage.swift
//  ContinuityPointOfSale
//
//  Created by Liefran Satrio Sim on 01/09/24.
//

import SwiftUI
import SwiftData

struct PointOfSaleView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var order: Order
    @State private var searchKeywords: String = ""
    @State private var showPayBillModal: Bool = false
    @State private var customerName: String = ""
    @State private var selectedWallet : String = "None"
    @State private var showAddWalletModal : Bool = false
    @Query var walletOption : [Wallet]
    @State private var walletName: String = ""
    @Environment(\.modelContext) var modelContext: ModelContext
    @State private var cashFlows = [CashFlow]()
    @State private var undistributedBalance: Int = 0
    @State private var couponAmount:Int = 0
    @State private var useCoupon: Bool = false
    
    @State private var firstWalletName: String = "None"
    @State private var secondWalletName: String = "None"
    @State private var firstWalletBalance: Int = 0
    @State private var secondWalletBalance: Int = 0
    
    var body: some View {
        GeometryReader{ proxy in
            VStack{
                ToolbarComponent(searchKeywords: $searchKeywords,proxy: proxy, resetOrder: resetOrder, openHistory: openHistory, analytics: analytics)
                    .frame(width: proxy.size.width, height: proxy.size.height * 0.06)
                HStack{
                    MenuListView(proxy: proxy, searchText: $searchKeywords)
                        .frame(width: proxy.size.width * 0.7, height: proxy.size.height * 0.94)
                    CurrentOrderView(proxy: proxy, payBill: {
                        showPayBillModal = true
                    })
                    .frame(width: proxy.size.width * 0.27, height: proxy.size.height * 0.94)
                }.frame(width: proxy.size.width, height: proxy.size.height * 0.94)
                
            }.frame(width: proxy.size.width, height: proxy.size.height)
        }.sheet(isPresented: $showPayBillModal){
            NavigationStack{
                Form{
                    VStack(alignment: .leading){
                        HStack{
                            Text("Customer Name")
                            TextField("Customer Name", text: $customerName)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal, 12)
                        }
                        Text("Total Balanced: Rp \(order.totalPrice)")
                        
                        Toggle("Use Coupon? ", isOn: $useCoupon)
                         
                        Text("Payment Method")
                        if(useCoupon){
                            HStack(alignment: .center){
                                Image("coupon").resizable().frame(width: 80, height: 80).aspectRatio(contentMode: .fill)
                                Stepper("", value: $couponAmount, in: 0...100)
                                    .onChange(of: couponAmount){oldValue, newValue in
                                        cashFlows.first?.cashValue = newValue * 30000
                                        updateUndistributedBalance()
                                    }
                                Text("\(couponAmount)").font(.headline).padding()
                                TextField("", value: $cashFlows.first?.cashValue ?? .constant(0), format: .number).textFieldStyle(.roundedBorder)
                            }
                        }
                        HStack {
                            Picker("", selection: $firstWalletName) {
                                Text("None").tag("None")
                                ForEach(walletOption, id: \.self) { wallet in
                                    if(wallet.walletName != "Coupon"){
                                        Text(wallet.walletName).tag(wallet.walletName)
                                    }
                                }
                                .onChange(of: firstWalletName){ oldValue, newValue in
                                    if(firstWalletName == "None"){
                                        firstWalletBalance = 0
                                        updateUndistributedBalance()
                                    }
                                }
                            }
                            
                            TextField("Amount", value: $firstWalletBalance, format: .currency(code: "IDR"))
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.numberPad)
                                .onChange(of: firstWalletBalance) { oldValue, newValue in
                                    updateUndistributedBalance()
                                }
                                .disabled(firstWalletName == "None")
                        }
                        
                        HStack {
                            Picker("", selection: $secondWalletName) {
                                Text("None").tag("None")
                                ForEach(walletOption, id: \.self) { wallet in
                                    if(wallet.walletName != "Coupon"){
                                        Text(wallet.walletName).tag(wallet.walletName)
                                    }
                                }
                            }.onChange(of: secondWalletName){ oldValue, newValue in
                                if(secondWalletName == "None"){
                                    secondWalletBalance = 0
                                    updateUndistributedBalance()
                                }
                            }
                            
                            
                            TextField("Amount", value: $secondWalletBalance, format: .currency(code: "IDR"))
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.numberPad)
                                .onChange(of: secondWalletBalance) { oldValue, newValue in
                                    updateUndistributedBalance()
                                }
                                .disabled(secondWalletName == "None")
                        }
                        
                        Text("Undistributed Balance: Rp \(undistributedBalance)")
                            .foregroundColor(undistributedBalance == 0 ? .green : .red)
                    }
                }
                .padding()
                .formStyle(.columns)
                .navigationTitle("Pay Bill")
                .toolbar{
                    ToolbarItem(placement: .topBarTrailing){
                        Button(action: {
                            showAddWalletModal = true
                        }, label: {
                            Text("Add Wallet")
                        })
                    }
                    ToolbarItem(placement: .topBarTrailing){
                        Button(action: makeOrder, label: {
                            Text("Done")
                        }).disabled(undistributedBalance != 0)
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            cashFlows = [CashFlow]()
                            customerName = ""
                            showPayBillModal = false
                        }
                    }
                }
                .onAppear {
                    if cashFlows.isEmpty{
                        let coupon = CashFlow(id: UUID(), walletName:"Coupon", cashValue: 0)
                        cashFlows.append(coupon)
                    }
                    updateUndistributedBalance()
                }
                
                .sheet(isPresented: $showAddWalletModal){
                    NavigationStack{
                        Form{
                            VStack(alignment: .center){
                                HStack{
                                    Text("Wallet Name")
                                    TextField("Wallet Name", text: $walletName)
                                        .textFieldStyle(.roundedBorder)
                                        .padding(.horizontal, 12)
                                }
                            }
                        }
                        .padding()
                        .formStyle(.columns)
                        .navigationTitle("Add Wallet")
                        .toolbar{
                            ToolbarItem(placement: .topBarTrailing){
                                Button(action: {
                                    addWallet()
                                    walletName = ""
                                    showAddWalletModal = false
                                }){
                                    Text("Done")
                                }.disabled(walletName == "")
                            }
                            ToolbarItem(placement: .topBarLeading) {
                                Button("Cancel") {
                                    showAddWalletModal = false
                                    walletName = ""
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            if walletOption.isEmpty{
                let coupon = Wallet(walletName: "Coupon", balance: 0)
                coupon.save(context: modelContext)
            }
        }
        
    }
    
    private func resetOrder(){
        withAnimation{
            order.clearOrder()
        }
    }
    
    private func openHistory(){
        router.navigate(to: .historicTransaction)
    }
    
    private func analytics(){
        router.navigate(to: .analyticsTransasction)
    }
    
    private func addWallet(){
        let newWallet = Wallet(walletName: walletName, balance: 0)
        newWallet.save(context: modelContext)
    }
    
    private func makeOrder(){
        let persistentOrder = order.toPersistentOrder()
        if(firstWalletName != "None" && firstWalletBalance != 0){
            let newCashFlow = CashFlow(id: UUID(), walletName: firstWalletName, cashValue: firstWalletBalance)
            cashFlows.append(newCashFlow)
        }
        
        if(secondWalletName != "None" && secondWalletBalance != 0){
            let newCashFlow = CashFlow(id: UUID(), walletName: secondWalletName, cashValue: secondWalletBalance)
            cashFlows.append(newCashFlow)
        }
        
        let newTransaction = Transaction(id: UUID(), order: persistentOrder, customerName: customerName, timeStamp: .now, cashFlows: cashFlows)
        
        newTransaction.save(context: modelContext)
        order.clearOrder()
        cashFlows = [CashFlow]()
        customerName = ""
        showPayBillModal = false
    }
    
    private func updateUndistributedBalance() {
        let distributedSum = (couponAmount * 30000) + firstWalletBalance + secondWalletBalance
        undistributedBalance = order.totalPrice - distributedSum
    }
    
    private func removeCashFlow() {
        if let last = cashFlows.last {
            cashFlows.removeLast()
            undistributedBalance += last.cashValue
            updateUndistributedBalance()
        }
    }
    
    private func addCashFlow() {
        let newCashFlow = CashFlow(id: UUID(), walletName: "None", cashValue: 0)
        cashFlows.append(newCashFlow)
        updateUndistributedBalance()
    }
}

#Preview{
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Supplier.self,
                                           Product.self,
                                           Transaction.self,
                                           PersistentOrder.self,
                                           PersistentOrderItem.self,
                                           Wallet.self
                                           , configurations: config)
        
        return tempView()
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container: \(error.localizedDescription)")
    }
    
    struct tempView: View{
        @Environment(\.modelContext) var modelContext: ModelContext
        
        var body: some View{
            PointOfSaleView()
                .environmentObject(Router())
                .environmentObject(Order())
                .task {
                    Seeder.seedData(modelContext: modelContext)
                }
        }
    }
    
    return tempView()
}
