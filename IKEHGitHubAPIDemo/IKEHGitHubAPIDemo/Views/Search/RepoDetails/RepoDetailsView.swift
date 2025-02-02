//
//  RepoDetailsView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import SwiftUI

struct RepoDetailsView: View {
    
    @State private var state: RepoDetailsViewState
            
    // MARK: - LifeCycle
    
    init(repoID: Repo.ID) {
        _state = .init(wrappedValue: RepoDetailsViewState(repoID: repoID))
    }

    // MARK: - View
    
    var body: some View {
        if let repo = state.repo {
            content(repo: repo)
        } else {
            ProgressView()
        }
    }
}

extension RepoDetailsView {
    
    @ViewBuilder
    private func content(repo: Repo) -> some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 8) {
                userLabel(repo: repo)
                repoLabel(repo: repo)
            }
            StarButton(isStarred: repo.isStarred) {
                state.handleStarButtonTapped()
            }
            .disabled(state.disableStarButton)
            
            .padding(.vertical, 4)
            Divider()
            descriptionView(repo: repo)
            Spacer()
        }
        .padding(.horizontal, 20)
        .onAppear {

        }
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
                Text(repo.owner.name)
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

    @ViewBuilder
    private func descriptionView(repo: Repo) -> some View {
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
}

//#Preview {
//    Content(repo: Repo.Mock.random())
//}
