//
//  RepoCell 2.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/15.
//


//
//  RepoCell.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/10.
//

import SwiftUI

struct UserCell: View {

    let user: User

    var body: some View {
        HStack(alignment: .top) {
            userImage()
            VStack(spacing: 8) {
                Text(user.name)
                    .lineLimit(1)
                    .padding(.top, 2)
                
                Button {
                    if let url = user.htmlURL {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    Text(user.htmlPath)
                        .lineLimit(1)
                        .bold()
                        .truncationMode(.tail)
                }
            }
        }
    }
    
    @ViewBuilder
    private func userImage() -> some View {
        AsyncImage(url: URL(string: user.avatarImagePath),
                   content: { image in
            image.resizable()
        }, placeholder: {
            Image(systemName: "person.fill")
                .resizable()
        })
        .frame(width: 24, height: 24)
        .cornerRadius(12)
        .accessibilityLabel(Text("User Image"))
        .background {
            Circle()
                .stroke(lineWidth: 1)
                .foregroundStyle(.secondary.opacity(0.5))
        }
    }
}

// MARK: - Previews

#Preview("通常", traits: .sizeThatFitsLayout) {
    UserCell(user: User.sampleData[0])
        .padding()
}
