//
//  APIService.swift
//  App_MVVM_Combine
//
//  Created by Иван Марин on 05.09.2023.
//

import Foundation
import Combine

/// Класс `APIService` предоставляет методы для выполнения сетевых запросов к API.
/// Он использует Combine framework для управления асинхронными операциями и JSONDecoder для декодирования JSON ответов в соответствующие модели данных.
class APIService {
    
    /// Синглтон инстанс класса `APIService`, чтобы избежать множественных инстанций в разных частях приложения.
    static let shared = APIService()
    
    private init() {}
    
    /// Базовые URL для каждого запроса. Используем опциональные свойства, чтобы избежать force unwrapping.
    private let hotelURL = URL(string: "https://run.mocky.io/v3/35e0d18e-2521-4f1b-a575-f0fe366f66e3")
    private let roomURL = URL(string: "https://run.mocky.io/v3/f9a38183-6f95-43aa-853a-9c83cbb05ecd")
    private let bookingURL = URL(string: "https://run.mocky.io/v3/e8868481-743f-4eb2-a0d7-2bc4012275c8")

    /// Функция для получения данных об отеле.
    /// - Returns: Publisher, который  отправляет данные отеля или ошибку.
    func fetchHotelData() -> AnyPublisher<Hotel, Error>? {
        guard let url = hotelURL else { return nil }
        return fetchData(from: url)
            .print("Hotel Data Network Stream") // Добавьте эту строку для отслеживания сетевого потока
            .eraseToAnyPublisher() // Добавьте эту строку для преобразования типа публикатора обратно в AnyPublisher<Hotel, Error>
    }
    /// Функция для получения данных о комнате.
    /// - Returns: Publisher, который  отправляет данные комнаты или ошибку.
    func fetchRoomData() -> AnyPublisher<RoomsResponse, Error> {
        let url = URL(string: "https://run.mocky.io/v3/f9a38183-6f95-43aa-853a-9c83cbb05ecd")!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: RoomsResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    /// Функция для получения данных о бронировании.
    /// - Returns: Publisher, который  отправляет данные бронирования или ошибку.
    func fetchBookingData() -> AnyPublisher<Booking, Error>? {
        guard let url = bookingURL else { return nil }
        return fetchData(from: url)
    }
    
    /// Общая функция для выполнения сетевого запроса и декодирования ответа.
    /// - Parameter url: URL для запроса.
    /// - Returns: Publisher, который  отправляет декодированные данные или ошибку.
    private func fetchData<T: Decodable>(from url: URL) -> AnyPublisher<T, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

extension APIService {
    /// Функция для создания нового бронирования.
    /// - Parameter bookingData: Данные для нового бронирования.
    /// - Returns: Publisher, который отправляет созданное бронирование или ошибку.
    func createBooking(bookingData: Booking) -> AnyPublisher<Booking, Error> {
        // Создаем моковый ответ с успешным бронированием (здесь мы просто возвращаем те же данные, что и получили).
        let mockResponse = Just(bookingData)
            .setFailureType(to: Error.self)
            .delay(for: .seconds(2), scheduler: RunLoop.main) // Добавляем задержку в 2 секунды, чтобы сымитировать сетевой запрос.
        
        return mockResponse.eraseToAnyPublisher()
    }
}
