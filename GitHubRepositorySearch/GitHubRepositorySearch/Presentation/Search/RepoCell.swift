//
//  RepoCell.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/06.
//

import SwiftUI
import struct IKEHGitHubAPIClient.Repo

struct RepoCell: View {
    
    // セルに表示する情報のタイプ
    enum StatusType {
        case updatedAt
        case starredAt
    }

    let repo: Repo
    let starredAt: Date?
    let statusType: StatusType

    var statusText: String {
        switch statusType {
        case .updatedAt:
            guard let date = ISO8601DateFormatter.shared.date(from: repo.updatedAt) else {
                return ""
            }
            return "Updated \(date.convertToRelativeDateText())"
        case .starredAt:
            guard let starredAt else {
                return ""
            }
            return "Starred \(starredAt.convertToRelativeDateText())"
        }
    }
    
    // swiftlint:disable:next type_contents_order
    init(repo: Repo, starredAt: Date? = nil, statusType: StatusType = .updatedAt) {
        self.repo = repo
        self.starredAt = starredAt
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
            Text(repo.owner.login)
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
        // TODO:
//        if let languageName = repo.language,
//           let language = LanguageStore.shared.get(with: languageName) {
//            HStack(spacing: 2) {
//                Circle()
//                    .frame(width: 12, height: 12)
//                    .foregroundStyle(language.color)
//                Text(language.name)
//                    .foregroundStyle(.secondary)
//                    .font(.footnote)
//            }
//        }
    }
}

// MARK: - Previews

#Preview("通常(作成日時)", traits: .sizeThatFitsLayout) {
    RepoCell(repo: Repo.Mock.random())
        .padding()
}

#Preview("通常(スター)", traits: .sizeThatFitsLayout) {
    RepoCell(repo: Repo.Mock.random(), starredAt: Date.random(inPastYears: 3), statusType: .starredAt)
        .padding()
}

//#Preview("長文あり", traits: .sizeThatFitsLayout) {
//    RepoCell(repo: Repo.Mock.sampleDataWithLongWord)
//        .padding()
//}
//
//#Preview("空情報あり(言語/bio)", traits: .sizeThatFitsLayout) {
//    RepoCell(repo: Repo.Mock.sampleDataWithoutSomeInfo)
//        .padding()
//}
