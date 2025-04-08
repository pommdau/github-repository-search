//
//  UserDefaults+Delete.swift
//  IKEHGitHubAPIDemoTests
//
//  Created by HIROKI IKEUCHI on 2025/04/07.
//

import Foundation

extension UserDefaults {
    
    static func resetAndRemovePlistUserDefaults(suiteName: String) throws {
        // 保存した値の削除
        UserDefaults().removePersistentDomain(forName: suiteName)
        
        // plistファイルの削除(removePersistentDomainではキー/値の削除しかされないため)
        guard
            let url = plistURL(suiteName: suiteName),
            FileManager.default.fileExists(atPath: url.path())
        else {
            print("not found plist: \(plistURL(suiteName: suiteName)!.path())")
            return
        }
        try FileManager.default.removeItem(at: url)
    }
    
    private static func plistURL(suiteName: String) -> URL? {
        guard let libraryURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else {
            return nil
        }
        return libraryURL
            .appendingPathComponent("Preferences")
            .appendingPathComponent("\(suiteName).plist")
    }
}
