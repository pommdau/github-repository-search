//
//  LoginUserView.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/04/30.
//

import SwiftUI
import SDWebImageSwiftUI

struct LoginUserView: View {
    
    // MARK: - Property
    
    @State private var state: LoginUserViewState
    
    // swiftlint:disable:next type_contents_order
    init(namespace: Namespace.ID? = nil) {
        _state = .init(wrappedValue: LoginUserViewState(
            namespace: namespace
        ))
    }
    
    // MARK: - View
        
    var body: some View {
        Content(
            loginUser: state.loginUser,
            namespace: state.namespace,
            logoutButtonTapped: {
                state.handleLogoutButtonTapped()
            }
        )
    }
}

extension LoginUserView {
    
    struct Content: View {
        
        var loginUser: LoginUser
        var namespace: Namespace.ID?
        var logoutButtonTapped: () -> Void = {}
                
        // MARK: - View
        
        var body: some View {
            NavigationStack {
                List {
                    Section {
                        VStack(alignment: .leading, spacing: 10) {
                            userLabel()
                            locationAndTwitterLabel()
                            followLabel()
                        }
                        .padding(.bottom, 20)
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    
                    userItems()
                    Spacer()
                    logoutButton()
                }
                .listStyle(.inset)
                .scrollContentBackground(.hidden)
//                            .background(.black.opacity(0.1))
            }
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea()
            //        .padding(.vertical, 20)
            //        .errorAlert(error: $state.error)
        }
        
        // MARK: - View Parts
        
        @ViewBuilder
        private func userImage() -> some View {
            // StarredViewなど別Viewでログインした場合に画像がうまく表示されないため、ここではSDWebImageを利用している
            WebImage(url: URL(string: loginUser.avatarURL),
                     content: { image in
                image.resizable()
            }, placeholder: {
                Image(systemName: "person.fill")
                    .resizable()
            })
            .frame(width: 80, height: 80)
            .cornerRadius(40)
            .matchedGeometryEffect(id: NamespaceID.LoginView.image1, in: namespace)
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
                            .accessibilityLabel(Text("Location icon"))
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
                    .accessibilityLabel(Text("Followers icon"))
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
        private func userItems() -> some View {
            Section {
                NavigationLink {
                    LoginUserReposListView()
                } label: {
                    HStack {
                        Image(.bookClosedSquareFill)
                            .accessibilityLabel(Text("Repositories icon"))
                            .font(.title)
                        Text("Your Repositories")
                    }
                }
                
                NavigationLink {
                    StarredReposListView()
                } label: {
                    HStack {
                        Image(systemName: "star.square.fill")
                            .font(.title)
                            .foregroundStyle(.yellow)
                            .accessibilityLabel(Text("Star icon"))
                        Text("Starred Repositories")
                        Spacer()
                    }
                }
            }
        }
        
        @ViewBuilder
        private func logoutButton() -> some View {
            Button("Log out") {
                logoutButtonTapped()
            }
            .gitHubButtonStyle(.logOut)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .matchedGeometryEffect(id: NamespaceID.LoginView.button1, in: namespace)
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

// MARK: - Preview

import struct IKEHGitHubAPIClient.LoginUser

#Preview {
    LoginUserView.Content(loginUser: .Mock.ikeh)
}
