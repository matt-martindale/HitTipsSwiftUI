//
//  TipDetailView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/12/25.
//

import SwiftUI

enum TipDetailEntryPoint {
    case sheet
    case navigation
}

struct TipDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable private var tip: Tip
    @State private var animateHeart: Bool = false
    private let entryPoint: TipDetailEntryPoint
    
    init(tip: Tip, entryPoint: TipDetailEntryPoint = .navigation) {
        self._tip = Bindable(wrappedValue: tip)
        self.entryPoint = entryPoint
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if entryPoint == .sheet {
                // Top buttons when in sheet
                topButtons
                    .padding(.top)
            }
            
            // Scrollable roast text
            ScrollView {
                Text(tip.roast)
                    .padding()
                    .font(.HTBody24)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            .safeAreaInset(edge: .bottom) {
                receiptSection
                    .padding(.vertical, 20)
                    .padding(.horizontal)
                    .background(Color(.systemBackground))
                    .frame(maxWidth: 600)
            }
        }
        .frame(maxWidth: 600)
        .padding(.horizontal)
        .background(
            Image("HitTipsLogoTransparent")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .rotationEffect(.degrees(15))
                .opacity(0.05)
        )
        .if(entryPoint == .navigation) { view in
            view.toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    topButtons
                }
            }
        }
    }
    
    // MARK: - Receipt Section
    private var receiptSection: some View {
        VStack(spacing: 8) {
            ReceiptRow(title: UIStrings.billAmountLowercase, value: "$\(tip.billAmount)")
            ReceiptRow(title: UIStrings.tipAmountLowercase, value: "$\(String(format: "%.2f", tip.tipAmount))")
            ReceiptRow(title: UIStrings.tipPercentLowercase, value: "\(tip.tipPercentage)%")
            ReceiptRow(title: UIStrings.partyLowercase, value: "\(tip.party)")
            ReceiptRow(title: UIStrings.tipPerPersonLowercase, value: "$\(String(format: "%.2f", tip.tipPerPerson))")
            ReceiptRow(title: UIStrings.pricePerPersonLowercase, value: "$\(String(format: "%.2f", tip.pricePerPerson))")
            ReceiptRow(title: UIStrings.totalBillCap, value: "$\(String(format: "%.2f", tip.totalBill))", isHighlight: true)
        }
    }
    
    // MARK: - Buttons (reusable)
    private var topButtons: some View {
        HStack {
            Spacer()
            HStack(spacing: entryPoint == .navigation ? 0 : 6) {
                Button { favoriteTapped() } label: {
                    Image(systemName: tip.isFavorite ? "heart.fill" : "heart")
                        .foregroundStyle(.htRed)
                        .font(entryPoint == .navigation ? .HTBody18 : .HTBody22)
                        .scaleEffect(animateHeart ? 1.4 : 1)
                        .opacity(tip.isFavorite ? 1 : 0.5)
                        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: animateHeart)
                }
                
                Button { shareTapped() } label: {
                    Image(systemName: "square.and.arrow.up")
                        .tint(.primary)
                        .font(entryPoint == .navigation ? .HTBody16 : .HTBody20)
                        .offset(y: -3)
                }
            }
            .padding(6)
            .padding(.horizontal, 4)
            .background(entryPoint == .navigation ? .clear : .htGray)
            .appCornerRadius()
        }
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
            print("HTApp: Failed to save tip: \(error.localizedDescription)")
        }
    }
    
    private func shareTapped() {
        // 1. Render TipDetailView as image
        let hostingController = UIHostingController(rootView: self)
        hostingController.view.bounds = UIScreen.main.bounds
        hostingController.view.backgroundColor = UIColor.systemBackground
        
        let renderer = UIGraphicsImageRenderer(size: hostingController.view.bounds.size)
        let image = renderer.image { _ in
            hostingController.view.drawHierarchy(in: hostingController.view.bounds, afterScreenUpdates: true)
        }
        
        // 2. Create activity VC
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        // 3. Present from the top-most VC
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first,
           var topController = window.rootViewController {
            
            while let presented = topController.presentedViewController {
                topController = presented
            }
            
            topController.present(activityVC, animated: true)
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
        ), entryPoint: .sheet
    )
}
