//
//  UserDefaults+.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/04/30.
//

import Foundation

// MARK: - Codableなデータを扱えるようにする

extension UserDefaults {
    func codableItem<T>(forKey defaultName: String) -> T? where T: Codable {
        let jsonDecoder = JSONDecoder()
        guard let itemData = self.data(forKey: defaultName),
              let item = try? jsonDecoder.decode(T.self, from: itemData) else {
            return nil
        }
        
        return item
    }
    
    func setCodableItem<T>(_ value: T, forKey defaultName: String) where T: Codable {
        let jsonEncoder = JSONEncoder()
        guard let valueData = try? jsonEncoder.encode(value) else {
            return
        }
        self.set(valueData, forKey: defaultName)
    }
}

// MARK: - Sendable対応

// refs: https://zenn.dev/kntk/scraps/0c3f6014bcad33
extension UserDefaults: @unchecked @retroactive Sendable {}
