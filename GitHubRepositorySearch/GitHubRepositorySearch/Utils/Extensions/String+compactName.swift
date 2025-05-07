//
//  String+compactName.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import SwiftUI

extension String {
    static func compactName(_ value: Int) -> String {
        return "\(IntegerFormatStyle<Int>().notation(.compactName).format(value))"
    }
}

// MARK: - Preview

// refs: [SwiftUIで多言語化に対応してプレビューで確認する](https://dev.classmethod.jp/articles/swiftui-localization/)
#Preview(traits: .sizeThatFitsLayout) {
    let localizationIds = ["en", "ja"]
    let values = [0, 10, 123, 1234, 12345, 123456, 1234567, 12345678]
    HStack {
        List(localizationIds, id: \.self) { localizationId in
            VStack(alignment: .leading) {
                Text(localizationId)
                    .bold()
                ForEach(values, id: \.self) { value in
                    Text(String.compactName(value))
                }
            }
            .padding()
            .environment(\.locale, .init(identifier: localizationId))
        }
    }
    .padding()
}
