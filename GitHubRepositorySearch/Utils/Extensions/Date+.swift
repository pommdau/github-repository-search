//
//  Date+.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import Foundation

extension Date {
    /// 過去n年間のランダムな日時の作成
    static func random(inPastYears years: Int) -> Date {
        let now = Date()
        let secondsInYear: TimeInterval = 365 * 24 * 60 * 60
        let randomOffset = TimeInterval.random(in: 0...(Double(years) * secondsInYear))
        
        return now.addingTimeInterval(-randomOffset)
    }
    
    /// 指定された有効期限（秒）を元に期限切れの日時を計算する
    func addingExpirationInterval(_ expiresIn: Int) -> Date {
        return self.addingTimeInterval(TimeInterval(expiresIn))
    }
    
    /// e.g.
    /// "on Nov 16, 2024"
    /// "in 11 months"
    /// "2 days ago"
    @MainActor
    func convertToRelativeDateText() -> String {
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self, to: now)
        guard let days = components.day else {
            return "" // 通常通らない
        }
        if days > 30 {
            // 30日より前
            return "on \(DateFormatter.shortYearMonthDate.string(from: self))"
        } else {
            // 30日以内
            return "\(RelativeDateTimeFormatter.shared.localizedString(for: self, relativeTo: .now) )"
        }
    }
}

// MARK: - Debug
/*
import SwiftUI

private struct SampleView: View {
        
    var text: String {
        let testDates = [
            Self.dateFromNow(years: 1), // 未来（1年後）
            Self.dateFromNow(months: -3), // 数ヶ月前（3ヶ月前）
            Self.dateFromNow(days: -30), // 約30日前
            Self.dateFromNow(days: -2), // 2日前
            Self.dateFromNow(hours: -5) // 数時間前（5時間前）
        ]
        
        return testDates.reduce(into: "") { result, date in
            result += "\n\(date.convertToRelativeDateText())"
        }
    }
    
    var body: some View {
        Text(text)
    }
    
    private static func dateFromNow(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0) -> Date {
        let now = Date()
        var components = DateComponents()
        components.year = years
        components.month = months
        components.day = days
        components.hour = hours
        
        return Calendar.current.date(byAdding: components, to: now) ?? now
    }
}

#Preview {
    SampleView()
}
*/
