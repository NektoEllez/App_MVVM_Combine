//
//  TextFieldViewModel.swift
//  App_MVVM_Combine
//
//  Created by Иван Марин on 09.09.2023.
//

import SwiftUI

class TextFieldViewModel: ObservableObject {
    
    @Published var isValidPublisher: Bool = false
    
    @Published var text: String = "" {
        didSet {
            validate()
        }
    }
    
    @Published var isEditing: Bool = false
    @Published var hasBeenEdited: Bool = false
    
    @Published var isValid: Bool = false {
        didSet {
            updateBackgroundColor()
            isValidPublisher = isValid
            print("IsValid property did set with value: \(isValid)")
        }
    }
    
    
    var placeholderText: String
    var keyboardType: UIKeyboardType = .default
    var validationFunction: ((String) -> Bool)?
    
    private let maxPhoneNumberDigits: Int = 11
    private let digits = "0123456789"
    private let maxDateCharacters: Int = 10
    private let dateMaskCharacters: [Int: String] = [2: ".", 5: "."]
    private(set) var backgroundColor: Color = Color(UIColor(red: 0.965, green: 0.965, blue: 0.976, alpha: 1))
    
    
    @Published var dateOfBirth: String = "Введите Вашу дату рождения" {
        didSet {
            dateOfBirth = applyDateMask(to: dateOfBirth)
        }
    }
    
    @Published var passportExpiryDate: String = "Введите дату окончания загранпаспорта" {
        didSet {
            passportExpiryDate = applyDateMask(to: passportExpiryDate)
        }
    }
    
    @Published var phoneNumber: String = "" {
        didSet {
            formatPhoneNumber(oldValue: oldValue)
            if !phoneNumber.isEmpty {
                isValid = true
            }
        }
    }
    
    private func formatPhoneNumber(oldValue: String) {
        print("Original Value: \(oldValue)")
        
        let digitsCount = phoneNumber.filter { "0123456789".contains($0) }.count
        
        if !phoneNumber.isEmpty {
            if digitsCount > maxPhoneNumberDigits {
                phoneNumber = oldValue
                isValid = false // Устанавливаем isValid в false при превышении максимального количества цифр.
                return
            }
            
            if digitsCount > oldValue.filter({ "0123456789".contains($0) }).count {
                switch digitsCount {
                case 1:
                    phoneNumber = "+7 (\(phoneNumber)"
                case 4:
                    phoneNumber += ") "
                case 7:
                    phoneNumber += "-"
                case 9:
                    phoneNumber += "-"
                default:
                    break
                }
            } else if digitsCount < oldValue.filter({ "0123456789".contains($0) }).count {
                switch digitsCount {
                case 0:
                    phoneNumber = ""
                    isValid = false // Устанавливаем isValid в false, если номер стал пустым.
                case 3:
                    phoneNumber.removeLast(2)
                case 6:
                    phoneNumber.removeLast(2)
                case 9:
                    phoneNumber.removeLast(1)
                case 12:
                    phoneNumber.removeLast(1)
                default:
                    break
                }
            }
        }
        print("New Value: \(phoneNumber)")
    }
    
    
    init(text: String = "", placeholderText: String = "", keyboardType: UIKeyboardType = .default, validationFunction: ((String) -> Bool)? = nil) {
        self.text = text
        self.placeholderText = placeholderText
        self.keyboardType = keyboardType
        self.validationFunction = validationFunction
    }
    
    func validate() {
        print("Validating text: \(text)")
        
        var validationPredicate: NSPredicate?
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        if let customValidationFunction = validationFunction {
            isValid = customValidationFunction(text)
            return
        }
        
        switch keyboardType {
        case .emailAddress:
            print("Using email validation function")
            validationPredicate = NSPredicate(format: "SELF MATCHES %@", emailPattern)
        default:
            print("Using default validation (always true)")
            isValid = true
            return
        }
        
        isValid = validationPredicate?.evaluate(with: text) ?? false
    }

    func textFieldDidBeginEditing() {
        print("Text field did begin editing")
        
        isEditing = true
        hasBeenEdited = true
    }
    
    func textFieldDidEndEditing() {
        print("Text field did end editing")
        
        isEditing = false
    }
    
    
    static func validateEmail(_ email: String) -> Bool {
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailPattern)
        let isValid = emailPredicate.evaluate(with: email)
        
        print("Email validation result: \(isValid) for email: \(email)")
        return isValid
    }
    
    
    static func validatePhoneNumber(_ text: String) -> Bool {
        let phoneNumberPattern = "^\\+7\\s?\\(\\d{3}\\)\\s?\\d{3}-\\d{2}-\\d{2}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneNumberPattern)
        return true
    }
    
    func applyDateMask(to input: String) -> String {
        print("Applying date mask to: \(input)")  // Добавьте эту строку для отладки
        var result = ""
        var cleanInput = input.filter { digits.contains($0) }
        
        print("Clean Input: \(cleanInput)") // Log clean input
        
        if cleanInput.count > maxDateCharacters {
            cleanInput = String(cleanInput.prefix(maxDateCharacters))
        }
        
        for (index, char) in cleanInput.enumerated() {
            if let separator = dateMaskCharacters[index] {
                result.append(separator)
            }
            result.append(char)
        }
        
        print("Result: \(result)") // Log final result
        
        return result
    }
    
    private func updateBackgroundColor() {
        if isValid {
            backgroundColor = Color(UIColor(red: 0.965, green: 0.965, blue: 0.976, alpha: 1))
        } else {
            backgroundColor = Color(red: 0.92, green: 0.34, blue: 0.34, opacity: 0.15)
        }
    }
}
