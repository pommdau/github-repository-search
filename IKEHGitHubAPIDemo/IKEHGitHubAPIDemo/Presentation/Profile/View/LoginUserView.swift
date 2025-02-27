//
//  LoginUserView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct LoginUserView: View {
    
    // MARK: - Property
    
    @State private var state: LoginUserViewState
    
    // swiftlint:disable:next type_contents_order
    init(loginUser: LoginUser, namespace: Namespace.ID? = nil) {
        _state = .init(wrappedValue: LoginUserViewState(loginUser: loginUser, namespace: namespace))
    }
    
    // MARK: - View
    
    var body: some View {
        NavigationStack {
//            VStack(alignment: .leading, spacing: 10) {
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
                
                Section {
                    NavigationLink {
                        // swiftlint:disable:next force_unwrapping
                        LoginUserReposView(url: URL(string: "https://api.github.com/users/octocat/repo")!)
                    } label: {
                        HStack {
                            Image(.bookClosedSquareFill)
                                .font(.title)
                            Text("Repositories")
                            Spacer()
                            Text("999")
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    NavigationLink {
                        Text("repos")
                    } label: {
                        HStack {
                            Image(systemName: "star.square.fill")
                                .font(.title)
                                .foregroundStyle(.yellow)
                                .accessibilityLabel(Text("Star icon"))
                            Text("Starred")
                            Spacer()
                            Text("999")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                Spacer()
                logoutButton()
            }
            .listStyle(.inset)
            .scrollContentBackground(.hidden)
//            .background(.black.opacity(0.1))
        }
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea()
//        .padding(.vertical, 20)
        .errorAlert(error: $state.error)
    }
    
    // MARK: - View Parts
    
    @ViewBuilder
    private func userImage() -> some View {
        // StarredViewなど別Viewでログインした場合に画像がうまく表示されないため、ここではSDWebImageを利用している
        WebImage(url: URL(string: state.loginUser.avatarURL),
                 content: { image in
            image.resizable()
        }, placeholder: {
            Image(systemName: "person.fill")
                .resizable()
        })        
        .frame(width: 80, height: 80)
        .cornerRadius(40)
        .matchedGeometryEffect(id: NamespaceID.LoginView.image1, in: state.namespace)
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
                        .accessibilityLabel(Text("Location icon"))
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
                .accessibilityLabel(Text("Followers icon"))
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
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .matchedGeometryEffect(id: NamespaceID.LoginView.button1, in: state.namespace)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

// MARK: - Preview

#Preview {
    LoginUserView(loginUser: LoginUser.Mock.ikeh)
}
