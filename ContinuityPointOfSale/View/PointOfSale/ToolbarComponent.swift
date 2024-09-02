//
//  ToolbarComponent.swift
//  ContinuityPointOfSale
//
//  Created by Liefran Satrio Sim on 01/09/24.
//

import SwiftUI

struct ToolbarComponent: View {
    @Binding var searchKeywords : String
    var proxy: GeometryProxy
    var resetOrder: () -> Void
    var openHistory: () -> Void
    var analytics: () -> Void
    
    
    var body: some View {
        HStack{
            Spacer()
            Image(systemName: "magnifyingglass.circle").resizable().aspectRatio(contentMode: .fit).frame(height: proxy.size.height * 0.04).foregroundStyle(.gray)
            TextField("Search menu...", text: $searchKeywords).textFieldStyle(.roundedBorder)
                .frame(width: proxy.size.width * 0.4, height: proxy.size.height * 0.1)
            Spacer()
            Button(action: resetOrder, label: {
                ZStack{
                    RoundedRectangle(cornerSize: CGSize(width: 7, height: 7))
                        .fill(.white)
                        .frame(width: proxy.size.width * 0.14, height: proxy.size.height * 0.04)
                        .overlay(
                                    RoundedRectangle(cornerSize: CGSize(width: 7, height: 7))
                                        .stroke(.red, lineWidth: 1)
                                )
                    
                    HStack{
                        Image(systemName: "arrow.counterclockwise")
                            .foregroundStyle(.red)
                        Text("Reset Order")
                            .foregroundStyle(.red)
                    }
                }
            })
            .padding(.vertical, 12)
            Spacer()
            Button(action: openHistory, label: {
                ZStack{
                    RoundedRectangle(cornerSize: CGSize(width: 7, height: 7))
                        .fill(.white)
                        .frame(width: proxy.size.width * 0.14, height: proxy.size.height * 0.04)
                        .overlay(
                                    RoundedRectangle(cornerSize: CGSize(width: 7, height: 7))
                                        .stroke(.cyan, lineWidth: 1)
                                )
                    
                    HStack{
                        Image(systemName: "list.bullet.rectangle.portrait.fill")
                            .foregroundStyle(.cyan)
                        Text("History")
                            .foregroundStyle(.cyan)
                    }
                }
            })
            .padding(.vertical, 12)
            Spacer()
            Button(action: analytics, label: {
                ZStack{
                    RoundedRectangle(cornerSize: CGSize(width: 7, height: 7))
                        .fill(.white)
                        .frame(width: proxy.size.width * 0.14, height: proxy.size.height * 0.04)
                        .overlay(
                                    RoundedRectangle(cornerSize: CGSize(width: 7, height: 7))
                                        .stroke(.green, lineWidth: 1)
                                )
                    
                    HStack{
                        Image(systemName: "chart.bar")
                            .foregroundStyle(.green)
                        Text("Analytics")
                            .foregroundStyle(.green)
                    }
                }
            })
            .padding(.vertical, 12)
        }.frame(width: .infinity, height: .infinity)
            .padding(.horizontal, 24)
    }
}

#Preview {
    GeometryReader{ proxy in
        ToolbarComponent(searchKeywords: .constant(""), proxy: proxy, resetOrder: {}, openHistory: {}, analytics: {})
    }
}
