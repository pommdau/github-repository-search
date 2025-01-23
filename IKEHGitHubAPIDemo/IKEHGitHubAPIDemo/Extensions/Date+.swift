//
//  Date+.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import Foundation

extension Date {
    /// 指定された有効期限（秒）を元に期限切れの日時を計算する
    func addingExpirationInterval(_ expiresIn: Int) -> Date {
        return self.addingTimeInterval(TimeInterval(expiresIn))
    }
}
