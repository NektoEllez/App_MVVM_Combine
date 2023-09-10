import SwiftUI
import Combine
import Kingfisher

class HotelViewModel: ObservableObject {
    @Published var hotel: Hotel?
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var hotelPeculiarities: [String] = []
    
    private var apiService = APIService.shared
    private var cancellables = Set<AnyCancellable>()
    private var imageCache = NSCache<NSString, UIImage>()
    
    init() {
        fetchHotelData()
    }
        
    func fetchHotelData() {
        self.isLoading = true
        apiService.fetchHotelData()?
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    self.error = error
                    print("Error fetching hotel data: \(error)")
                case .finished:
                    print("Finished fetching hotel data")
                }
            } receiveValue: { hotel in
                self.hotel = hotel
                self.hotelPeculiarities = hotel.about.peculiarities
                print("Received hotel data: \(hotel)")
                
                // Вызываем метод для загрузки и кэширования изображений
                self.loadImages()
            }
            .store(in: &cancellables)
    }
    
    func loadImages() {
        // Создайте Set для отслеживания уникальных ссылок на изображения
        var uniqueImageUrls = Set<String>()
        
        for imageUrl in hotel?.imageUrls ?? [] {
            // Проверяем, есть ли изображение в кэше
            if let cachedImage = imageCache.object(forKey: imageUrl as NSString) {
                // Если изображение найдено в кэше, обновляем cachedImages только для отеля, если это уникальная ссылка
                if !uniqueImageUrls.contains(imageUrl) {
                    hotel?.cachedImages.append(cachedImage)
                    uniqueImageUrls.insert(imageUrl)
                }
            } else {
                // Если изображение не найдено в кэше, загружаем его
                guard !uniqueImageUrls.contains(imageUrl) else {
                    // Если у нас уже есть другая ссылка с той же ссылкой, пропускаем загрузку
                    continue
                }
                
                guard let url = URL(string: imageUrl) else { continue }
                
                KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil) { [weak self] result in
                    switch result {
                    case .success(let value):
                        // Обработка успешной загрузки изображения
                        let loadedImage = value.image
                        // Кэшируем изображение
                        self?.imageCache.setObject(loadedImage, forKey: imageUrl as NSString)
                        // Обновляем cachedImages только для отеля, если это уникальная ссылка
                        if !uniqueImageUrls.contains(imageUrl) {
                            self?.hotel?.cachedImages.append(loadedImage)
                            uniqueImageUrls.insert(imageUrl)
                        }
                        // Далее, вы можете обновить свойства или опубликовать изображение
                    case .failure(let error):
                        // Обработка ошибки загрузки
                        print("Error loading image: \(error)")
                    }
                }
            }
        }
    }
}
