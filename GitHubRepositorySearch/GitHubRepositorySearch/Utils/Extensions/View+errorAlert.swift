//
//  View+errorAlert.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/03.
//

import SwiftUI

private struct LocalizedAlertError: LocalizedError {
    let underlyingError: LocalizedError
    var errorDescription: String? {
        underlyingError.errorDescription
    }
    var recoverySuggestion: String? {
        underlyingError.recoverySuggestion
    }
    
    init?(error: Error?) {
        guard let localizedError = error as? LocalizedError else {
            return nil
        }
        underlyingError = localizedError
    }
}

extension View {
    /// エラーモーダルを扱いやすくするためのUtils
    /// - SeeAlso: [SwiftUI Alert Guide + Code Examples](https://www.avanderlee.com/swiftui/error-alert-presenting/)
    func errorAlert(error: Binding<Error?>, buttonTitle: String = "OK") -> some View {
        let localizedAlertError = LocalizedAlertError(error: error.wrappedValue)
        return self.alert(isPresented: .constant(localizedAlertError != nil), error: localizedAlertError) { _ in
            Button(buttonTitle) {
                error.wrappedValue = nil
            }
        } message: { error in
            Text(error.recoverySuggestion ?? "")
        }
    }
}
