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
        
    let loginUser: LoginUser
    let namespace: Namespace.ID?
    let loginUserStore: LoginUserStore
    let githubAPIClient: GitHubAPIClient
    var error: Error?

    // MARK: - LifeCycle
    
    init(
        loginUser: LoginUser,
        namespace: Namespace.ID?,
        loginUserStore: LoginUserStore = .shared,
        githubAPIClient: GitHubAPIClient = .shared
    ) {
        self.loginUser = loginUser
        self.namespace = namespace
        self.loginUserStore = loginUserStore
        self.githubAPIClient = githubAPIClient
    }
    
    // MARK: - Action
    
    /// ログアウトボタンが押された
    func handleLogOutButtonTapped() {
        Task {
            defer {
                withAnimation {
                    loginUserStore.deleteValue()
                }
            }
            do {
                try await githubAPIClient.logout()
            } catch {
                self.error = error // TODO: fix
            }
        }
    }
}
struct LoginUserView: View {
    
    // MARK: - Property
    
    @State private var state: LoginUserViewState
    
    init(loginUser: LoginUser, namespace: Namespace.ID? = nil) {
        _state = .init(
            wrappedValue:
                LoginUserViewState(loginUser: loginUser, namespace: namespace)
        )
    }
    
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
        AsyncImage(url: URL(string: state.loginUser.avatarURL),
                   content: { image in
            image.resizable()
        }, placeholder: {
            Image(systemName: "person.fill")
                .resizable()
        })
        .frame(width: 80, height: 80)
        .cornerRadius(40)
        .matchedGeometryEffect(id: NamespaceID.ProfileView.image1, in: state.namespace)
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
                Text(state.loginUser.name ?? "")
                    .font(.title)
                    .bold()
                Text(state.loginUser.login)
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    @ViewBuilder
    private func locationAndTwitterLabel() -> some View {
        HStack {
            if let location = state.loginUser.location {
                HStack(spacing: 0) {
                    Image(systemName: "mappin")
                        .scaledToFit()
                        .frame(width: 20)
                    Text(location)
                }
                .foregroundStyle(.secondary)
                .padding(.trailing, 10)
            }
            
            if let twitterUsername = state.loginUser.twitterUsername,
               let twitterURL = state.loginUser.twitterURL {
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
            Text("\(state.loginUser.followers)")
                .bold()
            Text("followers")
                .foregroundStyle(.secondary)
            Text("・")
                .foregroundStyle(.secondary)
            Text("\(state.loginUser.following)")
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
        .gitHubButtonStyle(.logOut)
        .matchedGeometryEffect(id: NamespaceID.ProfileView.button1, in: state.namespace)
    }
}

// MARK: - Preview

#Preview {
    @Previewable @Namespace var namespace
    LoginUserView(loginUser: LoginUser.Mock.ikeh, namespace: namespace)
}
