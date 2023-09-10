//
//  RoomViewModel.swift
//  App_MVVM_Combine
//
//  Created by Иван Марин on 05.09.2023.
//
import SwiftUI
import Combine
import Kingfisher
/// `RoomViewModel` отвечает за управление состоянием и логикой представления комнаты.
/// Он использует `APIService` для получения данных о комнате и обновляет UI через публикации.
class RoomViewModel: ObservableObject {
    
    @Published var rooms: [Room]?  // Обновлено до массива комнат
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    private var apiService = APIService.shared
    private var cancellables = Set<AnyCancellable>()
    private var imageCache = NSCache<NSString, UIImage>()

    init() {
        fetchRoomData()
    }
    func fetchRoomData() {
        self.isLoading = true
        apiService.fetchRoomData()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    self.error = error
                    print("Error fetching room data: \(error)")
                case .finished:
                    print("Finished fetching room data")
                }
            } receiveValue: { roomsResponse in
                self.rooms = roomsResponse.rooms
                print("Received room data: \(roomsResponse.rooms)")
                
                // Вызываем метод для загрузки и кэширования изображений
                self.loadImages()
            }
            .store(in: &cancellables)
    }
    
    func loadImages() {
        rooms?.forEach { originalRoom in
            // Создаем локальную копию комнаты с изменяемыми свойствами
            var room = originalRoom
            // Создайте Set для отслеживания уникальных ссылок на изображения для каждой комнаты
            var uniqueImageUrls = Set<String>()
            
            room.imageUrls.forEach { imageUrl in
                // Проверяем, есть ли изображение в кэше
                if let cachedImage = imageCache.object(forKey: imageUrl as NSString) {
                    // Если изображение найдено в кэше, обновляем cachedImages только для комнаты, если это уникальная ссылка
                    if !uniqueImageUrls.contains(imageUrl) {
                        room.cachedImages.append(cachedImage)
                        uniqueImageUrls.insert(imageUrl)
                    }
                } else {
                    // Если изображение не найдено в кэше, загружаем его
                    guard !uniqueImageUrls.contains(imageUrl) else {
                        // Если у нас уже есть другая ссылка с той же ссылкой, пропускаем загрузку
                        return
                    }
                    
                    guard let url = URL(string: imageUrl) else { return }
                    
                    KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil) { [weak self] result in
                        switch result {
                        case .success(let value):
                            // Обработка успешной загрузки изображения
                            let loadedImage = value.image
                            // Кэшируем изображение
                            self?.imageCache.setObject(loadedImage, forKey: imageUrl as NSString)
                            // Обновляем cachedImages только для комнаты, если это уникальная ссылка
                            if !uniqueImageUrls.contains(imageUrl) {
                                room.cachedImages.append(loadedImage)
                                uniqueImageUrls.insert(imageUrl)
                            }
                        case .failure(let error):
                            // Обработка ошибки загрузки
                            print("Error loading image: \(error)")
                        }
                    }
                }
            }
            // Заменяем оригинальную комнату на измененную
            if let roomIndex = rooms?.firstIndex(where: { $0.id == originalRoom.id }) {
                rooms?[roomIndex] = room
            }
        }
    }
}

struct RoomsResponse: Codable {
    let rooms: [Room]
}
