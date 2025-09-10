//
//  HTTextField.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/7/25.
//

import SwiftUI

struct HTTextField<T: LosslessStringConvertible>: View {
    let title: String
    @Binding var value: T
    var isDisabled: Bool = false
    var keyboardType: UIKeyboardType = .default
    
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
                .disabled(isDisabled)
                .keyboardType(keyboardType)
                .multilineTextAlignment(.center)
                .font(.HTBody20)
                .tint(.htGreen)
                .background(.htGray2)
                .appCornerRadius()
                
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
            HTTextField(title: "BILL AMOUNT", value: $previewName)

            // Preview with Int
            HTTextField(title: "TIP AMOUNT", value: $previewAge)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

#Preview {
    HTTextField_Previews.previews
}
