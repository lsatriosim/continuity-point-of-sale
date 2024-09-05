//
//  Formatter.swift
//  ContinuityPointOfSale
//
//  Created by Liefran Satrio Sim on 05/09/24.
//

import Foundation

struct StringFormatter{
    static func formatToRupiah(input: String) -> String {
            // Remove non-digit characters
            let numericString = input.filter { $0.isNumber }
            
            // Convert string to number
            guard let number = Int(numericString) else {
                return ""
            }
            
            // Format number to Rupiah currency
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencySymbol = "Rp "
            formatter.maximumFractionDigits = 0
            
            if let formattedString = formatter.string(from: NSNumber(value: number)) {
                return formattedString
            } else {
                return ""
            }
        }
}
