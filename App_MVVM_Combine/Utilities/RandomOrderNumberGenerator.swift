//
//  RandomOrderNumberGenerator.swift
//  App_MVVM_Combine
//
//  Created by Иван Марин on 05.09.2023.
//

import Foundation

class RandomOrderNumberGenerator {
    func generateRandomOrderConfirmationText() -> String {
        // Генерируем случайное число не меньше 1000
        let randomOrderNumber = Int.random(in: 100...5000)
        
        // Создаем текст с номером заказа
        let confirmationText = "Подтверждение заказа №\(randomOrderNumber) может занять некоторое время (от 1 часа до суток). Как только мы получим ответ от туроператора, вам на почту придет уведомление."
        
        return confirmationText
    }

}
