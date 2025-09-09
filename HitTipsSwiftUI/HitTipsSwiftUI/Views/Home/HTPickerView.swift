//
//  HTPickerView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/8/25.
//

import SwiftUI

struct HTPickerView: View {
    @State private var selectedNumber: Int
    @State private var textFieldValue: String
    @State private var oldTextFieldValue: String
    @FocusState private var isTextFieldFocused: Bool
    
    let upperLimit: Int
    let icon: String
    let iconLeading: Bool
    
    private var numbers: [Int] { Array(1...upperLimit).reversed() }
    
    init(upperLimit: Int, icon: String, iconLeading: Bool, initialValue: Int = 1) {
        self.upperLimit = upperLimit
        self.icon = icon
        self.iconLeading = iconLeading
        _selectedNumber = State(initialValue: initialValue)
        _textFieldValue = State(initialValue: "\(initialValue)")
        _oldTextFieldValue = State(initialValue: "\(initialValue)")
    }
    
    var body: some View {
        VStack {
            Picker("Select a number", selection: $selectedNumber) {
                ForEach(numbers, id: \.self) { number in
                    Text("\(number)").tag(number)
                        .font(.HTBody20)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 100)
            .onChange(of: selectedNumber) { newValue in
                textFieldValue = "\(newValue)"
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
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
                    .background(.htGray)
                    .tint(.htGreen)
                    .clipShape(.capsule)
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
                        if let number = Int(newValue), number >= 1, number <= upperLimit {
                            selectedNumber = number
                        }
                    }
                
                if !iconLeading {
                    Image(systemName: icon)
                        .padding(.horizontal, -6)
                }
            }
        }
        .padding()
    }
}


#Preview {
    HStack {
        HTPickerView(upperLimit: 20, icon: "person.2.fill", iconLeading: true)
        HTPickerView(upperLimit: 40, icon: "percent", iconLeading: false)
    }
}
