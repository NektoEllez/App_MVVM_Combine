//
//  BookingView.swift
//  App_MVVM_Combine
//
//  Created by Иван Марин on 05.09.2023.
//

import SwiftUI

struct BookingView: View {
    @EnvironmentObject var bookingCoordinator: AppCoordinator
    @EnvironmentObject var bookingViewModel: BookingViewModel
    @ObservedObject var hotelViewModel: HotelViewModel = HotelViewModel()
    
    @State private var emailText: String = "Введите ваш email"
    @State private var phoneText: String = "Введите ваш номер телефона"
    @State private var isExpanded: Bool = false
    @State private var isEditingTextField: Bool = false
    
    @State private var touristInfoDataViewModels: [TouristInfoDataViewModel] = []
    
    private let chevronLeft = Image("chevronLeft")
    private let plus = Image("plus")
    
    var body: some View {
        ZStack{
            NavigationView {
                ScrollView {
                    bookingOrderHotelInfo
                    orderInfo
                    userInputSection
                    
                    ForEach(touristInfoDataViewModels.indices, id: \.self) { index in
                        TouristInfoView(touristInfoDataViewModels: $touristInfoDataViewModels, data: touristInfoDataViewModels[index])
                            .padding()
                            .background(Color.white.cornerRadius(15))
                    }
                    HStack {
                        Text("Добавить туриста")
                            .font(.headline)
                        Spacer()
                        Button(action: {
                            //                            bookingViewModel.isTouristInfoViewExpanded.toggle()
                            let newIsEditingTextField = false // Устанавливаем начальное значение активности текстовых полей
                            let newTouristInfoDataViewModel = TouristInfoDataViewModel(buttonText: "Новый турист", isEditingTextField: .constant(newIsEditingTextField))
                            touristInfoDataViewModels.append(newTouristInfoDataViewModel)
                        }) {
                            plus
                        }
                        .frame(width: 32, height: 32)
                        .background(Color(UIColor(red: 0.051, green: 0.447, blue: 1, alpha: 1)))
                        .cornerRadius(5)
                    }
                    .padding()
                    .background(Color.white.cornerRadius(15))
                    paymentInformation
                }
                .background(Color(UIColor(red: 0.965, green: 0.965, blue: 0.976, alpha: 1)))
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Бронирование")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        bookingCoordinator.resetSelections()
                        bookingCoordinator.navigateToRoomView()
                    }, label: {
                        chevronLeft
                            .foregroundColor(.black)
                            .frame(alignment: .leading)
                            .frame(width: 22)
                    })
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    Button(action: {
                        if bookingViewModel.isValid {
                            bookingCoordinator.resetSelections()
                            bookingCoordinator.navigateToPaymentSuccessView()
                        } else {
                            print("\(bookingViewModel.isValid)")
                        }
                    }) {
                        if bookingViewModel.isValid {
                            
                            Text(formatPrice(toPay()))
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .padding(15)
                        } else {
                            Text("Введите правильные данные")
                            
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .padding(15)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color.blue)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(15)
                    .padding(.top, 12)
                    .disabled(!bookingViewModel.isValid)
                    .id(UUID())
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.white, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .onAppear {
            initTouristInfoDataViewModels()
        }
    }
}

private extension BookingView {
    // Это представление отображает информацию о рейтинге отеля
    var bookingHotelInfo: some View {
        ZStack {
            HStack(alignment: .center, spacing: 2) {
                Image(systemName: "star.fill") // Изображение звезды
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundColor(Color(UIColor(red: 1, green: 0.66, blue: 0, alpha: 1))) // Цвет текста
                Text(combinedHotelInfoDescription)
                    .font(.system(size: 16, weight: .medium))
                    .padding(.horizontal, 2)
                    .foregroundColor(Color(UIColor(red: 1, green: 0.66, blue: 0, alpha: 1))) // Цвет текста
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
        }
        .background(Color(red: 1, green: 0.78, blue: 0).opacity(0.2))
        .cornerRadius(5)
        .padding([.horizontal, .top], 16)
        .padding(.top, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var combinedHotelInfoDescription: String {
        guard let valueDesc = bookingViewModel.booking?.hotelRating.description,
              let nameDesc = bookingViewModel.booking?.ratingName.description else {
            return ""
        }
        return "\(valueDesc) \(nameDesc)"
    }
    
    var bookingOrderHotelInfo: some View {
        VStack(alignment: .leading, spacing: 0) {
            bookingHotelInfo
            hotelNameTextStyle
            hotelAddressTextStyle
        }
        .background(Color.white.cornerRadius(15))
    }
    
    var orderInfo: some View {
        VStack(alignment: .leading, spacing: 16) {
            createInfoView(title: "Вылет из", info: bookingViewModel.booking?.departure ?? "Нет данных о вылете")
            createInfoView(title: "Страна, город", info: bookingViewModel.booking?.arrivalCountry ?? "Нет данных о Страна, город")
            createInfoView(title: "Даты", info: getInfoOfDates())
            createInfoView(title: "Кол-во ночей", info: getNumberOfNights() )
            createInfoView(title: "Отель", info: hotelName)
            createInfoView(title: "Номер", info: bookingViewModel.booking?.room ?? "Нет данных о Номер")
            createInfoView(title: "Питание", info: bookingViewModel.booking?.nutrition ?? "Нет данных о Питание")
        }
        .padding([.leading, .trailing, .top, .bottom], 16)
        .background(Color.white.cornerRadius(15))
    }
    
    func toPay() -> Int {
        let tourPrice = bookingViewModel.booking?.tourPrice
        let fuelCharge = bookingViewModel.booking?.fuelCharge
        let serviceCharge = bookingViewModel.booking?.serviceCharge
        
        guard let unwrappedValue1 = tourPrice,
              let unwrappedValue2 = fuelCharge,
              let unwrappedValue3 = serviceCharge else {
            return 0
        }
        let sum = unwrappedValue1 + unwrappedValue2 + unwrappedValue3
        return sum
    }
    
    var paymentInformation: some View {
        VStack(alignment: .leading, spacing: 16) {
            createPaymentInfoView(title: "Тур", info: formatPricePayment(bookingViewModel.booking?.tourPrice ?? 0), color: .black)
            createPaymentInfoView(title: "Топливный сбор", info: formatPricePayment(bookingViewModel.booking?.fuelCharge ?? 0), color: .black)
            createPaymentInfoView(title: "Сервисный сбор", info: formatPricePayment(bookingViewModel.booking?.serviceCharge ?? 0), color: .black)
            createPaymentInfoView(title: "К оплате", info: formatPricePayment(toPay()), color: Color(UIColor(red: 0.051, green: 0.447, blue: 1, alpha: 1)))
            
        }
        .padding([.leading, .trailing, .top, .bottom], 16)
        .background(Color.white.cornerRadius(15))
    }
    
    // MARK: - Hotel Name Section
    
    // Эта секция отображает имя отеля
    var hotelNameTextStyle: some View {
        Text(hotelName)
            .font(.system(size: 22, weight: .medium))
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 8)
            .padding(.horizontal, 16)
    }
    
    // MARK: - Hotel Address Section
    
    // Эта секция отображает адрес отеля
    var hotelAddressTextStyle: some View {
        Text(hotelAddress)
            .foregroundColor(Color(UIColor(red: 0, green: 0, blue: 0, alpha: 1)))
            .foregroundColor(Color(UIColor(red: 0.051, green: 0.447, blue: 1, alpha: 1)))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.horizontal, .bottom], 16)
            .padding(.top, 8)
    }
    
