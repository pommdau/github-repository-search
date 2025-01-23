//
//  LoginUserView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import SwiftUI

struct LoginUserView: View {
    
    let loginUser: LoginUser
    let loginUserStore: LoginUserStore
    
    let gitHubAPIClient: GitHubAPIClient
    
    init(gitHubAPIClient: GitHubAPIClient = .shared, loginUser: LoginUser, loginUserStore: LoginUserStore = .shared) {
        self.gitHubAPIClient = gitHubAPIClient
        self.loginUser = loginUser
        self.loginUserStore = loginUserStore
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            userLabel()
            locationAndTwitterLabel()
            followLabel()
                .padding(.bottom, 60)

            Button("Log out") {
                Task {
                    do {
                        try await gitHubAPIClient.logout()
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                    do {
                        await loginUserStore.logOutUser()
                    }
                }
            }
            .buttonStyle(LogOutButtonStyle())
        }
        .padding(.vertical, 20)
    }
}

extension LoginUserView {
        
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
}

#Preview {
    LoginUserView(loginUser: LoginUser.sampleData())
}
