//
//  TouristInfoView.swift
//  App_MVVM_Combine
//
//  Created by Иван Марин on 08.09.2023.
//

import SwiftUI

struct TouristInfoView: View {
    @Binding var touristInfoDataViewModels: [TouristInfoDataViewModel]
    @EnvironmentObject var bookingViewModel: BookingViewModel
    @EnvironmentObject var touristInfoCoordinator: AppCoordinator
    @ObservedObject var data: TouristInfoDataViewModel
    @State private var isExpanded: Bool = false
    @State private var isEditingTextField: Bool = false
    
    var body: some View {
        ZStack {
            HStack {
                CustomDisclosureGroup(
                    animation: .easeInOut(duration: 0.2),
                    isExpanded: Binding(
                        get: { data.isExpanded },
                        set: { newValue in
                            if !isEditingTextField {
                                data.isExpanded = newValue
                            }
                        }
                    )
                ) {
                    data.isExpanded.toggle()
                } prompt: {
                    HStack {
                        Button(action: {
                            data.isRemovable.toggle()
                        }) {
                            Text(data.buttonText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.primary)
                                .font(.headline)
                        }
                        Spacer()
                        customSquareView(imageName: isExpanded ? "chevron.up" : "chevron.down", squareColor: Color(UIColor(red: 0.051, green: 0.447, blue: 1, alpha: 0.1)))
                            .onTapGesture {
                                isExpanded.toggle()
                                data.isExpanded.toggle()
//                                self.bookingViewModel.isTouristInfoViewExpanded = self.isExpanded
                            }
                            .animation(.default, value: data.isExpanded)
                    }
                } expandedView: {
                    VStack {
                        TextFieldView(viewModel: data.firstNameViewModel, placeholder: "Имя", placeholderText: "Введите Ваше имя", text: $data.firstName, keyboardType: .default)
                            .padding(.top, 16)
                            .onTapGesture { isEditingTextField = true }
                            .onSubmit { isEditingTextField = false }
                            .onChange(of: data.firstName) { newValue in
                                let areAllFieldsValid = data.areAllFieldsValid()
                                // Здесь обновите свойство, которое контролирует возможность перехода
                            }
                        
                        TextFieldView(viewModel: data.lastNameViewModel, placeholder: "Фамилия", placeholderText: "Введите вашу фамилию", text: $data.lastName, keyboardType: .default)
                            .onTapGesture { isEditingTextField = true }
                            .onSubmit { isEditingTextField = false }
                            .onChange(of: data.lastName) { newValue in
                                let areAllFieldsValid = data.areAllFieldsValid()
                                // Здесь обновите свойство, которое контролирует возможность перехода
                            }
                        TextFieldView(viewModel: data.dateOfBirthViewModel, placeholder: "Дата рождения", placeholderText: "Введите вашу дату рождения", text: $data.dateOfBirth, keyboardType: .default)
                            .onTapGesture { isEditingTextField = true }
                            .onSubmit { isEditingTextField = false }
                            .onChange(of: data.dateOfBirth) { newValue in
                                let areAllFieldsValid = data.areAllFieldsValid()
                                // Здесь обновите свойство, которое контролирует возможность перехода
                            }
                        TextFieldView(viewModel: data.citizenshipViewModel, placeholder: "Гражданство", placeholderText: "Введите ваше гражданство", text: $data.citizenship, keyboardType: .default)
                            .onTapGesture { isEditingTextField = true }
                            .onSubmit { isEditingTextField = false }
                            .onChange(of: data.citizenship) { newValue in
                                let areAllFieldsValid = data.areAllFieldsValid()
                                // Здесь обновите свойство, которое контролирует возможность перехода
                            }
                        TextFieldView(viewModel: data.passportNumberViewModel, placeholder: "Номер загранпаспорта", placeholderText: "Введите номер загранпаспорта", text: $data.passportNumber, keyboardType: .default)
                            .onTapGesture { isEditingTextField = true }
                            .onSubmit { isEditingTextField = false }
                            .onChange(of: data.passportNumber) { newValue in
                                let areAllFieldsValid = data.areAllFieldsValid()
                                // Здесь обновите свойство, которое контролирует возможность перехода
                            }
                        TextFieldView(viewModel: data.passportExpiryDateViewModel, placeholder: "Дата окончания загранпаспорта", placeholderText: "Введите дату окончания загранпаспорта", text: $data.passportExpiryDate, keyboardType: .default)
                            .onTapGesture { isEditingTextField = true }
                            .onSubmit { isEditingTextField = false }
                            .onChange(of: data.passportExpiryDate) { newValue in
                                let areAllFieldsValid = data.areAllFieldsValid()
                                // Здесь обновите свойство, которое контролирует возможность перехода
                            }
                    }
                }
            }
        }
        .onDisappear {
            if data.isRemovable {
                if let index = touristInfoDataViewModels.firstIndex(where: { $0.id == data.id }) {
                    touristInfoDataViewModels.remove(at: index)
                }
            }
        }
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
}
