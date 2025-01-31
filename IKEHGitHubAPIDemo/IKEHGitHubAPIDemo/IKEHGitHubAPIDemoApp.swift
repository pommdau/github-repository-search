//
//  IKEHGitHubAPIDemoApp.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/01.
//

import SwiftUI
import UserDefaultsBrowser

@main
struct IKEHGitHubAPIDemoApp: App {
    var body: some Scene {
        WindowGroup {
            UserDefaultsBrowserContainer {                
                //            SearchScreen()
                //            LoginDebugView()
                RootTabView()
                //            LoginUserView()
            }
        }
    }
}
