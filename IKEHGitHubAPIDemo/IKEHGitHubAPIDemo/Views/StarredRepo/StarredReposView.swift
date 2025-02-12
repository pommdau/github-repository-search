//
//  StarredReposView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/25.
//

import SwiftUI

struct StarredReposView: View {
    
    // MARK: - Property
    
    @Namespace private var namespace
    @State private var state: StarredReposViewState = .init()
    
    // MARK: - LifeCycle
    
    // MARK: - View
    
    var body: some View {
        Content(loginUser: state.loginUser)
            .errorAlert(error: $state.error)
    }
}

extension StarredReposView {
    fileprivate struct Content: View {
        
        @Namespace var namespace
        let loginUser: LoginUser?
        
        var body: some View {
            if loginUser == nil {
                NewLoginView(namespace: namespace)
            } else {
                StarredReposResultView()
            }
        }
    }
}

// MARK: - StarredReposResult

//extension StarredReposView {
//    @ViewBuilder
//    private func starredReposResult() -> some View {
//        List {
//            switch state.asyncRepos {
//            case .initial, .loading:
//                skeltonView()
//            case .loaded, .loadingMore, .error:
//                if state.showNoResultView {
//                    noResultView()
//                } else {
//                    starredReposList()
//                    if case .loadingMore = state.asyncRepos {
//                        lodingMoreProgressView()
//                    }
//                }
//            }
//        }
////        .matchedGeometryEffect(id: ProfileView.NamespaceID.image1, in: namespace)
//        .navigationBarTitleDisplayMode(.inline)
//        .navigationTitle("Starred Repositories")
//        .toolbar {
//            ToolbarItem(placement: .topBarTrailing) {
//                toolbarItemContentSortedBy()
//            }
//        }
//    }

// MARK: - Preview

private struct PreviewView: View {
    
    @State private var loginUser: LoginUser?
    
    var body: some View {
        ZStack {
            Button("Toggle") {
                withAnimation {
                    loginUser = (loginUser == nil) ? LoginUser.Mock.ikeh : nil
                }
            }
            .gitHubButtonStyle(.logIn)
            .offset(y: -300)
            
            StarredReposView.Content(loginUser: loginUser)
        }
    }
}

#Preview {
    PreviewView()
}
