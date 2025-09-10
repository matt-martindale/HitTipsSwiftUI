//
//  HTPickerView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/8/25.
//

import SwiftUI

struct HTPickerView: View {
    @Binding private var selectedNumber: Int?
    @State private var textFieldValue: String
    @State private var oldTextFieldValue: String
    @FocusState private var isTextFieldFocused: Bool
    
    let upperLimit: Int
    let icon: String
    let iconLeading: Bool
    
    private var numbers: [Int] { Array(1...upperLimit).reversed() }
    
    init(selectedNumber: Binding<Int?>,
         upperLimit: Int,
         icon: String,
         iconLeading: Bool,
         initialValue: Int? = nil) {
        self._selectedNumber = selectedNumber
        self.upperLimit = upperLimit
        self.icon = icon
        self.iconLeading = iconLeading
        
        let initialText = initialValue.map { "\($0)" } ?? ""
        _textFieldValue = State(initialValue: "\(initialText)")
        _oldTextFieldValue = State(initialValue: "\(initialText)")
    }
    
    var body: some View {
        VStack {
            VStack {
                Picker("", selection: $selectedNumber) {
                    Text(" ")
                        .tag(nil as Int?)
                    ForEach(numbers, id: \.self) { number in
                        Text("\(number)")
                            .font(.HTBody20)
                            .tag(number as Int?)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 60, height: 100)
                .onChange(of: selectedNumber) { newValue in
                    if let newValue = newValue {
                        textFieldValue = "\(newValue)"
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                    }
                }
                
                HStack {
                    if iconLeading {
                        Image(systemName: icon)
                            .padding(.horizontal, -6)
                    }
                    TextField("", text: $textFieldValue)
                        .frame(width: 30, height: 40)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(iconLeading ? .leading : .trailing)
                        .padding(.horizontal, 12)
                        .font(.HTBody20)
                        .background(Color(.htGray))
                        .tint(.htGreen)
                        .appCornerRadius()
                        .focused($isTextFieldFocused)
                        .onChange(of: isTextFieldFocused, { oldFocus, newFocus in
                            if newFocus {
                                oldTextFieldValue = textFieldValue
                                textFieldValue = ""
                            } else if oldFocus {
                                if textFieldValue.isEmpty {
                                    textFieldValue = "\(oldTextFieldValue)"
                                }
                            }
                        })
                        .onChange(of: textFieldValue) { newValue in
                            if textFieldValue.count > 2 {
                                textFieldValue = String(textFieldValue.prefix(2))
                            }
                            if let number = Int(newValue) {
                                if number >= 1, number <= upperLimit {
                                    selectedNumber = number
                                } else if number > upperLimit {
                                    selectedNumber = nil
                                }
                            }
                        }
                    
                    if !iconLeading {
                        Image(systemName: icon)
                            .padding(.horizontal, -6)
                    }
                }
            }
            .padding(.bottom, 12)
            .padding(.horizontal, 12)
            .background(.htGray2)
        }
        .appCornerRadius()
    }
}


#Preview {
    HStack {
        HTPickerView(selectedNumber: .constant(15), upperLimit: 20, icon: "person.2.fill", iconLeading: true)
        HTPickerView(selectedNumber: .constant(1), upperLimit: 40, icon: "percent", iconLeading: false)
    }
}
