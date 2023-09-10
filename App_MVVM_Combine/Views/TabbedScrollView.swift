//
//  TabbedScrollView.swift
//  App_MVVM_Combine
//
//  Created by Иван Марин on 06.09.2023.
//

import SwiftUI

struct TabbedScrollView: View {
    @State private var selectedIndex = 0
    let cachedImages: [UIImage]
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(0..<cachedImages.count, id: \.self) { index in
                Image(uiImage: cachedImages[index]) // Используйте UIImage вместо загрузки из URL
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width)
                    .tag(index)
            }
        }
        .overlay(
            CustomPageTabIndicator(numberOfPages: cachedImages.count, currentPage: $selectedIndex)
                .padding(.bottom, 16)
                .frame(maxWidth: .infinity, alignment: .center),
            alignment: .bottom
        )
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(height: 257, alignment: .center)
        .background(Color.gray)
        .onAppear(perform: {
            UIScrollView.appearance().alwaysBounceVertical = false
        })
        .cornerRadius(15)
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }
}
