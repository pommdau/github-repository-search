//
//  Array+RawRepresentable.swift
//  iOSEngineerCodeCheck
//
//  Created by HIROKI IKEUCHI on 2024/10/10.
//  Copyright © 2024 YUMEMI Inc. All rights reserved.
//

import Foundation

/*
 refs:
 [How to Store Nested Arrays in @AppStorage for SwiftUI](https://stackoverflow.com/questions/63166706/how-to-store-nested-arrays-in-appstorage-for-swiftui)
 [Xcode 16 warning "Extension declares a conformance of imported type \.\.\. this will not behave correctly"](https://stackoverflow.com/questions/78612277/xcode-16-warning-extension-declares-a-conformance-of-imported-type-this-wil)
 */
extension Array: Swift.RawRepresentable where Element: Swift.Codable {
    
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
    
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }
}
