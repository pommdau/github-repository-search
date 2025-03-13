////
////  UserView.swift
////  IKEHGitHubAPIDemo
////
////  Created by HIROKI IKEUCHI on 2025/03/08.
////
//
//import SwiftUI
//import WebUI
//
//struct UserView: View {
//    
//    // MARK: - Property
//    
////    @State private var state: LoginUserViewState
//    let user: User
//    
//    // swiftlint:disable:next type_contents_order
////    init(loginUser: LoginUser, namespace: Namespace.ID? = nil) {
////        _state = .init(wrappedValue: LoginUserViewState(loginUser: loginUser, namespace: namespace))
////    }
//    
//    // MARK: - View
//    
//    var body: some View {
//        NavigationStack {
//            List {
//                userInfoSection()
//                mainContentsSection()
//            }
//            .listStyle(.inset)
//            .scrollContentBackground(.hidden)
////            .background(.black.opacity(0.1))
//        }
//        .navigationBarTitleDisplayMode(.inline)
//        .ignoresSafeArea()
////        .padding(.vertical, 20)
////        .errorAlert(error: $state.error)
//    }
//    
//    // MARK: - View Parts
//    
//    @ViewBuilder
//    private func userInfoSection() -> some View {
//        Section {
//            VStack(alignment: .leading, spacing: 10) {
//                userLabel()
//                locationAndTwitterLabel()
//                followLabel()
//            }
//            .padding(.bottom, 20)
//        }
//        .listRowBackground(Color.clear)
//        .listRowSeparator(.hidden)
//    }
//    
//    @ViewBuilder
//    private func userImage() -> some View {
//        // StarredViewなど別Viewでログインした場合に画像がうまく表示されないため、ここではSDWebImageを利用している
//        AsyncImage(url: URL(string: user.avatarImagePath), content: { image in
//            image.resizable()
//        }, placeholder: {
//            Image(systemName: "person.fill")
//                .resizable()
//        })
//        .frame(width: 80, height: 80)
//        .cornerRadius(40)
//        .accessibilityLabel(Text("User Image"))
//        .background {
//            Circle()
//                .stroke(lineWidth: 1)
//                .foregroundStyle(.secondary.opacity(0.5))
//        }
//    }
//    
//    @ViewBuilder
//    private func userLabel() -> some View {
//        HStack {
//            userImage()
//            VStack(alignment: .leading) {
//                Text(user.login)
//                    .font(.title)
//                    .bold()
//                Text(user.login)
//                    .font(.title2)
//                    .foregroundStyle(.secondary)
//            }
//        }
//    }
//    
//    @ViewBuilder
//    private func locationAndTwitterLabel() -> some View {
//        HStack {
//            if let location = user.location {
//                HStack(spacing: 0) {
//                    Image(systemName: "mappin")
//                        .scaledToFit()
//                        .frame(width: 20)
//                        .accessibilityLabel(Text("Location icon"))
//                    Text(location)
//                }
//                .foregroundStyle(.secondary)
//                .padding(.trailing, 10)
//            }
//            
//            if let twitterUsername = user.twitterUsername,
//               let twitterURL = user.twitterURL {
//                HStack(spacing: 2) {
//                    Text("X(Twitter)")
//                        .foregroundStyle(.secondary)
//                    Button {
//                        UIApplication.shared.open(twitterURL)
//                    } label: {
//                        Text("@\(twitterUsername)")
//                            .bold()
//                    }
//                    .buttonStyle(.plain)
//                }
//            }
//        }
//    }
//    
//    @ViewBuilder
//    private func followLabel() -> some View {
//        HStack(spacing: 2) {
//            Image(systemName: "person.2")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 20)
//                .foregroundStyle(.secondary)
//                .accessibilityLabel(Text("Followers icon"))
//            Text("\(user.followers)")
//                .bold()
//            Text("followers")
//                .foregroundStyle(.secondary)
//            Text("・")
//                .foregroundStyle(.secondary)
//            Text("\(user.following)")
//                .bold()
//            Text("following")
//                .foregroundStyle(.secondary)
//        }
//    }
//    
//    @ViewBuilder
//    private func mainContentsSection() -> some View {
//        Section {
//            NavigationLink {
//                // swiftlint:disable:next force_unwrapping
//                LoginUserReposView(url: URL(string: "https://api.github.com/users/octocat/repo")!)
//            } label: {
//                HStack {
//                    Image(.bookClosedSquareFill)
//                        .font(.title)
//                        .accessibilityLabel(Text("Repository icon"))
//                    Text("Repositories")
//                    Spacer()
//                    Text("\(user.publicRepos)")
//                        .foregroundStyle(.secondary)
//                }
//            }
//            
//            NavigationLink {
//                Text("repos")
//            } label: {
//                HStack {
//                    Image(systemName: "star.square.fill")
//                        .font(.title)
//                        .foregroundStyle(.yellow)
//                        .accessibilityLabel(Text("Star icon"))
//                    Text("Starred")
//                }
//            }
//        }
//    }
//}
//
//// MARK: - Preview
//
//#Preview {
//    UserView(user: User.Mock.random())
//}
