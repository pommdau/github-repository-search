//
//  UserDefaults+Delete.swift
//  IKEHGitHubAPIDemoTests
//
//  Created by HIROKI IKEUCHI on 2025/04/07.
//

import Foundation

extension UserDefaults {
    
    static func resetAndRemovePlistUserDefaults(suitName: String) throws {
        // 保存した値の削除
        UserDefaults().removePersistentDomain(forName: suitName)
        
        // plistファイルの削除(removePersistentDomainではキー/値の削除しかされないため)
        guard
            let url = plistURL(suitName: suitName),
            FileManager.default.fileExists(atPath: url.path())
        else {
            return
        }
        try FileManager.default.removeItem(at: url)
    }
    
    private static func plistURL(suitName: String) -> URL? {
        guard let libraryURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else {
            return nil
        }
        return libraryURL
            .appendingPathComponent("Preferences")
            .appendingPathComponent("\(suitName).plist")
    }
}
