//
//  Booking.swift
//  App_MVVM_Combine
//
//  Created by Иван Марин on 05.09.2023.
//
import Foundation

/// Структура `Booking` представляет информацию о бронировании.
/// Мы используем `Identifiable` протокол для того, чтобы легко идентифицировать каждый объект отеля (например, в SwiftUI списках).
/// Протокол `Codable` используется для декодирования объекта от JSON ответа API.
struct Booking: Identifiable, Codable {
    /// Уникальный идентификатор бронирования.
    let id: Int
    /// Название отеля.
    let hotelName: String
    /// Адрес отеля.
    let hotelAddress: String
    /// Рейтинг отеля (количество звезд).
    let hotelRating: Int
    /// Название рейтинга отеля (например, "Превосходно").
    let ratingName: String
    /// Город отправления.
    let departure: String
    /// Страна и город прибытия.
    let arrivalCountry: String
    /// Дата начала тура.
    let tourStartDate: String
    /// Дата окончания тура.
    let tourEndDate: String
    /// Количество ночей.
    let numberOfNights: Int
    /// Информация о номере.
    let room: String
    /// Информация о питании.
    let nutrition: String
    /// Общая стоимость тура.
    let tourPrice: Int
    /// Топливный сбор.
    let fuelCharge: Int
    /// Сервисный сбор.
    let serviceCharge: Int

    /// Ключи для декодирования JSON.
    enum CodingKeys: String, CodingKey {
        case id
        case hotelName = "hotel_name"
        case hotelAddress = "hotel_adress"
        case hotelRating = "horating"
        case ratingName = "rating_name"
        case departure
        case arrivalCountry = "arrival_country"
        case tourStartDate = "tour_date_start"
        case tourEndDate = "tour_date_stop"
        case numberOfNights = "number_of_nights"
        case room
        case nutrition
        case tourPrice = "tour_price"
        case fuelCharge = "fuel_charge"
        case serviceCharge = "service_charge"
    }
}
