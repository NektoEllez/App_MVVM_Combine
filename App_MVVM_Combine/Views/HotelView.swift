//
//  HotelView.swift
//  App_MVVM_Combine
//
//  Created by Иван Марин on 05.09.2023.
//

import SwiftUI

struct HotelView: View {
    // Этот свойство для взаимодействия с координатором приложения
    @EnvironmentObject var coordinator: AppCoordinator
    
    // ViewModel для данного экрана
    @ObservedObject var viewModel: HotelViewModel = HotelViewModel()
    
    // Переменные для управления состоянием загрузки данных и отображения кнопок
    @State private var dataLoaded = false
    @State private var shouldShowButton = false
    
    // Изображения, используемые на этом экране
    private let closeSquareImage = Image("close-square")
    private let emojiHappyImage = Image("emoji-happy")
    private let tickSquareImage = Image("tick-square")
    private let chevron = Image("chevron")  
    
    var body: some View {
        ZStack {
            backgroundView
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        TabbedScrollView(cachedImages: viewModel.hotel?.cachedImages ?? [])
                        hotelInfo
                        hotelNameTextStyle
                        hotelAddressTextStyle
                        priceDetailsView
                    }
                    .onAppear {
                        viewModel.fetchHotelData()
                        viewModel.loadImages() // Загрузка и кэширование изображений
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            dataLoaded = true
                        }
                    }
                    .background(Color.white.cornerRadius(15))
                    VStack {
                        aboutHotelTextStyle
                        HotelPeculiaritiesView(peculiarities: viewModel.hotelPeculiarities)
                        hotelDescriptionView
                        buttonsView
                            .onAppear { shouldShowButton = true }
                    }
                    .background(Color.white.cornerRadius(15))
                }
                .background(Color(UIColor(red: 0.965, green: 0.965, blue: 0.976, alpha: 1)))
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Отель")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                    }
                    ToolbarItem(placement: .bottomBar) {
                        Button(action: { coordinator.resetSelections(); coordinator.navigateToRoomView() }) {
                            Text("К выбору номера")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .padding(12)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(15)
                        .padding(.top, 15)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.white, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
            }
            .onAppear {
                viewModel.fetchHotelData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    dataLoaded = true
                }
            }
            if !dataLoaded {
                loadingView
            }
        }
    }
}

extension HotelView {
    // Этот метод определяет фоновое представление в зависимости от состояния загрузки данных
    private var backgroundView: some View {
        if dataLoaded {
            return Color.clear.edgesIgnoringSafeArea(.all).eraseToAnyView()
        } else {
            return Color.black.opacity(0.9).edgesIgnoringSafeArea(.all).eraseToAnyView()
        }
    }
    
    // Этот метод определяет представление для экрана загрузки
    private var loadingView: some View {
        Color.black.opacity(0.6)
            .edgesIgnoringSafeArea(.all)
            .progressViewStyle(CircularProgressViewStyle())
            .foregroundColor(.blue)
    }
    
    // MARK: - Computed Properties
    
    // Этот свойство объединяет информацию о рейтинге отеля
    private var combinedHotelInfoDescription: String {
        guard let valueDesc = viewModel.hotel?.rating.description,
              let nameDesc = viewModel.hotel?.ratingName.description else {
            return ""
        }
        return "\(valueDesc) \(nameDesc)"
    }
    
    // Этот свойство возвращает имя отеля, используя адрес
    private var hotelName: String {
        if let address = viewModel.hotel?.address.description {
            let components = address.components(separatedBy: ",")
            if let firstPart = components.first {
                return firstPart.trimmingCharacters(in: .whitespaces)
            }
        }
        return ""
    }
    
    // Этот свойство возвращает адрес отеля
    private var hotelAddress: String {
        return viewModel.hotel?.address.description ?? ""
    }
    
    // Этот свойство возвращает цену отеля
    private var hotelPrice: String {
        guard let priceDescription = viewModel.hotel?.minimalPrice.description else {
            return ""
        }
        return priceDescription
    }
    
    // Этот свойство возвращает информацию о цене отеля
    private var hotelPriceInfo: String {
        guard let priceDescription = viewModel.hotel?.priceForIt.description else {
            return ""
        }
        return priceDescription
    }
    
    // MARK: - Hotel Info Section
    
