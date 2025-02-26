//
//  GitHubLanguageColorManager.swift
//  iOSEngineerCodeCheck
//
//  Created by HIROKI IKEUCHI on 2022/11/14.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//
// refs: https://github.com/ozh/github-colors/blob/master/colors.json

import SwiftUI

struct LanguageStore {

    // MARK: - Properties

    static let shared: LanguageStore = .init()
    
    private let languages: [Language]

    // MARK: - LifeCycle

    private init() {
        self.languages = Self.loadLanguages()
    }
    
    // MARK: Setup
    
    private static func loadLanguages() -> [Language] {
        guard let url = R.file.githubLangColorsJson(),
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
    
    func get(with name: String) -> Language? {
        return languages.first(where: { $0.name == name })
    }
}
