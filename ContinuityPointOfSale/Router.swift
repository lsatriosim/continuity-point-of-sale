//
//  Router.swift
//  ContinuityPointOfSale
//
//  Created by Liefran Satrio Sim on 30/08/24.
//

import Foundation
import SwiftUI

final class Router: ObservableObject{
    @Published var splitViewVisibility = NavigationSplitViewVisibility.all
    @Published var disableSideBar : Bool = false
    
    public enum StackType: Codable, Hashable{
        case supplier
        case product
        case pointOfSale
        case bundling
    }
    
    public enum SupplierDestination: Codable, Hashable {
        case supplierList
    }
    
    public enum ProductDestination: Codable, Hashable {
        case productList
    }
    
    public enum PointOfSaleDestination: Codable, Hashable {
        case pointOfSale
        case historicTransaction
        case analyticsTransasction
    }
    
    public enum BundlingDestination: Codable, Hashable {
        case bundling
    }
    
    @Published var supplyPath = NavigationPath()
    @Published var productPath = NavigationPath()
    @Published var pointOfSalePath = NavigationPath()
    @Published var bundlingPath = NavigationPath()
    
    @Published var geometryProxy: GeometryProxy? = nil
    
    func navigate(to destination: SupplierDestination) {
        supplyPath.append(destination)
    }
    
    func navigate(to destination: ProductDestination) {
        productPath.append(destination)
    }
    
    func navigate(to destination: PointOfSaleDestination) {
        pointOfSalePath.append(destination)
    }
    
    func navigate(to destination: BundlingDestination) {
        bundlingPath.append(destination)
    }
    
    func navigateBack(stackType: StackType) {
        if stackType == .supplier {
            supplyPath.removeLast()
        }else if stackType == .product {
            productPath.removeLast()
        }else if stackType == .pointOfSale {
            pointOfSalePath.removeLast()
        }else{
            bundlingPath.removeLast()
        }
    }
    
    func navigateToRoot(stackType: StackType) {
        if stackType == .supplier {
            supplyPath = NavigationPath()
        }else if stackType == .product {
            productPath = NavigationPath()
        }else if stackType == .pointOfSale {
            pointOfSalePath = NavigationPath()
        }else{
            bundlingPath = NavigationPath()
        }
    }
}
