import Foundation
import Dependencies

// MARK: - 依存の登録

private enum TokenStoreKey: Sendable, DependencyKey {
    /// アプリ実行時に利用される値
    static let liveValue: any TokenStoreProtocol = TokenStore()
//    static let testValue: any TokenStoreProtocol = unimplemented()
//    static let previewValue: any TokenStoreProtocol = unimplemented()
}
/*
 DependencyValuesに値を保存し、DependencyKeyでkey-valueとして取り出す感じ
 */
public extension DependencyValues {
    /// DependencyValuesへの登録
    var tokenStore: any TokenStoreProtocol {
        get { self[TokenStoreKey.self] }
        set { self[TokenStoreKey.self] = newValue }
    }
}
