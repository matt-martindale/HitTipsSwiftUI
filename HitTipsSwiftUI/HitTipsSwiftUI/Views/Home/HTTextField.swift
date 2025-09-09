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
                .keyboardType(keyboardType)
                .multilineTextAlignment(.center)
                .font(.HTBody20)
                .tint(.green)
                .background(.htGray)
                .clipShape(.capsule)
                
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
            HTTextField(title: "TIP AMOUNT", value: $previewAge, keyboardType: .numberPad)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

#Preview {
    HTTextField_Previews.previews
}
