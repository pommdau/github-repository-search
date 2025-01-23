//
//  LoginUserView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import SwiftUI

@MainActor @Observable
final class LoginUserViewState {

    let loginUser: LoginUser
    let gitHubAPIClient: GitHubAPIClient
    let loginUserStore: LoginUserStore
    
    // Error
    var showAlert = false
    var alertError: Error?
    
    init(
        loginUser: LoginUser,
        gitHubAPIClient: GitHubAPIClient = .shared,
        loginUserStore: LoginUserStore = .shared) {
            self.loginUser = loginUser
            self.gitHubAPIClient = gitHubAPIClient
            self.loginUserStore = loginUserStore
    }
    
    // MARK: - Actions
    
    func handleLogOutButtonTapped() {
        Task {
            do {
                try await gitHubAPIClient.logout()
            } catch {
                showAlert = true
                alertError = error
            }
            loginUserStore.delete()
        }
    }
    
}

struct LoginUserView: View {
    
    @State private var viewState: LoginUserViewState
    
    init(loginUser: LoginUser) {
        _viewState = .init(wrappedValue: LoginUserViewState(loginUser: loginUser))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            userLabel()
            locationAndTwitterLabel()
            followLabel()
                .padding(.bottom, 60)
            
            logoutButton()
        }
        .padding(.vertical, 20)
        .alert("エラー", isPresented: $viewState.showAlert) {
            Button("OK") { }
        } message: {
            Text(viewState.alertError?.localizedDescription ?? "(不明なエラー)")
        }

    }
    
    // MARK: - View Parts
    
    @ViewBuilder
    private func userImage() -> some View {
        AsyncImage(url: URL(string: viewState.loginUser.avatarURL),
                   content: { image in
            image.resizable()
        }, placeholder: {
            Image(systemName: "person.fill")
                .resizable()
        })
        .frame(width: 80, height: 80)
        .cornerRadius(40)
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
                Text(viewState.loginUser.name ?? "")
                    .font(.title)
                    .bold()
                Text(viewState.loginUser.login)
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    @ViewBuilder
    private func locationAndTwitterLabel() -> some View {
        HStack {
            if let location = viewState.loginUser.location {
                HStack(spacing: 0) {
                    Image(systemName: "mappin")
                        .scaledToFit()
                        .frame(width: 20)
                    Text(location)
                }
                .foregroundStyle(.secondary)
                .padding(.trailing, 10)
            }
            
            if let twitterUsername = viewState.loginUser.twitterUsername,
               let twitterURL = viewState.loginUser.twitterURL {
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
            Text("\(viewState.loginUser.followers)")
                .bold()
            Text("followers")
                .foregroundStyle(.secondary)
            Text("・")
                .foregroundStyle(.secondary)
            Text("\(viewState.loginUser.following)")
                .bold()
            Text("following")
                .foregroundStyle(.secondary)
        }
    }
    
    @ViewBuilder
    private func logoutButton() -> some View {
        Button("Log out") {
            viewState.handleLogOutButtonTapped()
        }
        .buttonStyle(LogOutButtonStyle())
    }
}

#Preview {
    LoginUserView(loginUser: LoginUser.sampleData())
}
