//
//  BookingViewModel.swift
//  App_MVVM_Combine
//
//  Created by Иван Марин on 05.09.2023.
//

import SwiftUI
import Combine
import Kingfisher

/// `BookingViewModel` отвечает за управление состоянием и логикой бронирования.
/// Он использует `APIService` для создания нового бронирования и обновляет UI через публикации.
class BookingViewModel: ObservableObject {
    
    /// Публикуемое свойство для хранения данных о бронировании.
    @Published var booking: Booking?
    
    /// Публикуемое свойство для отслеживания состояния загрузки.
    @Published var isLoading: Bool = false
    
    /// Публикуемое свойство для хранения возможных ошибок, возникших во время сетевого запроса.
    @Published var error: Error?
    
    /// Ссылка на синглтон экземпляр `APIService` для выполнения сетевых запросов.
    private var apiService = APIService.shared
    
    /// Набор для хранения отмененных подписчиков.
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isValid: Bool = false

    @Published var emailViewModel = TextFieldViewModel(keyboardType: .emailAddress, validationFunction: { text in
        return !text.isEmpty && TextFieldViewModel.validateEmail(text)
    })
    
    @Published var phoneViewModel = TextFieldViewModel(keyboardType: .numberPad)
    
    @Published var touristInfoDataViewModel: TouristInfoDataViewModel = TouristInfoDataViewModel(isEditingTextField: .constant(false)) {
        didSet {
            isLoading = false
        }
    }
    
    init() {
        fetchBookingData()
        
        phoneViewModel.$isValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                self?.isValid = isValid
            }
            .store(in: &cancellables)
        
        emailViewModel.$isValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                self?.isValid = isValid
            }
            .store(in: &cancellables)
    }
    
    func fetchBookingData() {
        self.isLoading = true
        apiService.fetchBookingData()?
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    self.error = error
                    print("Error fetching booking data: \(error)")
                case .finished:
                    print("Finished fetching booking data")
                }
            } receiveValue: { booking in
                self.booking = booking
                print("Received booking data: \(booking)")  // Здесь мы добавили строку для вывода полученных данных
            }
            .store(in: &cancellables)
    }
}
