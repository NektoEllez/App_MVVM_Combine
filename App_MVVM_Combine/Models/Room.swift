//
//  Room.swift
//  App_MVVM_Combine
//
//  Created by Иван Марин on 05.09.2023.
//
import Foundation
import UIKit

/// Структура `Room` описывает детали конкретного номера в отеле.
/// Мы используем `Identifiable` протокол для того, чтобы легко идентифицировать каждый объект отеля (например, в SwiftUI списках).
/// Протокол `Codable` используется для декодирования объекта от JSON ответа API.
struct Room: Identifiable, Codable, Hashable {
    /// Уникальный идентификатор номера.
    let id: Int
    /// Название номера.
    let name: String
    /// Цена номера.
    let price: Int
    /// Дополнительная информация о цене (например, "За 7 ночей с перелетом").
    let pricePer: String
    /// Особенности номера (например, "Включен только завтрак", "Кондиционер").
    let peculiarities: [String]
    /// URL-адреса изображений номера.
    let imageUrls: [String]
    /// Кэшированные изображения комнаты.
    var cachedImages: [UIImage] = []
    
    /// Ключи для декодирования JSON.
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case price
        case pricePer = "price_per"
        case peculiarities
        case imageUrls = "image_urls"
    }
}

