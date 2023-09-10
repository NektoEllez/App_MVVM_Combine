//
//  TouristInfoDataViewModel.swift
//  App_MVVM_Combine
//
//  Created by Иван Марин on 08.09.2023.
//

import SwiftUI

/**
 Модель `TouristInfoDataViewModel` отвечает за управление данными о туристах в бронировании.
 
 Эта модель используется для управления данными о туристах, и она включает в себя функции валидации, проверки готовности данных, а также управление состоянием отображения информации о туристе.
 */
class TouristInfoDataViewModel: ObservableObject {
    // MARK: - Свойства
    
    // Модели для текстовых полей ввода email и номера телефона
    @ObservedObject var emailViewModel = TextFieldViewModel(keyboardType: .emailAddress)
    @ObservedObject var phoneViewModel = TextFieldViewModel(keyboardType: .numberPad)
    
    // Флаг, указывающий на состояние отображения информации о туристе (раскрыто/свернуто)
    @Published var isExpanded = false
    
    // Флаг, указывающий на возможность удаления информации о туристе
    @Published var isRemovable = false
//    @Published var areAllFieldsValid: Bool = false
    
    // Текст кнопки для управления информацией о туристе
    @Published var buttonText: String = "Дополнительный турист" // Название кнопки
    
    // Свойства для хранения данных о туристе
    @Published var firstName  = "Введите Ваше имя"
    @Published var lastName  =  "Введите Вашу фамилию"
    @Published var dateOfBirth  =  "Введите Вашу дату рождения"
    @Published var citizenship =  "Введите Ваше гражданство"
    @Published var passportNumber =  "Введите Ваш номер загранпаспорта"
    @Published var passportExpiryDate =  "Введите дату окончания загранпаспорта"
    
    // Модели текстовых полей, связанных с соответствующими данными туристов
    @Published var firstNameViewModel: TextFieldViewModel
    @Published var lastNameViewModel: TextFieldViewModel
    @Published var dateOfBirthViewModel: TextFieldViewModel
    @Published var citizenshipViewModel: TextFieldViewModel
    @Published var passportNumberViewModel: TextFieldViewModel
    @Published var passportExpiryDateViewModel: TextFieldViewModel
    
    // Флаг, указывающий на готовность всех полей данных для отправки
    @Published var isDataComplete: Bool = false
   
    // Свойство для отслеживания состояния редактирования текстовых полей
    @Binding var isEditingTextField: Bool // Свойство для отслеживания состояния редактирования
    
    // Флаги ошибок для каждого поля данных
    @Published var firstNameError: Bool = false
    @Published var lastNameError: Bool = false
    @Published var dateOfBirthError: Bool = false
    @Published var citizenshipError: Bool = false
    @Published var passportNumberError: Bool = false
    @Published var passportExpiryDateError: Bool = false
    
    @Published var id = UUID()
    
    // MARK: - Инициализация
    
    /**
     Инициализатор модели `TouristInfoDataViewModel`.
     
     - Parameters:
       - buttonText: Текст кнопки для управления информацией о туристе.
       - isEditingTextField: Связь для отслеживания состояния редактирования текстовых полей.
     */
    init(buttonText: String = "Дополнительный турист", isEditingTextField: Binding<Bool>) {
        self.buttonText = buttonText
        self._isEditingTextField = isEditingTextField // Привяжите isEditingTextField
        
        // Инициализируем ViewModel без передачи методов валидации для текстовых полей
        self.firstNameViewModel = TextFieldViewModel(keyboardType: .default)
        self.lastNameViewModel = TextFieldViewModel(keyboardType: .default)
        self.dateOfBirthViewModel = TextFieldViewModel(keyboardType: .default)
        self.citizenshipViewModel = TextFieldViewModel(keyboardType: .default)
        self.passportNumberViewModel = TextFieldViewModel(keyboardType: .default)
        self.passportExpiryDateViewModel = TextFieldViewModel(keyboardType: .default)
        
        // Установите функции валидации для соответствующих полей данных
        self.firstNameViewModel.validationFunction = isValidName
        self.lastNameViewModel.validationFunction = isValidName
        self.dateOfBirthViewModel.validationFunction = isValidDateFunc
        self.citizenshipViewModel.validationFunction = isValidCitizenship
        self.passportNumberViewModel.validationFunction = isValidPassportNumber
        self.passportExpiryDateViewModel.validationFunction = isValidDateFunc
    }
    
    // MARK: - Методы
    
