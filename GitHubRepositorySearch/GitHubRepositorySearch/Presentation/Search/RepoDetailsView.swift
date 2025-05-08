//
//  RepoDetailsView.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/07.
//

import SwiftUI
import struct IKEHGitHubAPIClient.Repo

import IKEHGitHubAPIClient

@MainActor
@Observable
final class RepoDetailsViewState {
    
    // MARK: - Property
    
    let repoID: Repo.ID
    let tokenStore: TokenStore
    let loginUserStore: LoginUserStore
    let repoStore: RepoStore
    let starredRepoStore: StarredRepoStore

    var checkIsStarredInProcessing: Bool = false
    private var starredInProcessing: Bool = false
    
    var error: Error?
    
    var repo: Repo? {
        repoStore.valuesDic[repoID]
    }
    
    var loginUser: LoginUser? {
        loginUserStore.loginUser
    }
    
    var disableStarButton: Bool {
        (loginUser == nil) ||
        checkIsStarredInProcessing ||
        starredInProcessing
    }
    
    var isStarred: Bool {
        starredRepoStore.valuesDic[repoID]?.isStarred ?? false
    }
    
    // MARK: - LifeCycle
        
    init(
        repoID: Repo.ID,
        tokenStore: TokenStore = TokenStore.shared,
        loginUserStore: LoginUserStore = LoginUserStore.shared,
        repoStore: RepoStore = RepoStore.shared,
        starredRepoStore: StarredRepoStore = StarredRepoStore.shared,
    ) {
        self.repoID = repoID
        self.tokenStore = tokenStore
        self.loginUserStore = loginUserStore
        self.repoStore = repoStore
        self.starredRepoStore = starredRepoStore
    }
    
    func handleStarButtonTapped() {
        Task {
            // すでに処理中の場合は何もしない
            if starredInProcessing {
                return
            }
            
            // 必要な情報のチェック
            guard let repo,
                  let accessToken = await tokenStore.accessToken
            else {
                return
            }
            
            // 状態の更新
            starredInProcessing = true
            defer {
                starredInProcessing = false
            }
            // スター状態を更新
            let currentIsStarred = isStarred
            let currentStarsCount = repo.starsCount
            do {
                if isStarred {
                    // スターを取り消す
                    // 一時的に値を更新する
                    try await repoStore.updateStarsCount(repoID: repo.id, starsCount: max(currentStarsCount - 1, .zero)) // スター数は0未満にならない
                    try await starredRepoStore.updateIsStarred(repoID: repoID, isStarred: false)
                    // 実際の更新処理
                    try await starredRepoStore.unstarRepo(repoID: repoID, accessToken: accessToken, owner: repo.owner.login, repo: repo.name)
                } else {
                    // スターをつける
                    // 一時的に値を更新する
                    try await repoStore.updateStarsCount(repoID: repo.id, starsCount: currentStarsCount + 1)
                    try await starredRepoStore.updateIsStarred(repoID: repoID, isStarred: true)
                    // 実際の更新処理
                    try await starredRepoStore.starRepo(repoID: repoID, accessToken: accessToken, owner: repo.owner.login, repo: repo.name)
                }
            } catch {
                // スターの状態をもとに戻す
                try await starredRepoStore.updateIsStarred(repoID: repoID, isStarred: currentIsStarred)
                try await repoStore.updateStarsCount(repoID: repo.id, starsCount: currentStarsCount)
                self.error = error
            }
        }
    }
    
    func checkIfRepoIsStarred() {
        Task {
            // 必要な情報の確認
            guard let repo,
                  loginUser != nil,
                  let accessToken = await tokenStore.accessToken
            else {
                return
            }
            // 状態の更新
            checkIsStarredInProcessing = true
            defer {
                checkIsStarredInProcessing = false
            }
            
            // スター状態の取得
            do {
                try await starredRepoStore.checkIsRepoStarred(
                    repoID: repo.id,
                    accessToken: accessToken,
                    owner: repo.owner.login,
                    repo: repo.name,
                )
            } catch {
                self.error = error
            }
        }
    }
    
    func onAppear() {
        checkIfRepoIsStarred()
    }
}

struct RepoDetailsView: View {
    
    @State private var state: RepoDetailsViewState
            
    // MARK: - LifeCycle
    
    // swiftlint:disable:next type_contents_order
    init(repoID: Repo.ID) {
        _state = .init(wrappedValue: RepoDetailsViewState(repoID: repoID))
    }

    // MARK: - View
    
    var body: some View {
        Group {
            if let repo = state.repo {
                Content(
                    repo: repo,
                    isStarred: state.isStarred,
                    checkIsStarredInProcessing: state.checkIsStarredInProcessing,
                    disableStarButton: state.disableStarButton
                ) {
                    state.handleStarButtonTapped()
                }
                .onAppear {
                    state.onAppear()
                }
            } else {
                ProgressView()
            }
        }
        .errorAlert(error: $state.error)
    }
}

// MARK: - ContentView

extension RepoDetailsView {
        
    struct Content: View {
        
        // MARK: - Property
        
        let languageStore: LanguageStore = .shared
        let repo: Repo
        let isStarred: Bool
        
        let checkIsStarredInProcessing: Bool
        
        /// スターボタンを非活性にするか
        let disableStarButton: Bool
        
        var starButtonTapped: () -> Void = {}
            
        var language: Language? {
            guard let languageName = repo.language else {
                return nil
            }
            return languageStore.getWithName(languageName)
        }
        
        // MARK: - View
        
        var body: some View {
            VStack(alignment: .leading) {
                userSection()
                    .padding(.vertical, 4)
                descriptionSection(repo: repo)
                languageSection()
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        
        // MARK: - UI Components
    
        // MARK: User
        
        @ViewBuilder
        private func userSection() -> some View {
            VStack(alignment: .leading, spacing: 8) {
                userLabel(repo: repo)
                repoLabel(repo: repo)
            }
            
            StarButton(isStarred: isStarred, isLoading: checkIsStarredInProcessing) {
                starButtonTapped()
            }
//            .disabled(disableStarButton)
        }
        
        @ViewBuilder
        private func userLabel(repo: Repo) -> some View {
            Button {
                guard let url = repo.owner.htmlURL else {
                    return
                }
                UIApplication.shared.open(url)
            } label: {
                HStack {
                    // Icon
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
                    // User Name
                    Text(repo.owner.login)
                        .lineLimit(1)
                }
            }
            .foregroundStyle(.secondary)
        }
        
        @ViewBuilder
        private func repoLabel(repo: Repo) -> some View {
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
        
        // MARK: - Description
        
        @ViewBuilder
        private func descriptionSection(repo: Repo) -> some View {
            Divider()
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
                Text(String.compactName(issuesCount))
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
        
        // MARK: Language
        
        @ViewBuilder
        private func languageSection() -> some View {
            if let language {
                Divider()
                VStack(alignment: .leading) {
                    Text("Language")
                        .font(.title2)
                        .bold()
                    HStack(spacing: 8) {
                        Circle()
                            .frame(width: 14, height: 14)
                            .foregroundStyle(language.color)
                        Text(language.name)
                    }
                }
            } else {
                EmptyView()
            }
        }
    }
}

#Preview("通常") {
    RepoDetailsView.Content(
        repo: Repo.Mock.random(),
        isStarred: true,
        checkIsStarredInProcessing: false,
        disableStarButton: false
    )
}

#Preview("説明と言語が空") {
    RepoDetailsView.Content(
        repo: Repo.Mock.sampleDataWithoutSomeInfo,
        isStarred: true,
        checkIsStarredInProcessing: false,
        disableStarButton: false
    )
}
