import Foundation
import struct IKEHGitHubAPIClient.Repo

extension Dictionary where Key: Hashable, Value: Identifiable, Value.ID == Key {
    /// IDをキーとする値の登録を行います
    mutating func registerValues(_ values: [Value]) {
        let newValuesDic = Dictionary(
            uniqueKeysWithValues: values.map { ($0.id, $0) }
        )
        self.merge(newValuesDic) { _, new in new }
    }
}
