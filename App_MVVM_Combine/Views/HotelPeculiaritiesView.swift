//
//  HotelPeculiaritiesView.swift
//  App_MVVM_Combine
//
//  Created by Иван Марин on 07.09.2023.
//

import SwiftUI

struct HotelPeculiaritiesView: View {
    var peculiarities: [String]

    var body: some View {
        let uniquePeculiarities = Array(Set(peculiarities)).sorted()
        let maxPeculiaritiesPerRow = 2  // Максимальное количество особенностей в одной строке

        return VStack(spacing: 8) {
            ForEach(uniquePeculiarities.chunked(into: maxPeculiaritiesPerRow), id: \.self) { peculiaritiesChunk in
                createHorizontalScrollView(with: peculiaritiesChunk)
            }
        }
        .padding(.leading, 16)
    }

    private func createHorizontalScrollView(with peculiarities: [String]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(peculiarities, id: \.self) { peculiarity in
                    createPeculiarityText(peculiarity: peculiarity)
                }
            }
        }
    }

    private func createPeculiarityText(peculiarity: String) -> some View {
        Text(peculiarity)
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(Color(UIColor(red: 0.51, green: 0.529, blue: 0.588, alpha: 1)))
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: false)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color(UIColor(red: 0.984, green: 0.984, blue: 0.988, alpha: 1)))
            .cornerRadius(5)
    }
}

