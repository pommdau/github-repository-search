//
//  RepoDetailsView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import SwiftUI

struct RepoDetailsView: View {
    
    let repo: Repo
    
    var body: some View {
        VStack(alignment: .leading) {            
            VStack(alignment: .leading, spacing: 8) {
                userLabel()
                repoLabel()
            }
            
            StarButtonView(isStarred: repo.isStarred)
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

// MARK: - Title

extension RepoDetailsView {
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

extension RepoDetailsView {
    @ViewBuilder
    private func descriptionView() -> some View {
        VStack(alignment: .leading) {
//            Text("About")
//                .font(.title2)
//                .bold()
//                .padding(.vertical)
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

struct StarButtonView: View {
    
    let isStarred: Bool
    var handleButtonTapped: () -> Void = {}
    
    var body: some View {
        
        ZStack {
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
}

#Preview {
    RepoDetailsView(repo: Repo.sampleData.first!)
}
