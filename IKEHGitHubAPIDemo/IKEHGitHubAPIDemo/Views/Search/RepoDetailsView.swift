//
//  RepoDetailsView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import Foundation
import SwiftUI

@MainActor @Observable
final class RepoDetailsViewState {
    
    // MARK: - Property
                
    private(set) var starredTask: Task<(), Never>?
        
    let repoID: Repo.ID
    var repo: Repo? {
        repoStore.valuesDic[repoID]
    }
    let gitHubAPIClient: GitHubAPIClient
    let repoStore: RepoStore
    var error: Error?
    
    // MARK: - LifeCycle
        
    init(repoID: Repo.ID, gitHubAPIClient: GitHubAPIClient = .shared, repoStore: RepoStore = .shared) {
        self.repoID = repoID
        self.gitHubAPIClient = gitHubAPIClient
        self.repoStore = repoStore
    }
    
    // MARK: - Actions
    
    func handleStarButtonTapped() {
        Task {
            guard var repo else {
                return
            }
            repo.isStarred.toggle()
            // スター日時の更新
            repo.starredAt = repo.isStarred
            ? ISO8601DateFormatter.shared.string(from: .now)
            : nil
            try await repoStore.addValue(repo)
        }
    }
}


struct RepoDetailsView: View {
    
    @State private var state: RepoDetailsViewState
            
    // MARK: - LifeCycle
    
    init(repoID: Repo.ID) {
        _state = .init(wrappedValue: RepoDetailsViewState(repoID: repoID))
    }
    
    var body: some View {        
        if let repo = state.repo {
            _RepoDetailsView(repo: repo) {
                state.handleStarButtonTapped()
            }
        } else {
            ProgressView()
        }
    }
}

// MARK: - Title

struct _RepoDetailsView: View {
    
    let repo: Repo
    var handleStarButtonTapped: () -> Void = {}
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 8) {
                userLabel()
                repoLabel()
            }
            
            StarButton(isStarred: repo.isStarred) {
                handleStarButtonTapped()
            }
            .padding(.vertical, 4)
            Divider()
            descriptionView()
            //            if let language = repo.language,
            //               !language.isEmpty {
            //                Divider()
            //                LanguageView(languageName: language)
            //            }
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

extension _RepoDetailsView {
    @ViewBuilder
    private func userLabel() -> some View {
        Button {
            guard let url = repo.owner.htmlURL else {
                return
            }
            UIApplication.shared.open(url)
        } label: {
            HStack {
                // Userアイコン
                AsyncImage(url: repo.owner.avatarImageURL) { image in
                    image.resizable()
                } placeholder: {
                    Image(systemName: "person.fill")
                        .resizable()
                        .accessibilityLabel(Text("User Image"))
                }
                .accessibilityLabel(Text("User Image"))
                .frame(maxWidth: 40, maxHeight: 40)
                .cornerRadius(20)
                .background {
                    Circle()
                        .stroke(lineWidth: 1)
                        .foregroundStyle(.secondary)
                }
                // User名
                Text(repo.owner.name)
                    .lineLimit(1)
            }
        }
        .foregroundStyle(.secondary)
    }

    @ViewBuilder
    private func repoLabel() -> some View {
        Button {
            guard let url = repo.htmlURL else {
                return
            }
            UIApplication.shared.open(url)
        } label: {
            Text(repo.name)
                .lineLimit(1)
                .font(.title)
                .bold()
        }
        .foregroundStyle(.primary)
    }
}

// MARK: - Description

extension _RepoDetailsView {
    @ViewBuilder
    private func descriptionView() -> some View {
        VStack(alignment: .leading) {
            if let description = repo.description,
               !description.isEmpty {
                Text(description)
                    .padding(.bottom, 8)
            }
            Grid(verticalSpacing: 8) {
                starsGridRow(starsCount: repo.starsCount)
                //                wachersGridRow(watchersCount: repo.watchersCount)
                forksGridRow(forksCount: repo.forksCount)
                issuesGridRow(issuesCount: repo.openIssuesCount)
                websiteGridRow(websiteURL: repo.websiteURL)
            }
        }
    }
    
    @ViewBuilder
    private func starsGridRow(starsCount: Int) -> some View {
        GridRow {
            Image(systemName: "star")
                .accessibilityLabel(Text("Stars Image"))
                .foregroundStyle(.secondary)
                .gridColumnAlignment(.center)
            Text(String.compactName(starsCount))
                .bold()
                .gridColumnAlignment(.trailing)
            Text("stars")
                .foregroundStyle(.secondary)
                .gridColumnAlignment(.leading)
        }
    }

    @ViewBuilder
    private func watchersGridRow(watchersCount: Int) -> some View {
        GridRow {
            Image(systemName: "eye")
                .accessibilityLabel(Text("Watchers Image"))
                .foregroundStyle(.secondary)
            Text(String.compactName(watchersCount))
                .bold()
            Text("watching")
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private func forksGridRow(forksCount: Int) -> some View {
        GridRow {
            Image(systemName: "arrow.triangle.branch")
                .accessibilityLabel(Text("Forks Image"))
                .foregroundStyle(.secondary)
            Text(String.compactName(forksCount))
                .bold()
            Text("forks")
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private func issuesGridRow(issuesCount: Int) -> some View {
        GridRow {
            Image(systemName: "circle.circle")
                .accessibilityLabel(Text("Issues Image"))
                .foregroundStyle(.secondary)
            Text(String.compactName(repo.openIssuesCount))
                .bold()
            Text("issues")
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private func websiteGridRow(websiteURL: URL?) -> some View {
        if let websiteURL {
            GridRow {
                Image(systemName: "link")
                    .accessibilityLabel(Text("Link Image"))
                    .foregroundStyle(.secondary)
                Button {
                    UIApplication.shared.open(websiteURL)
                } label: {
                    Text("\(websiteURL.absoluteString)")
                        .lineLimit(1)
                        .bold()
                }
                .gridCellColumns(3)
            }
        }
    }
}

struct StarButton: View {
    
    let isStarred: Bool
    var handleButtonTapped: () -> Void = {}
    
    var body: some View {
        Button {
            handleButtonTapped()
        } label: {
            HStack {
                Image(systemName: isStarred ? "star.fill" : "star")
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

#Preview {
    _RepoDetailsView(repo: Repo.sampleData.first!)
}
