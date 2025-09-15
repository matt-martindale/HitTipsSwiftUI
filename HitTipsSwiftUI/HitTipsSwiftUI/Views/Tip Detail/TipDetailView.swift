//
//  TipDetailView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/12/25.
//

import SwiftUI

struct TipDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable private var tip: Tip
    @State private var animateHeart: Bool = false

    init(tip: Tip) {
        self._tip = Bindable(wrappedValue: tip)
    }

    var body: some View {
        VStack(spacing: 16) {
            // Top buttons
            HStack {
                Spacer()
                HStack(spacing: 8) {
                    // Favorite button
                    Button {
                        favoriteTapped()
                    } label: {
                        Image(systemName: tip.isFavorite ? "heart.fill" : "heart")
                            .foregroundStyle(.htRed)
                            .font(.HTBody22)
                            .scaleEffect(animateHeart ? 1.4 : 1)
                            .opacity(tip.isFavorite ? 1 : 0.5)
                            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: animateHeart)
                    }

                    // Share button
                    Button {
                        shareTapped()
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .tint(.primary)
                            .font(.HTBody20)
                            .offset(y: -3)
                    }
                }
                .padding(6)
                .padding(.horizontal, 4)
                .background(.htGray)
                .appCornerRadius()
            }
            .padding(.top)

            // Scrollable roast text
            ScrollView {
                Text(tip.roast)
                    .padding()
                    .font(.HTBody24)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxHeight: 300) // adjust height for your UI

            // Receipt rows
            VStack(spacing: 8) {
                ReceiptRow(title: UIStrings.billAmountLowercase, value: "$\(tip.billAmount)")
                ReceiptRow(title: UIStrings.tipAmountLowercase, value: "$\(String(format: "%.2f", tip.tipAmount))")
                ReceiptRow(title: UIStrings.tipPercentLowercase, value: "\(tip.tipPercentage)%")
                ReceiptRow(title: UIStrings.partyLowercase, value: "\(tip.party)")
                ReceiptRow(title: UIStrings.tipPerPersonLowercase, value: "$\(String(format: "%.2f", tip.tipPerPerson))")
                ReceiptRow(title: UIStrings.pricePerPersonLowercase, value: "$\(String(format: "%.2f", tip.pricePerPerson))")
                ReceiptRow(title: UIStrings.totalBillCap, value: "$\(String(format: "%.2f", tip.totalBill))", isHighlight: true)
            }
            .padding(.bottom, 20)

            Spacer()
        }
        .padding()
        .background(
            Image("HitTipsLogoTransparent")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .rotationEffect(.degrees(15))
                .opacity(0.05)
                .ignoresSafeArea()
        )
    }

    // MARK: - Actions

    private func favoriteTapped() {
        tip.isFavorite.toggle()

        withAnimation {
            animateHeart = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                animateHeart = false
            }
        }

        do {
            try modelContext.save()
        } catch {
            print("Failed to save tip: \(error.localizedDescription)")
        }
    }

    private func shareTapped() {
        let hostingController = UIHostingController(rootView: self)
        hostingController.view.bounds = UIScreen.main.bounds
        hostingController.view.backgroundColor = UIColor.systemBackground

        let renderer = UIGraphicsImageRenderer(size: hostingController.view.bounds.size)
        let image = renderer.image { _ in
            hostingController.view.drawHierarchy(in: hostingController.view.bounds, afterScreenUpdates: true)
        }

        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)

        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = scene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}

#Preview {
    TipDetailView(
        tip: Tip(
            roast: "That tip was so small, it could fit in a fortune cookie and still leave the waiter wondering what he did wrong!",
            billAmount: "100.00",
            totalBill: 110.00,
            party: 2,
            pricePerPerson: 50,
            tipPerPerson: 5.25,
            tipAmount: 10,
            tipPercentage: 10
        )
    )
}
