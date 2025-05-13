//
//  RepoCell.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/06.
//

import SwiftUI
import struct IKEHGitHubAPIClient.Repo

struct RepoCell: View {
    
    // MARK: - Property
    
    /// セルに表示する情報のタイプ
    enum StatusType {
        /// 最終更新日時
        case updatedAt
        /// スター日時
        case starredAt
    }

    let languageStore: LanguageStore = .shared
    let repo: Repo
    let starredRepo: StarredRepo?
    let statusType: StatusType

    var statusText: String {
        switch statusType {
        case .updatedAt:
            guard let date = ISO8601DateFormatter.shared.date(from: repo.updatedAt) else {
                return ""
            }
            return "Updated \(date.convertToRelativeDateText())"
        case .starredAt:
            guard
                let starredAt = starredRepo?.starredAt,
                let date = ISO8601DateFormatter.shared.date(from: starredAt) else {
                return ""
            }
            return "Starred \(date.convertToRelativeDateText())"
        }
    }
    
    var language: Language? {
        guard let languageName = repo.language else {
            return nil
        }
        return languageStore.getWithName(languageName)
    }
    
    // MARK: - LifeCycle
        
    // swiftlint:disable:next type_contents_order
    init(
        repo: Repo,
        starredRepo: StarredRepo? = nil,
        statusType: StatusType = .updatedAt
    ) {
        self.repo = repo
        self.starredRepo = starredRepo
        self.statusType = statusType
    }
    
    // MARK: - View
    
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

    // MARK: - View Parts

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
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    private func starsLabel() -> some View {
        HStack(spacing: 0) {
            if let isStarred = starredRepo?.isStarred,
               isStarred {
                // スター済みの場合
                Image(systemName: "star.fill")
                    .accessibilityLabel(Text("Star Image"))
                    .foregroundStyle(Color(uiColor: .systemYellow))
            } else {
                // 未スターの場合
                Image(systemName: "star")
                    .accessibilityLabel(Text("Star Image"))
                    .foregroundStyle(.secondary)
            }
            Text("\(repo.starsCount)")
                .foregroundStyle(.secondary)
        }
        .font(.footnote)
    }

    @ViewBuilder
    private func languageLabel() -> some View {
        if let language {
            HStack(spacing: 2) {
                Circle()
                    .frame(width: 12, height: 12)
                    .foregroundStyle(language.color)
                Text(language.name)
                    .foregroundStyle(.secondary)
                    .font(.footnote)
            }
        } else {
            EmptyView()
        }
    }
}

// MARK: - Previews

#Preview("通常(最終更新日時の表示)", traits: .sizeThatFitsLayout) {
    RepoCell(repo: Repo.Mock.random())
        .padding()
}

#Preview("通常(スター日時の表示)", traits: .sizeThatFitsLayout) {
    let repo = Repo.Mock.random()
    RepoCell(
        repo: Repo.Mock.random(),
        starredRepo: StarredRepo.Mock.randomWithRepos([repo]).first,
        statusType: .starredAt
    )
    .padding()
}

#Preview("いくつか情報が空の場合", traits: .sizeThatFitsLayout) {
    RepoCell(repo: Repo.Mock.sampleDataWithoutSomeInfo)
        .padding()
}
