//
//  Print+.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/01.
//

import Foundation

func printFormattedJSON(_ data: Data) {
    if let jsonString = String(data: data, encoding: .utf8) {
        printFormattedJSON(jsonString)
    } else {
        print("❌ 文字列化エラー: Data は UTF-8 エンコーディングで interpretable ではありません")
    }
}

func printFormattedJSON(_ jsonString: String) {
    guard let data = jsonString.data(using: .utf8) else {
        print("❌ 無効な JSON 文字列")
        return
    }

    do {
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)

        if let prettyString = String(data: prettyData, encoding: .utf8) {
            print(prettyString)
        } else {
            print("❌ JSON のフォーマットに失敗しました")
        }
    } catch {
        print("❌ JSON デコードエラー: \(error.localizedDescription)")
    }
}
