//
//  StarButton.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/07.
//

import SwiftUI

struct StarButton: View {
    
    // MARK: - Property
    
    /// スター状態
    var isStarred: Bool
    /// スター状態の読み込み込み中かどうか
    var isLoading: Bool = false
    /// ボタンがタップされた時の処理
    var handleButtonTapped: () -> Void = {}
    
    // MARK: - View
    
    var body: some View {
        Button {
            handleButtonTapped()
        } label: {
            ZStack {
                if isLoading {
                    ProgressView()
                } else {
                    HStack {
                        Image(systemName: isStarred ? "star.fill" : "star")
                            .accessibilityLabel(Text("Star icon"))
                        Text(isStarred ? "Starred" : "Star")
                            .foregroundColor(.secondary)
                    }
                    .tint(Color(uiColor: .systemYellow))
                }
            }
        }
        .disabled(isLoading)
        .contentTransition(.symbolEffect(.replace))
        .padding(8)
        .frame(width: 120)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.secondary, lineWidth: 1.0)
        )
    }
}

// MARK: - Preview

#Preview("スター状態の切り替え") {
    @Previewable @State var isStarred = false
    StarButton(isStarred: isStarred) {
        isStarred.toggle()
    }
}

#Preview("読込中") {
    @Previewable @State var isProcessing = true
    ZStack {
        Toggle("読込中", isOn: $isProcessing.animation())
            .frame(width: 130)
            .offset(y: -100)
        StarButton(isStarred: false, isLoading: isProcessing) {}
    }
}
