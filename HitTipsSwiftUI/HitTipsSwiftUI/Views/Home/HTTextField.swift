//
//  HTTextField.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/7/25.
//

import SwiftUI

enum HTField: Hashable {
    case field1
    case field2
    case field3
}

struct HTTextField<T: LosslessStringConvertible>: View {
    let title: String
    @Binding var value: T
    var keyboardType: UIKeyboardType = .default
    @FocusState var focusedField: HTField?  // external focus binding
    let fieldID: HTField
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                TextField("", text: Binding(
                    get: { String(value) },
                    set: {
                        if let newValue = T($0) {
                            value = newValue
                        }
                    }
                ))
                .frame(height: 40)
                .keyboardType(keyboardType)
                .multilineTextAlignment(.center)
                .font(.HTBody20)
                .tint(.htGreen)
                .background(.htGray)
                .clipShape(.capsule)
                .focused($focusedField, equals: fieldID)
                .onChange(of: focusedField) { newFocus in
                    if newFocus == fieldID {
                        // Clear value when this field becomes focused
                        if let emptyValue = T("") {
                            value = emptyValue
                        }
                    }
                }
                
                Spacer()
            }
            
            Text(title)
                .font(.HTBody12)
        }
    }
}

struct HTTextField_Previews: PreviewProvider {
    @State static var previewName: String = "0.00"
    @State static var previewAge: Int = 30

    static var previews: some View {
        VStack(spacing: 20) {
            // Preview with String
            HTTextField(title: "BILL AMOUNT", value: $previewName, fieldID: .field1)

            // Preview with Int
            HTTextField(title: "TIP AMOUNT", value: $previewAge, keyboardType: .numberPad, fieldID: .field2)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

#Preview {
    HTTextField_Previews.previews
}
