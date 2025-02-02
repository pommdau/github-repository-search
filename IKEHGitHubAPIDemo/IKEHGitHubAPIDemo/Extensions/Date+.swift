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
    
    func convertToUpdatedAtText() -> String {
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self, to: now)
        
        guard
            let hour = components.hour,
            let days = components.day
        else {
            return "(nil)"
        }
        
        // 30日より以前
        if days > 30 {
            return "Updated on \(DateFormatter.shortYearMonthDate.string(from: self))"
        }
        
        // 直近の更新
        return "Updated \(RelativeDateTimeFormatter.in30days.localizedString(for: self, relativeTo: .now) )"

        
        
//        if let days = components.day, days < 30 {
//            return days == 0 ? "Updated today" : "Updated \(days) days ago"
//        } else if let hours = components.hour, days == 0 {
//            return "Updated \(hours) hours ago"
//        } else {
//            let outputFormatter = DateFormatter()
//            outputFormatter.dateFormat = "MMM d, yyyy" // 例: "Dec 17, 2024"
//            outputFormatter.locale = Locale(identifier: "en_US")
//            return "Updated on \(outputFormatter.string(from: self))"
//        }
    }
    
    static func dateFromNow(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0) -> Date {
        let now = Date()
        var components = DateComponents()
        components.year = years
        components.month = months
        components.day = days
        components.hour = hours
        
        return Calendar.current.date(byAdding: components, to: now) ?? now
    }
}

import SwiftUI

#Preview {
    Button("Debug") {
        // 各条件の `Date` を生成
        let testDates = [
            Date.dateFromNow(years: 1), // 未来（1年後）
            Date.dateFromNow(months: -3), // 数ヶ月前（3ヶ月前）
            Date.dateFromNow(days: -30), // 約30日前
            Date.dateFromNow(days: -2), // 2日前
            Date.dateFromNow(hours: -5), // 数時間前（5時間前）
        ]
        
        testDates
            .forEach { date in
                print(date.convertToUpdatedAtText(), "🐱")
            }

    }
}
