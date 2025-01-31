//
//  View+errorAlert.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/31.
//
//  refs: https://www.avanderlee.com/swiftui/error-alert-presenting/

import SwiftUI

extension View {
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

fileprivate struct LocalizedAlertError: LocalizedError {
    let underlyingError: LocalizedError
    var errorDescription: String? {
        underlyingError.errorDescription
    }
    var recoverySuggestion: String? {
        underlyingError.recoverySuggestion
    }
    
    init?(error: Error?) {
        guard let localizedError = error as? LocalizedError else { return nil }
        underlyingError = localizedError
    }
}

// MARK: - Preview

private enum SampleError: LocalizedError {
    case networkError
    case dataCorruption
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .networkError:
            return "通信エラーが発生しました。"
        case .dataCorruption:
            return "データが破損しています。"
        case .unknown:
            return "不明なエラーが発生しました。"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .networkError:
            return "インターネット接続を確認してください。"
        case .dataCorruption:
            return "もう一度データを取得してください。"
        case .unknown:
            return "アプリを再起動してください。"
        }
    }
}

#Preview {
    @Previewable @State var viewError: Error?
    VStack {
        Button("Show Error") {
            viewError = SampleError.networkError
        }
    }
    .errorAlert(error: $viewError)
}

