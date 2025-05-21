//
//  LanguageStore.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/06.
//

import SwiftUI

/// 言語のタイトルと色を管理するStore
/// - SeeAlso: [github-colors/colors.json](https://github.com/ozh/github-colors/blob/master/colors.json)
struct LanguageStore {

    // MARK: - Properties

    static let shared: LanguageStore = .init()
    
    private let languages: [Language]

    // MARK: - LifeCycle

    private init() {
        self.languages = Self.loadLanguageFromLocalFile()
    }
    
    // MARK: Setup
    
    /// ローカルの設定ファイルから情報を読み込む
    private static func loadLanguageFromLocalFile() -> [Language] {
        guard let url = Bundle.main.url(forResource: "github-lang-colors", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: [String: String?]]  // color: null があるためString?としている
        else {
            assertionFailure("Language設定ファイルの読み込みに失敗しました")
            return []
        }

        let languages = json.map { name, details in
            let color = details["color"] as? String ?? "#000000"  // 未定義の場合は黒#000000とする
            return Language(name: name, hex: color)
        }
        .sorted(by: { first, second in
            first.name < second.name
        })
        
        return languages
    }
    
    // MARK: - Read
    
    func getWithName(_ name: String) -> Language? {
        return languages.first(where: { $0.name == name })
    }
}
