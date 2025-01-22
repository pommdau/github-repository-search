//
//  LoginUserView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import SwiftUI

struct LoginUserView: View {
    
    let user = LoginUser.sampleData()
    
    let gitHubAPIClient: GitHubAPIClient
    
    init(gitHubAPIClient: GitHubAPIClient = .shared) {
        self.gitHubAPIClient = gitHubAPIClient
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
        AsyncImage(url: URL(string: user.avatarURL),
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
                Text(user.name ?? "")
                    .font(.title)
                Text(user.login)
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    
    @ViewBuilder
    private func locationAndTwitterLabel() -> some View {
        HStack {
            if let location = user.location {
                HStack(spacing: 0) {
                    Image(systemName: "mappin")
                        .scaledToFit()
                        .frame(width: 20)
                    Text(location)
                }
                .foregroundStyle(.secondary)
                .padding(.trailing, 10)
            }
            
            if let twitterUsername = user.twitterUsername,
               let twitterURL = user.twitterURL {
                HStack(spacing: 2) {
                    Text("X(Twitter)")
                        .foregroundStyle(.secondary)
                    Button {
                        UIApplication.shared.open(twitterURL)
                    } label: {
                        Text("@\(twitterUsername)")
                            .fontWeight(.heavy)
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
            Text("\(user.followers)")
                .bold()
            Text("followers")
                .foregroundStyle(.secondary)
            Text("・")
                .foregroundStyle(.secondary)
            Text("\(user.following)")
                .bold()
            Text("following")
                .foregroundStyle(.secondary)
        }
        
    }
}

#Preview {
    LoginUserView()
}
