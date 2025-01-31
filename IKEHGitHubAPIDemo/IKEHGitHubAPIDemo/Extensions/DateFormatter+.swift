//
//  DateFormatter+.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/20.
//
//  refs: [【Swift】日時、数、通貨、データサイズ、リスト、人の名前、単位付きの数から String へのフォーマットは自分で実装しないで #iOS - Qiita](https://qiita.com/treastrain/items/e0e9c3e9f517fa20ad08#dateformatter)

import Foundation

extension DateFormatter {
    static let forTokenExpiresIn: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        return formatter
    }()
}

//extension ISO8601DateFormatter: @retroactive @unchecked Sendable {}

extension ISO8601DateFormatter {
    @MainActor static let shared: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()
}
