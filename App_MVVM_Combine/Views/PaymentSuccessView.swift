//
//  PaymentSuccessView.swift
//  App_MVVM_Combine
//
//  Created by Иван Марин on 05.09.2023.
//

import SwiftUI

import SwiftUI

// Расширение для определения тела представления с заказом
extension PaymentSuccessView {
    private var orderBody: some View {
        VStack(alignment: .center, spacing: 20) {
            // Круглое фоновое изображение с вложенным изображением
            ZStack {
                Circle()
                    .fill(Color(UIColor(red: 0.965, green: 0.965, blue: 0.976, alpha: 1)))
                    .frame(width: 94, height: 94)
                Image("Party")
                    .resizable()
                    .frame(width: 44, height: 44)
            }
            Text("Ваш заказ принят в работу")
                .padding(.top, 42)
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(Color(UIColor(red: 0, green: 0, blue: 0, alpha: 1)))
            
            // Отображение сгенерированного текста подтверждения заказа
            Text(orderNumber.generateRandomOrderConfirmationText())
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(Color(UIColor(red: 0.51, green: 0.529, blue: 0.588, alpha: 1)))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal)
        }
    }
}

struct PaymentSuccessView: View {
    @State private var orderNumber: RandomOrderNumberGenerator = RandomOrderNumberGenerator()
    @EnvironmentObject var paymentSuccessViewCoordinator: AppCoordinator
    private let chevronLeft = Image("chevronLeft")
    
    var body: some View {
        ZStack {
            NavigationView {
                // Использование определенного тела представления заказа
                orderBody
                .toolbar {
                    
                    ToolbarItem(placement: .principal) {
                        Text("Заказ Оплачен")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.black)
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            paymentSuccessViewCoordinator.resetSelections()
                            paymentSuccessViewCoordinator.navigateToBookingView()
                        }, label: {
                            chevronLeft
                                .foregroundColor(.black)
                                .frame(alignment: .leading)
                                .frame(width: 22)
                        })
                    }
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button(action: {
                            paymentSuccessViewCoordinator.resetSelections()
//                            paymentSuccessViewCoordinator.navigateBackToHotelView()
                            print("НАЖИМАЕТСЯ")
                        }) {
                            Text("Супер!")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                                .padding(12)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color.blue)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(15)
                        .padding(.top, 12)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.white, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .background(Color(UIColor(red: 0.965, green: 0.965, blue: 0.976, alpha: 1)))
    }
}

struct Success_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Предварительный просмотр с большим размером
            PaymentSuccessView()
        }
    }
}
