////
////  LoginUserViewState.swift
////  IKEHGitHubAPIDemo
////
////  Created by HIROKI IKEUCHI on 2025/01/23.
////
//
//import Foundation
//
//@MainActor @Observable
//final class LoginUserViewState {
//
//    let gitHubAPIClient: GitHubAPIClient
//    let loginUserStore: LoginUserStore
//    
//    var loginUser: LoginUser? {
//        loginUserStore.value
//    }
//    
//    // Error
//    var showAlert = false
//    var alertError: Error?
//    
//    init(gitHubAPIClient: GitHubAPIClient = .shared, loginUserStore: LoginUserStore = .shared) {
//        self.gitHubAPIClient = gitHubAPIClient
//        self.loginUserStore = loginUserStore
//    }
//    
//    // MARK: - Actions
//    
//    func handleLogInButtonTapped() {
//        Task {
//            
//        }
//    }
//    
//    func handleLogOutButtonTapped() {
//        Task {
//            do {
//                try await gitHubAPIClient.logout()
//            } catch {
//                alertError = error
//                showAlert = true
//            }
//            loginUserStore.deleteValue()
//        }
//    }
//    
//    
//}
