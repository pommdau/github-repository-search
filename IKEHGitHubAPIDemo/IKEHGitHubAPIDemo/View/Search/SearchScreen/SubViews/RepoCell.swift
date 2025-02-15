//
//  RepoCell.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/10.
//

import SwiftUI
//import SDWebImageSwiftUI
import Shimmer

struct RepoCell: View {
    
    enum StatusType {
        case updatedAt
        case starredAt
    }

    let repo: Repo
    let statusType: StatusType

    var statusText: String {
        switch statusType {
        case .updatedAt:
            guard let date = ISO8601DateFormatter.shared.date(from: repo.updatedAt) else {
                return ""
            }
            return date.convertToUpdatedAtText()
        case .starredAt:
            guard
                let starredAtString = repo.starredAt,
                let date = ISO8601DateFormatter.shared.date(from: starredAtString) else {
                return ""
            }
            return date.convertToStarredAtText()
        }
    }
    
    // swiftlint:disable:next type_contents_order
    init(repo: Repo, statusType: StatusType = .updatedAt) {
        self.repo = repo
        self.statusType = statusType
    }

    var body: some View {
        VStack(alignment: .leading) {
            userLabel()
            repoNameLabel()
            descriptionLabel()
            HStack(spacing: 10) {
                languageLabel()
                starsLabel()
                Text(statusText)
                    .foregroundStyle(.secondary)
                    .font(.footnote)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
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
        HStack(spacing: 0) {
            Image(systemName: "star")
                .accessibilityLabel(Text("Star Image"))
            Text("\(repo.starsCount)")
        }
        .font(.footnote)
        .foregroundStyle(.secondary)
    }

    @ViewBuilder
    private func languageLabel() -> some View {
        if let languageName = repo.language,
           let language = LanguageStore.shared.get(name: languageName) {
            HStack(spacing: 2) {
                Circle()
                    .frame(width: 12, height: 12)
                    .foregroundStyle(language.color)
                Text(language.name)
                    .foregroundStyle(.secondary)
                    .font(.footnote)
            }
        }
    }
}

// MARK: - Previews

#Preview("通常", traits: .sizeThatFitsLayout) {
    RepoCell(repo: Repo.Mock.random())
        .padding()
}

#Preview("長文あり", traits: .sizeThatFitsLayout) {
    RepoCell(repo: Repo.Mock.sampleDataWithLongWord)
        .padding()
}

#Preview("空情報あり(言語/bio)", traits: .sizeThatFitsLayout) {
    RepoCell(repo: Repo.Mock.sampleDataWithoutSomeInfo)
        .padding()
}
