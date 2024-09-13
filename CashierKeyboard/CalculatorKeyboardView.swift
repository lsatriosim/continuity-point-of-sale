//
//  CalculatorKeyboardView.swift
//  CashierKeyboard
//
//  Created by Liefran Satrio Sim on 13/09/24.
//

import SwiftUI

struct CalculatorKeyboardView: View {
    let handleKeyPress: (String) -> Void
    
    let keys = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        ["00", "000", "Delete"],
        ["C"]
    ]
    
    var body: some View {
        VStack(spacing: 10) {
            ForEach(keys, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(row, id: \.self) { key in
                        Button(action: {
                            handleKeyPress(key)
                        }) {
                            Text(key)
                                .font(.largeTitle)
                                .frame(width: 120, height: 70)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .foregroundStyle(.primary)
                        }
                    }
                }
            }
        }
        .padding()
    }
}
