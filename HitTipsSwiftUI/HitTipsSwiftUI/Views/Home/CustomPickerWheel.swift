//
//  CustomPickerWheel.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/8/25.
//

import SwiftUI

struct CustomPickerWheel: View {
    let numbers: [Int]
    @Binding var selectedNumber: Int
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 10) {
                    ForEach(numbers, id: \.self) { number in
                        Text("\(number)")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedNumber == number ? Color.blue.opacity(0.3) : Color.clear)
                            .cornerRadius(8)
                            .id(number)
                    }
                }
            }
            .onChange(of: selectedNumber) { newValue in
                withAnimation(.easeInOut) {
                    proxy.scrollTo(newValue, anchor: .center)
                }
            }
        }
    }
}
