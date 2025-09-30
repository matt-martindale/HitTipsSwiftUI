//
//  Keyboard+.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/29/25.
//

import SwiftUI
import SwiftUIIntrospect

struct KeyboardDoneModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .introspect(.textField, on: .iOS(.v15, .v16, .v17, .v18)) { textField in
                let toolbar = UIToolbar()
                toolbar.sizeToFit()

                let flex = UIBarButtonItem(systemItem: .flexibleSpace)
                let done = UIBarButtonItem(
                    title: "Done",
                    primaryAction: UIAction { _ in
                        textField.resignFirstResponder()
                        NotificationCenter.default.post(name: .keyboardDoneTapped, object: nil)
                    }
                )
                toolbar.items = [flex, done]

                textField.inputAccessoryView = toolbar
                textField.reloadInputViews()
            }
    }
}

extension View {
    func withDoneToolbar() -> some View {
        modifier(KeyboardDoneModifier())
    }
}

extension Notification.Name {
    static let keyboardDoneTapped = Notification.Name("KeyboardDoneTapped")
}
