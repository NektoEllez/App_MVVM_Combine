//
//  CustomPageTabIndicator.swift
//  App_MVVM_Combine
//
//  Created by Иван Марин on 06.09.2023.
//

import SwiftUI

struct CustomPageTabIndicator: View {
    var numberOfPages: Int
    @Binding var currentPage: Int // Use @Binding for currentPage
    let maxVisibleCircles = 5 // Maximum number of visible circles
    let circleSize: CGFloat = 7
    let spacing: CGFloat = 5 // Расстояние между каждым кружком

    init(numberOfPages: Int, currentPage: Binding<Int>) {
        self.numberOfPages = numberOfPages
        self._currentPage = currentPage // Use _currentPage to bind it
    }

    var body: some View {
        HStack(spacing: spacing) { // Используйте spacing для расстояния между кружками
            ForEach(0..<maxVisibleCircles, id: \.self) { index in
                Circle()
                    .frame(width: circleSize, height: circleSize)
                    .foregroundColor(circleColor(index: index))
            }
        }
        .padding(.horizontal, 10) // Добавьте отступы справа и слева
        .padding(.vertical, 5)
        .background(Color.white)
        .cornerRadius(8.5)
        .onAppear {
            // Adjust currentPage to make it cyclic if needed
            if self.currentPage >= self.maxVisibleCircles {
                self.currentPage = self.currentPage % self.maxVisibleCircles
            }
        }
    }

    func circleColor(index: Int) -> Color {
        let selectedIndex = currentPage % maxVisibleCircles
        let difference = abs(selectedIndex - index)

        if difference == 0 {
            return .black
        } else {
            let alpha = 0.22 - Double(difference) * 0.05
            return Color(red: 0, green: 0, blue: 0, opacity: alpha)
        }
    }
}
