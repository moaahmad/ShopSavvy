//
//  View+Extensions.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 26/04/2023.
//

import SwiftUI

extension View {
    @ViewBuilder
    func errorAlert(
        error: Binding<Error?>,
        buttonTitle: String = "OK"
    ) -> some View {
        let localizedAlertError = LocalizedAlertError(error: error.wrappedValue)
        alert(
            isPresented: .constant(localizedAlertError != nil),
            error: localizedAlertError
        ) { _ in
            Button(buttonTitle) {
                error.wrappedValue = nil
            }
        } message: { error in
            Text(error.recoverySuggestion.orEmpty)
        }
    }
}
