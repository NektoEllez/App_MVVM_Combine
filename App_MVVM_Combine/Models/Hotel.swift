//
//  Hotel.swift
//  App_MVVM_Combine
//
//  Created by Иван Марин on 05.09.2023.
//
import Foundation
import UIKit

/// Структура `Hotel`, представляющая информацию об отеле.
/// Мы используем `Identifiable` протокол для того, чтобы легко идентифицировать каждый объект отеля (например, в SwiftUI списках).
/// Протокол `Codable` используется для декодирования объекта от JSON ответа API.
struct Hotel: Identifiable, Codable, Hashable {
    
    static func == (lhs: Hotel, rhs: Hotel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: Int
    let name: String
    let address: String
    let minimalPrice: Int
    let priceForIt: String
    let rating: Int
    let ratingName: String
    let imageUrls: [String]
    let about: AboutInfo
    var cachedImages: [UIImage] = []
    
    enum CodingKeys: String, CodingKey {
        case id, name, address = "adress", minimalPrice = "minimal_price", priceForIt = "price_for_it", rating, ratingName = "rating_name", imageUrls = "image_urls", about = "about_the_hotel"
    }
    
    struct AboutInfo: Codable {
        let description: String
        let peculiarities: [String]
    }
}
