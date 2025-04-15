import KeychainAccess

extension Keychain {
    enum Const {
        enum Service {
            static let oauth = "com.ikeh1024.IKEHGitHubAPI.oauth"
        }
        
        enum Key {
            static let accessToken = "com.ikeh1024.IKEHGitHubAPI.accessToken"
        }
    }
}
