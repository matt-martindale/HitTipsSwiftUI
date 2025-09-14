//
//  BillOutputView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/9/25.
//

import SwiftUI

enum ButtonAction {
    case roundUp
    case roundDown
}

struct BillOutputView: View {
    @Binding var tipPerPerson: Double
    @Binding var pricePerPerson: Double
    @Binding var totalBill: Double
    
    var onAction: ((ButtonAction) -> Void)?
    
    var body: some View {
        HStack {
            VStack(spacing: 8) {
                // Tip / Price per person
                HStack(spacing: 16) {
                    AnimatedNumberView(value: tipPerPerson, title: UIStrings.tipPerPersonCap)
                    AnimatedNumberView(value: pricePerPerson, title: UIStrings.pricePerPersonCap)
                }
                
                // Total and rounding buttons
                HStack(spacing: 8) {
                    AnimatedNumberView(value: totalBill, title: UIStrings.totalBillCap)
                    
                    VStack(spacing: 4) {
                        Button {
                            onAction?(.roundUp)
                        } label: {
                            Image(systemName: "arrow.up.square")
                                .font(.HTBody30)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(Color(.label), .htGreen)
                        }
                        Button {
                            onAction?(.roundDown)
                        } label: {
                            Image(systemName: "arrow.down.square")
                                .font(.HTBody30)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(Color(.label), .htRed)
                        }
                    }
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            .background(.htGray2)
            .appCornerRadius()
        }
    }
}

/// Animatable numeric display
struct AnimatedNumberView: View {
    var value: Double
    var title: String
    var hasBackground: Bool = true
    
    @State private var displayedValue: Double = 0.0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(String(format: "%.2f", displayedValue))
                .frame(maxWidth: .infinity)
                .font(.HTMono20)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(hasBackground ? .htGray : .htGray2)
                .appCornerRadius()
                .onChange(of: value) { newValue in
                    animateValueChange(to: newValue)
                }
            Text(title)
                .frame(maxWidth: .infinity)
                .padding(4)
                .font(.HTBody12)
        }
        .frame(minWidth: 80)
        .background(hasBackground ? .htGray2 : .clear)
        .appCornerRadius()
        .onAppear {
            displayedValue = value
        }
    }
    
    private func animateValueChange(to newValue: Double) {
        // Use a timer to increment or decrement displayedValue gradually
        let duration: Double = 0.3
        let steps: Int = 30
        let current = displayedValue
        let delta = (newValue - current) / Double(steps)
        var stepCount = 0
        
        Timer.scheduledTimer(withTimeInterval: duration / Double(steps), repeats: true) { timer in
            stepCount += 1
            displayedValue += delta
            if stepCount >= steps {
                displayedValue = newValue
                timer.invalidate()
            }
        }
    }
}


#Preview {
    BillOutputView(tipPerPerson: .constant(12.34), pricePerPerson: .constant(98.76), totalBill: .constant(123.45))
    AnimatedNumberView(value: 3.4, title: "Value", hasBackground: false)
}
