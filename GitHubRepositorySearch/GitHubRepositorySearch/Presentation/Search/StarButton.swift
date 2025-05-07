//
//  StarButton.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/07.
//

import SwiftUI

struct StarButton: View {
    
    let isStarred: Bool
    var handleButtonTapped: () -> Void = {}
    
    var body: some View {
        Button {
            handleButtonTapped()
        } label: {
            HStack {
                Image(systemName: isStarred ? "star.fill" : "star")
                    .accessibilityLabel(Text("Star icon"))
                Text(isStarred ? "Starred" : "Star")
                    .foregroundColor(.secondary)
            }
            .padding(8)
        }
        .tint(Color(uiColor: .systemYellow))
        .frame(width: 120)
        .contentTransition(.symbolEffect(.replace))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.secondary, lineWidth: 1.0)
        )
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var isStarred = false
    StarButton(isStarred: isStarred) {
        isStarred.toggle()
    }
}
