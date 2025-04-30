//
//  ProfileView.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/04/30.
//

import SwiftUI
import IKEHGitHubAPIClient

struct ProfileView: View {
    var body: some View {
        LoginView(namespace: nil) {
            Task {
                try await GitHubAPIClient.shared.openLoginPageInBrowser()
            }
        }
        .onOpenURL { url in
            Task {
                do {
                    let token = try await GitHubAPIClient.shared.recieveLoginCallBackURLAndFetchAccessToken(url)
                    print(token)
                } catch {
                    print(error)
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
