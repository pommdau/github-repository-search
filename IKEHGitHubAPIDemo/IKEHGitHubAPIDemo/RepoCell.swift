//
//  RepoCell.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/10.
//

import SwiftUI
//import SDWebImageSwiftUI
//import Shimmer

struct RepoCell: View {

    let repo: Repo

    var body: some View {
        VStack(alignment: .leading) {
            userLabel()
            repoNameLabel()
            descriptionLabel()
            HStack(spacing: 18) {
                starsLabel()
                languageLabel()
            }
            .padding(.top, 2)
        }
    }

    // MARK: - ViewBuilder

    @ViewBuilder
    private func userLabel() -> some View {
        HStack {
            AsyncImage(url: URL(string: repo.owner.avatarImagePath),
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
            Text(repo.owner.name)
                .lineLimit(1)
        }
    }

    @ViewBuilder
    private func repoNameLabel() -> some View {
        Text(repo.name)
            .lineLimit(1)
            .font(.title3)
            .bold()
            .padding(.vertical, 2)
    }

    @ViewBuilder
    private func descriptionLabel() -> some View {
        if let description = repo.description,
           !description.isEmpty {
            Text(description)
                .lineLimit(3)
        }
    }

    @ViewBuilder
    private func starsLabel() -> some View {
        HStack(spacing: 2) {
            Image(systemName: "star")
                .accessibilityLabel(Text("Star Image"))
            Text("\(repo.starsCount)")
        }
        .foregroundStyle(.secondary)
    }

    @ViewBuilder
    private func languageLabel() -> some View {
        if let language = repo.language,
           !language.isEmpty {
            Text(language)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Previews

#Preview("通常", traits: .sizeThatFitsLayout) {
    RepoCell(repo: Repo.sampleData[0])
        .padding()
}

#Preview("長い語句を含む場合", traits: .sizeThatFitsLayout) {
    RepoCell(repo: Repo.sampleDataWithLongWord)
        .padding()
}

#Preview("空の情報がある場合", traits: .sizeThatFitsLayout) {
    RepoCell(repo: Repo.sampleDataWithoutSomeInfo)
        .padding()
}