    // Этот метод отображает информацию о рейтинге отеля
    private var hotelInfo: some View {
        ZStack {
            HStack(alignment: .center, spacing: 2) {
                Image(systemName: "star.fill") // Иконка звезды
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundColor(Color(UIColor(red: 1, green: 0.66, blue: 0, alpha: 1))) // Оранжевый цвет
                Text(combinedHotelInfoDescription)
                    .font(.system(size: 16, weight: .medium))
                    .padding(.horizontal, 2)
                    .foregroundColor(Color(UIColor(red: 1, green: 0.66, blue: 0, alpha: 1))) // Оранжевый цвет
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
        }
        .background(Color(red: 1, green: 0.78, blue: 0).opacity(0.2))
        .cornerRadius(5)
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - About Hotel Section
    
    // Этот метод отображает раздел "Об Отеле"
    private var aboutHotelTextStyle: some View {
        HStack {
            Text("Об Отеле")
                .font(.system(size: 22, weight: .medium))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.top, 8)
        .padding(.horizontal, 16)
    }
    
    // MARK: - Hotel Name Section
    
    // Этот метод отображает имя отеля
    private var hotelNameTextStyle: some View {
        Text(hotelName)
            .font(.system(size: 22, weight: .medium))
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 8)
            .padding(.horizontal, 16)
    }
    
    // MARK: - Hotel Address Section
    
    // Этот метод отображает адрес отеля
    private var hotelAddressTextStyle: some View {
        Text(hotelAddress)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(Color(UIColor(red: 0.051, green: 0.447, blue: 1, alpha: 1)))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.top, 8)
    }
    
    // MARK: - Price Details Section
    
    // Этот метод отображает информацию о цене отеля
    private var priceDetailsView: some View {
        HStack {
            Text(formatPrice(Int(hotelPrice) ?? 0))
                .font(.system(size: 30, weight: .semibold))
                .foregroundColor(.black)
                .padding(.leading, 16)
            
            Text(hotelPriceInfo)
                .foregroundColor(Color(UIColor(red: 0.51, green: 0.529, blue: 0.588, alpha: 1)))
                .font(.system(size: 15, weight: .regular))
                .padding(.leading, 8)
        }
        .padding([.bottom, .top], 16)
    }
    
    // MARK: - Hotel Description Section
    
    // Этот метод отображает описание отеля
    private var hotelDescriptionView: some View {
        VStack {
            Text(viewModel.hotel?.about.description ?? "Описание отеля недоступно")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.black)
                .padding(.leading, 16)
                .padding(.trailing, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    // MARK: - Buttons Section
    
    // Этот метод отображает кнопки
    private var buttonsView: some View {
        VStack(spacing: 0) {
            // Первая кнопка
            Button(action: {
                // Действие для первой кнопки
            }) {
                buttonContent(imageName: emojiHappyImage, buttonText1: "Удобства", buttonText2: "Самое необходимое")
            }
            .frame(maxWidth: .infinity)
            
            Divider()
                .padding(.trailing, 18)
                .padding(.leading, 48)
            
            // Вторая кнопка
            Button(action: {
                // Действие для второй кнопки
            }) {
                buttonContent(imageName: tickSquareImage, buttonText1: "Что включено", buttonText2: "Самое необходимое")
            }
            .frame(maxWidth: .infinity)
            
            Divider()
                .padding(.trailing, 18)
                .padding(.leading, 48)
            
            // Третья кнопка
            Button(action: {
                // Действие для третьей кнопки
            }) {
                buttonContent(imageName: closeSquareImage, buttonText1: "Что не включено", buttonText2: "Самое необходимое")
            }
            .frame(maxWidth: .infinity)
        }
        .background(Color(UIColor(red: 0.984, green: 0.984, blue: 0.988, alpha: 1)))
        .cornerRadius(15)
        .padding([.trailing, .leading], 16)
        .padding([.top, .bottom], 8)
    }
    
    // MARK: - Helper Method
    
    // Этот метод форматирует цену отеля, добавляя разделители тысяч и символ "₽"
    private func formatPrice(_ price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.locale = Locale(identifier: "ru_RU")
        
        if let formattedPrice = formatter.string(from: NSNumber(value: price)) {
            return "от \(formattedPrice) ₽"
        } else {
            return "от \(price) ₽"
        }
    }
    
    /**
     Создает кастомизированное представление для кнопок, включая изображение, два текстовых поля и изображение справа.
     
     - Parameter imageName: Изображение для кнопки.
     - Parameter buttonText1: Текст для первого текстового поля.
     - Parameter buttonText2: Текст для второго текстового поля.
     
     - Returns: View, представляющее кастомную кнопку.
     */
    private func buttonContent(imageName: Image, buttonText1: String, buttonText2: String) -> some View {
        HStack {
            // Изображение кнопки
            imageName
                .resizable()
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading) {
                // Первое текстовое поле
                Text(buttonText1)
                    .foregroundColor(Color(UIColor(red: 0.174, green: 0.189, blue: 0.209, alpha: 1)))
                    .font(.system(size: 16, weight: .medium))
                
                // Второе текстовое поле
                Text(buttonText2)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(UIColor(red: 0.511, green: 0.528, blue: 0.588, alpha: 1)))
            }
            
            Spacer()
            
            // Изображение справа от текста
            chevron
                .foregroundColor(Color(UIColor(red: 0.984, green: 0.984, blue: 0.988, alpha: 1)))
                .padding(.trailing, 10)
        }
        .padding([.trailing, .leading, .top, .bottom], 15)
    }
}

struct HotelView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview with a larger frame
            HotelView()
            RoomView()
        }
    }
}
