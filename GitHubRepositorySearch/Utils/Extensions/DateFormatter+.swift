//
//  DateFormatter+.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/20.
//
//  refs: [【Swift】日時、数、通貨、データサイズ、リスト、人の名前、単位付きの数から String へのフォーマットは自分で実装しないで #iOS - Qiita](https://qiita.com/treastrain/items/e0e9c3e9f517fa20ad08#dateformatter)

import Foundation

extension DateFormatter {
    // e.g. "Feb 2, 2025 at 17:25:33"
    static let tokenExpiresIn: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        return formatter
    }()
    
    // e.g. "Feb 2, 2025"
    static let shortYearMonthDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        return formatter
    }()
}

extension ISO8601DateFormatter {
    // e.g. "2024-12-21T12:20:29Z"
    nonisolated(unsafe) static let shared: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()
}

extension RelativeDateTimeFormatter {
    /*
     e.g.
     in 11 months
     3 months ago
     4 weeks ago
     2 days ago
     5 hours ago
     */
    nonisolated(unsafe) static let shared: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        
        return formatter
    }()
}
