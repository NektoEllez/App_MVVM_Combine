//
//  AppCoordinator.swift
//  App_MVVM_Combine
//
//  Created by Иван Марин on 05.09.2023.
//

import SwiftUI

class AppCoordinator: ObservableObject {
    
    /// Синглтон инстанс класса `AppCoordinator`, чтобы избежать множественных инстанций в разных частях приложения.
    static let shared = AppCoordinator()
    
    /// Опциональная переменная для хранения выбранного отеля, которая может быть использована для передачи данных между различными экранами.
    @Published var selectedHotel: HotelView?
    
    /// Опциональная переменная для хранения выбранной комнаты, которая может быть использована для передачи данных между различными экранами.
    @Published var selectedRoom: RoomView?
    
    /// Опциональная переменная для хранения выбранной комнаты, которая может быть использована для передачи данных между различными экранами.
    @Published var selectedBookingRoom: BookingView?
    
    /// Опциональная переменная для хранения выбранной комнаты, которая может быть использована для передачи данных между различными экранами.
    @Published var selectedPayments: PaymentSuccessView?
    
    private init() {}
    
    /// Функция для сброса всех выбранных данных, когда пользователь возвращается на начальный экран.
    func resetSelections() {
        selectedHotel = nil
        selectedRoom = nil
        selectedBookingRoom = nil
        selectedPayments = nil
    }
    
    func navigateToRoomView() {
        self.selectedRoom = RoomView()
    }
    
    func navigateToBookingView() {
        self.selectedBookingRoom = BookingView()
    }

    func navigateToPaymentSuccessView() {
        self.selectedPayments = PaymentSuccessView()
    }
}

struct AppCoordinatorView: View {
    
    @StateObject private var appCoordinator = AppCoordinator.shared
    
    var body: some View {
        NavigationView {
            switch (appCoordinator.selectedHotel, appCoordinator.selectedRoom, appCoordinator.selectedBookingRoom, appCoordinator.selectedPayments) {
            case (nil, nil, nil, nil):
                HotelView()
                // Отображаем начальный экран (например, список отелей)
            case (nil, .some, nil, nil):
                // Отображаем экран с деталями комнаты
                RoomView()
            case (nil, nil, .some, nil):
                // Отображаем экран бронирования
                BookingView()
            case (nil, nil, nil, .some):
                // Отображаем экран успешной оплаты
                PaymentSuccessView()
            default:
                // Отображаем какой-либо другой экран или ошибку
                Text("Неизвестное состояние")
            }
        }
    }
}
