import Foundation
import KeychainAccess

extension Keychain {
    enum Service {
        static let oauth = "com.ikeh1024.IKEHGitHubAPIDemo.oauth"
    }
    enum Key {
        static let accessToken = "com.ikeh1024.IKEHGitHubAPIDemo.accessToken"
    }
}
