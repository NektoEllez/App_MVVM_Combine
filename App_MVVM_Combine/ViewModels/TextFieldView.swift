//
//  TextFieldView.swift
//  App_MVVM_Combine
//
//  Created by Иван Марин on 08.09.2023.
//

import SwiftUI

struct TextFieldView: View {
    @ObservedObject var viewModel: TextFieldViewModel
    @EnvironmentObject var bookingViewModel: BookingViewModel

    var placeholder: String
    var placeholderText: String
    var onEditingChanged: ((Bool) -> Void)? = nil
    @Binding var text: String {
        didSet {
            viewModel.validate()
        }
    }
    var keyboardType: UIKeyboardType
    
    @State private var backgroundColor: Color = Color(UIColor(red: 0.965, green: 0.965, blue: 0.976, alpha: 1))
    
    
    init(viewModel: TextFieldViewModel, placeholder: String, placeholderText: String, text: Binding<String>, keyboardType: UIKeyboardType) {
        self.viewModel = viewModel
        self.placeholder = placeholder
        self.placeholderText = placeholderText
        self._text = text
        self.keyboardType = keyboardType
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if viewModel.isEditing || viewModel.hasBeenEdited {
                Text(placeholder)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color(UIColor(red: 0.51, green: 0.529, blue: 0.588, alpha: 1)))
                    .padding(.leading, 16)
            }
            
            TextField(placeholderText, text: getBinding(), onEditingChanged: { isEditing in
                viewModel.isEditing = isEditing
                if isEditing {
                    viewModel.hasBeenEdited = true
                }
                print("Entering validation function block with text: \(viewModel.text)")
                viewModel.validate()
                updateBackgroundColor(isEditing: isEditing)
            })

            .padding(.leading, 16)
            .font(.system(size: 16, weight: .regular))
            .keyboardType(keyboardType)
            .textFieldStyle(.plain)

        }
        .frame(maxWidth: .infinity)
        .frame(height: 52)
        .background(backgroundColor)
        .cornerRadius(10)
    }
}

extension TextFieldView {
    func getBinding() -> Binding<String> {
        return Binding(
            get: {
                if keyboardType == .numberPad {
                    switch placeholderText {
                    case "Введите Вашу дату рождения":
                        return viewModel.dateOfBirth
                    case "Введите дату окончания загранпаспорта":
                        return viewModel.passportExpiryDate
                    default:
                        return viewModel.phoneNumber
                    }
                } else {
                    return viewModel.text
                }
            },
            set: {
                if keyboardType == .numberPad {
                    switch placeholderText {
                    case "Введите Вашу дату рождения":
                        viewModel.dateOfBirth = $0
                    case "Введите дату окончания загранпаспорта":
                        viewModel.passportExpiryDate = $0
                    default:
                        viewModel.phoneNumber = $0
                    }
                } else {
                    viewModel.text = $0
                }
            }
        )
    }

    private func updateBackgroundColor(isEditing: Bool) {
        if !isEditing {
            if viewModel.isValid {
                backgroundColor = Color(UIColor(red: 0.965, green: 0.965, blue: 0.976, alpha: 1))
            } else {
                backgroundColor = Color(red: 0.92, green: 0.34, blue: 0.34, opacity: 0.15)
            }
        }
    }
}
