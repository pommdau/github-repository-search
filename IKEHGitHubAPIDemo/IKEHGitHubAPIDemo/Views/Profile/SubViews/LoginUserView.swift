//
//  LoginUserView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import SwiftUI

@MainActor @Observable
final class LoginUserViewState {
    
    // MARK: - Property
        
    let loginUserStore: LoginUserStore
    let githubAPIClient: GitHubAPIClient
    var error: Error?

    // MARK: - LifeCycle
    
    init(
        loginUserStore: LoginUserStore = .shared,
        githubAPIClient: GitHubAPIClient = .shared
    ) {
        self.loginUserStore = loginUserStore
        self.githubAPIClient = githubAPIClient
    }
    
    // MARK: - Action
    
    /// ログアウトボタンが押された
    func handleLogOutButtonTapped() {
        Task {
            do {
                try await githubAPIClient.logout()
                withAnimation {
                    loginUserStore.deleteValue()
                }
            } catch {
                self.error = error
            }
        }
    }
}
struct LoginUserView: View {
    
    // MARK: - Property
            
    let loginUser: LoginUser
    let namespace: Namespace.ID
    @State private var state: LoginUserViewState = .init()
    
    // MARK: - View
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            userLabel()
            locationAndTwitterLabel()
            followLabel()
                .padding(.bottom, 60)
            
            logoutButton()
        }
        .padding(.vertical, 20)
        .errorAlert(error: $state.error)
    }
    
    // MARK: - View Parts
    
    @ViewBuilder
    private func userImage() -> some View {
        AsyncImage(url: URL(string: loginUser.avatarURL),
                   content: { image in
            image.resizable()
        }, placeholder: {
            Image(systemName: "person.fill")
                .resizable()
        })
        .frame(width: 80, height: 80)
        .cornerRadius(40)
        .matchedGeometryEffect(id: ProfileView.NamespaceID.image1, in: namespace)
        .accessibilityLabel(Text("User Image"))
        .background {
            Circle()
                .stroke(lineWidth: 1)
                .foregroundStyle(.secondary.opacity(0.5))
        }
    }
    
    @ViewBuilder
    private func userLabel() -> some View {
        HStack {
            userImage()
            VStack(alignment: .leading) {
                Text(loginUser.name ?? "")
                    .font(.title)
                    .bold()
                Text(loginUser.login)
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    @ViewBuilder
    private func locationAndTwitterLabel() -> some View {
        HStack {
            if let location = loginUser.location {
                HStack(spacing: 0) {
                    Image(systemName: "mappin")
                        .scaledToFit()
                        .frame(width: 20)
                    Text(location)
                }
                .foregroundStyle(.secondary)
                .padding(.trailing, 10)
            }
            
            if let twitterUsername = loginUser.twitterUsername,
               let twitterURL = loginUser.twitterURL {
                HStack(spacing: 2) {
                    Text("X(Twitter)")
                        .foregroundStyle(.secondary)
                    Button {
                        UIApplication.shared.open(twitterURL)
                    } label: {
                        Text("@\(twitterUsername)")
                            .bold()
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    @ViewBuilder
    private func followLabel() -> some View {
        HStack(spacing: 2) {
            Image(systemName: "person.2")
                .resizable()
                .scaledToFit()
                .frame(width: 20)
                .foregroundStyle(.secondary)
            Text("\(loginUser.followers)")
                .bold()
            Text("followers")
                .foregroundStyle(.secondary)
            Text("・")
                .foregroundStyle(.secondary)
            Text("\(loginUser.following)")
                .bold()
            Text("following")
                .foregroundStyle(.secondary)
        }
    }
    
    @ViewBuilder
    private func logoutButton() -> some View {
        Button("Log out") {
            state.handleLogOutButtonTapped()
        }
        .buttonStyle(LogOutButtonStyle())
        .matchedGeometryEffect(id: ProfileView.NamespaceID.button1, in: namespace)
    }
}

// MARK: - Preview

#Preview {
    @Previewable @Namespace var namespace
    LoginUserView(loginUser: LoginUser.Mock.ikeh, namespace: namespace)
}