    /**
     Проверяем действительность имени или фамилии на основе регулярного выражения.
     
     - Parameter text: Текст для проверки.
     - Returns: `true`, если текст соответствует регулярному выражению, в противном случае `false`.
     */
    func isValidName(_ text: String) -> Bool {
        let nameRegEx = "^[А-ЯA-Zа-яa-z]+$"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegEx)
        let isValid = nameTest.evaluate(with: text)
        
        if !isValid {
            print("Invalid name: \(text)")
        }
        
        // Здесь устанавливаем флаг ошибки
        firstNameError = !isValid

        return isValid
    }

    /**
     Проверяем  действительность даты на основе регулярного выражения.
     
     - Parameter text: Текст для проверки.
     - Returns: `true`, если текст соответствует регулярному выражению, в противном случае `false`.
     */
    func isValidDateFunc(_ text: String) -> Bool {
        let dateRegEx = "^\\d{2}\\.\\d{2}\\.\\d{4}$"
        let dateTest = NSPredicate(format: "SELF MATCHES %@", dateRegEx)
        return dateTest.evaluate(with: text)
    }

    /**
     Проверяем действительность номера заграничного паспорта на основе регулярного выражения.
     
     - Parameter text: Текст для проверки.
     - Returns: `true`, если текст соответствует регулярному выражению, в противном случае `false`.
     */
    func isValidPassportNumber(_ text: String) -> Bool {
        let numberRegEx = "^[0-9]+$"
        let numberTest = NSPredicate(format: "SELF MATCHES %@", numberRegEx)
        return numberTest.evaluate(with: text)
    }

    /**
     Проверяем действительность гражданства на основе регулярного выражения.
     
     - Parameter text: Текст для проверки.
     - Returns: `true`, если текст соответствует регулярному выражению и не равен "Введите Ваше гражданство", в противном случае `false`.
     */
    func isValidCitizenship(_ text: String) -> Bool {
        let citizenshipRegEx = "^[a-zA-Zа-яА-Я\\s]+$"
        let citizenshipTest = NSPredicate(format: "SELF MATCHES %@", citizenshipRegEx)
        return citizenshipTest.evaluate(with: text) && text != "Введите Ваше гражданство"
    }
    
    /**
     Проверяем действительность всех полей данных и устанавливает соответствующие флаги ошибок.
     */
    func checkDataCompleteness() {
        firstNameError = !isValidName(firstName)
        lastNameError = !isValidName(lastName)
        dateOfBirthError = !isValidDateFunc(dateOfBirth)
        citizenshipError = !isValidCitizenship(citizenship)
        passportNumberError = !isValidPassportNumber(passportNumber)
        passportExpiryDateError = !isValidDateFunc(passportExpiryDate)
        
        isDataComplete = !firstNameError && !lastNameError && !dateOfBirthError && !citizenshipError && !passportNumberError && !passportExpiryDateError
        
        print("Data Completeness Check:")
        print("firstNameError: \(firstNameError)")
        print("lastNameError: \(lastNameError)")
        print("dateOfBirthError: \(dateOfBirthError)")
        print("citizenshipError: \(citizenshipError)")
        print("passportNumberError: \(passportNumberError)")
        print("passportExpiryDateError: \(passportExpiryDateError)")
        print("isDataComplete: \(isDataComplete)")
    }
    
    /**
     Проверяем, являются ли все поля данных действительными.
     
     - Returns: `true`, если все поля данных действительны, в противном случае `false`.
     */
    func areAllFieldsValid() -> Bool {
        let firstNameValid = isValidName(firstName)
        let lastNameValid = isValidName(lastName)
        let dateOfBirthValid = isValidDateFunc(dateOfBirth)
        let citizenshipValid = isValidCitizenship(citizenship)
        let passportNumberValid = isValidPassportNumber(passportNumber)
        let passportExpiryDateValid = isValidDateFunc(passportExpiryDate)
        
        print("Field Validation Check:")
        print("firstNameValid: \(firstNameValid)")
        print("lastNameValid: \(lastNameValid)")
        print("dateOfBirthValid: \(dateOfBirthValid)")
        print("citizenshipValid: \(citizenshipValid)")
        print("passportNumberValid: \(passportNumberValid)")
        print("passportExpiryDateValid: \(passportExpiryDateValid)")
        
        return firstNameValid && lastNameValid && dateOfBirthValid && citizenshipValid && passportNumberValid && passportExpiryDateValid
    }

}