    // Это вычисляемое свойство возвращает имя отеля.
    // Он использует адрес, чтобы получить первую часть,
    // но если адрес отсутствует, то вернет пустую строку.
    var hotelName: String {
        if let address = hotelViewModel.hotel?.address.description {
            let components = address.components(separatedBy: ",")
            if let firstPart = components.first {
                return firstPart.trimmingCharacters(in: .whitespaces)
            }
        }
        return ""
    }
    
    // Это вычисляемое свойство возвращает адрес отеля.
    // Если адрес отсутствует, вернет пустую строку.
    var hotelAddress: String {
        return bookingViewModel.booking?.hotelAddress.description ?? ""
    }
    
    func createInfoView(title: String, info: String) -> some View {
        return HStack {
            Text(title)
                .frame(width: 117, alignment: .leading)
                .foregroundColor(Color(UIColor(red: 0.51, green: 0.529, blue: 0.588, alpha: 1)))
            Text(info)
                .padding(.leading, 26)
                .frame(alignment: .leading)
                .foregroundColor(Color(UIColor(red: 0, green: 0, blue: 0, alpha: 1)))
                .lineLimit(nil)  // Это позволяет тексту переноситься на новые строки
        }
        .font(.system(size: 16, weight: .regular))
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func createPaymentInfoView(title: String, info: String, color: Color) -> some View {
        return HStack {
            Text(title)
                .frame(alignment: .leading)
                .foregroundColor(Color(UIColor(red: 0.51, green: 0.529, blue: 0.588, alpha: 1)))
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(info)
            //                .padding(.trailing, 15)
                .frame(alignment: .trailing)
                .foregroundColor(color)
        }
        .font(.system(size: 16, weight: .regular))
    }
    
    var userInputSection: some View {
        VStack {
            TextFieldView(viewModel: bookingViewModel.phoneViewModel, placeholder: "Номер телефона", placeholderText: "Введите номер телефона", text: $phoneText, keyboardType: .numberPad)
            
            TextFieldView(viewModel: bookingViewModel.emailViewModel, placeholder: "Почта", placeholderText: "Введите вашу почту", text: $emailText, keyboardType: .emailAddress)
            
            Text("Эти данные никому не передаются. После оплаты мы вышли чек на указанный вами номер и почту")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(Color(UIColor(red: 0.51, green: 0.529, blue: 0.588, alpha: 1)))
        }
        .padding()
        .background(Color.white.cornerRadius(15))
    }
    
    func getNumberOfNights() -> String {
        guard let numberOfNights = bookingViewModel.booking?.numberOfNights else { return "Нет данных о Кол-во ночей"}
        return "\(numberOfNights) ночей"
    }
    
    func getInfoOfDates() -> String {
        guard let start = bookingViewModel.booking?.tourStartDate,
              let end = bookingViewModel.booking?.tourEndDate
        else { return "Нет данных о датах"}
        return "\(start) — \(end)"
    }
    
    func customSquareView(imageName: String, squareColor: Color) -> some View {
        return ZStack {
            squareColor
            
            Image(systemName: imageName)
                .foregroundColor(Color(UIColor(red: 0.051, green: 0.447, blue: 1, alpha: 1)))
        }
        .frame(width: 32, height: 32)
        .cornerRadius(5)
    }
    func initTouristInfoDataViewModels() {
        touristInfoDataViewModels = [
            TouristInfoDataViewModel(buttonText: "Первый турист", isEditingTextField: $isEditingTextField),
            TouristInfoDataViewModel(buttonText: "Второй турист", isEditingTextField: $isEditingTextField)
        ]
    }
    // Этот метод форматирует цену отеля, добавляя разделители тысяч и символ "₽"
    private func formatPrice(_ price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.locale = Locale(identifier: "ru_RU")
        
        if let formattedPrice = formatter.string(from: NSNumber(value: price)) {
            return "Оплатить \(formattedPrice) ₽"
        } else {
            return "Оплатить \(price) ₽" // Возвращаем цену без форматирования, если форматирование не удалось
        }
    }
    
    private func formatPricePayment(_ price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.locale = Locale(identifier: "ru_RU")
        
        if let formattedPrice = formatter.string(from: NSNumber(value: price)) {
            return "\(formattedPrice) ₽"
        } else {
            return "\(price) ₽" // Возвращаем цену без форматирования, если форматирование не удалось
        }
    }
}

struct BookingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview with a larger frame
            BookingView()
        }
    }
}


