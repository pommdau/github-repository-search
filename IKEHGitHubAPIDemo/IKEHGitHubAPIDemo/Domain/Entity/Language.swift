//
//  Language.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/14.
//

import SwiftUI
import SwiftID

struct Language: Identifiable, Equatable, Sendable {
    let id: SwiftID<Self>
    var name: String
    var color: Color

    /// Initializer
    /// - Parameters:
    ///   - name: Language name
    ///   - hex: e.g.  "#00cafe"
    init(name: String, hex: String) {
        self.id = .init(rawValue: UUID().uuidString)
        self.name = name
        self.color = Color(hex: hex.replacingOccurrences(of: "#", with: ""))
    }
}
