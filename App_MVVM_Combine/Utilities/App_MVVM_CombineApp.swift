//
//  App_MVVM_CombineApp.swift
//  App_MVVM_Combine
//
//  Created by Иван Марин on 05.09.2023.
//

import SwiftUI

@main
struct App_MVVM_CombineApp: App {
    var bookingViewModel = BookingViewModel()
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView()
                .environmentObject(bookingViewModel)
                .environmentObject(AppCoordinator.shared)
        }
    }
}
