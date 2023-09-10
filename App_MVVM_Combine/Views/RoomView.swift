import SwiftUI

// MARK: - RoomView

struct RoomView: View {
    // MARK: - Environment and Observed Objects
    
    @EnvironmentObject var roomCoordinator: AppCoordinator
    @ObservedObject var roomViewModel: RoomViewModel = RoomViewModel()
    @ObservedObject var hotelViewModel: HotelViewModel = HotelViewModel()
    @State private var dataLoaded = false
    private let blueChevron = Image("blueChevron")
    private let chevronLeft = Image("chevronLeft")
    
    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
                    VStack(spacing: 8) { // Отступы между ячейками
                        if let rooms = roomViewModel.rooms {
                            let uniqueRooms = Array(Set(rooms)).sorted(by: { $0.id < $1.id })
                            
                            ForEach(uniqueRooms, id: \.id) { room in
                                VStack {
                                    TabbedScrollView(cachedImages: room.cachedImages)
                                    hotelDescriptionView(hotelDescription: room.name)
                                    HotelPeculiaritiesView(peculiarities: room.peculiarities)
                                    moreAboutHotelRoom
                                    priceDetailsView(price: room.price, comments: room.pricePer)
                                    selectRoomButton
                                }
                                .onAppear {
                                    roomViewModel.fetchRoomData()
                                    roomViewModel.loadImages() // Загрузка и кэширование изображений
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        dataLoaded = true
                                    }
                                }
                                .background(Color.white.cornerRadius(15))
                            }
                        }
                    }
                }
                .background(Color(UIColor(red: 0.965, green: 0.965, blue: 0.976, alpha: 1)))
                .toolbar {
                    ToolbarItem(placement: .principal) {
                            Text(hotelName)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            roomCoordinator.resetSelections()
                        }, label: {
                            chevronLeft
                                .foregroundColor(.black)
                                .frame(alignment: .leading)
                                .frame(width: 22)
                        })
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.white, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
            }
        }
    }
}

extension RoomView {
    // MARK: Hotel Name
    
    /// Возвращает имя отеля на основе адреса отеля.
    private var hotelName: String {
        if let address = hotelViewModel.hotel?.address.description {
            let components = address.components(separatedBy: ",")
            if let firstPart = components.first {
                return firstPart.trimmingCharacters(in: .whitespaces)
            }
        }
        return ""
    }
    
    // MARK: Room Cell Creation
    
    /// Создает представление для комнаты.
    ///
    /// - Parameter room: Модель комнаты.
    /// - Returns: Представление комнаты.
    private func createRoomCell(room: Room) -> some View {
        return VStack {
            TabbedScrollView(cachedImages: room.cachedImages)
            hotelDescriptionView(hotelDescription: room.name)
            HotelPeculiaritiesView(peculiarities: room.peculiarities)
            moreAboutHotelRoom
            priceDetailsView(price: room.price, comments: room.pricePer)
            selectRoomButton
        }
        .background(Color.white.cornerRadius(15))
    }
    
    // MARK: Price Details
    
    /// Создает представление для отображения цены и комментариев.
    ///
    /// - Parameters:
    ///   - price: Цена комнаты.
    ///   - comments: Комментарии к цене.
    /// - Returns: Представление цены и комментариев.
    private func priceDetailsView(price: Int, comments: String) -> some View {
        let formattedPrice = formatPrice(price)
        return HStack {
            Text(formattedPrice)
                .font(.system(size: 30, weight: .semibold))
                .foregroundColor(.black)
                .padding(.leading, 16)
            
            Text(comments)
                .foregroundColor(Color(UIColor(red: 0.51, green: 0.529, blue: 0.588, alpha: 1)))
                .font(.system(size: 15, weight: .regular))
                .padding(.leading, 8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 16)
    }
    
    /// Форматирует цену, добавляя разделитель групп разрядов и символ валюты.
    ///
    /// - Parameter price: Неформатированная цена.
    /// - Returns: Отформатированная цена в формате "123 456 ₽".
    private func formatPrice(_ price: Int) -> String {
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
    
    // MARK: Hotel Description
    
    /// Создает представление для отображения описания отеля.
    ///
    /// - Parameter hotelDescription: Описание отеля.
    /// - Returns: Представление описания отеля.
    private func hotelDescriptionView(hotelDescription: String) -> some View {
        return Text(hotelDescription)
            .font(.system(size: 22, weight: .medium))
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 8)
            .padding(.horizontal, 16)
    }
    
    // MARK: More About Hotel Room Button
    
    /// Создает представление кнопки "Подробнее о номере".
    private var moreAboutHotelRoom: some View {
        return Button(action: {
            // Ваше действие при нажатии на кнопку
        }) {
            HStack(spacing: 2) {
                Text("Подробнее о номере")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(UIColor(red: 0.051, green: 0.447, blue: 1, alpha: 1)))
                    .padding(.leading, 10)
                    .padding([.top, .bottom], 5)
                    .cornerRadius(10)
                
                blueChevron
                    .frame(width: 24)
                    .foregroundColor(Color(UIColor(red: 0.051, green: 0.447, blue: 1, alpha: 1)))
                    .font(.system(size: 18, weight: .bold))
                    .padding(.trailing, 2)
            }
            .background(Color(UIColor(red: 0.051, green: 0.447, blue: 1, alpha: 0.1)))
            .cornerRadius(5)
        }
        .padding(.top, 8)
        .padding(.leading, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: Select Room Button
    
    /// Создает представление кнопки "Выбрать номер".
    private var selectRoomButton: some View {
        return Button(action: { roomCoordinator.resetSelections(); roomCoordinator.navigateToBookingView()  }) {
            Text("Выбрать номер")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .padding(.vertical, 15) // Отступы сверху и снизу
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .background(Color(UIColor(red: 0.051, green: 0.447, blue: 1, alpha: 1)))
        .cornerRadius(15) // Устанавливаем скругление углов кнопки
        .padding([.horizontal, .bottom], 16) // Отступы слева и справа
    }
}
// MARK: - Previews

struct RoomView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview with a larger frame
            HotelView()
            RoomView()
        }
    }
}
