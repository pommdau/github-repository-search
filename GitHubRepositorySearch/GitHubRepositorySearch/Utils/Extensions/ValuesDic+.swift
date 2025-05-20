import Foundation
import struct IKEHGitHubAPIClient.Repo

// TODO: 可能ならジェネリクスに書き直したい
// UnitTestも
extension [Repo.ID: Repo] {
    // 重複したキーの値は上書き
    mutating func registerValues(_ values: [Repo]) {
        let newValuesDic = Dictionary(
            uniqueKeysWithValues: values.map { value in
                (value.id, value)
            })
        self.merge(newValuesDic) { _, new in new }
    }
}

extension [StarredRepo.ID: StarredRepo] {
    // 重複したキーの値は上書き
    mutating func registerValues(_ values: [StarredRepo]) {
        let newValuesDic = Dictionary(
            uniqueKeysWithValues: values.map { value in
                (value.id, value)
            })
        self.merge(newValuesDic) { _, new in new }
    }
}
