//
//  GitHubDTO.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/31.
//

import Foundation
import SwiftID

// 汎用のID型
struct SwiftID<T>: StringIDProtocol {
    let rawValue: String
}

protocol GitHubDTO: Identifiable, Codable, Sendable, Hashable, Equatable {
    associatedtype Model
    var id: SwiftID<Model> { get } // 各DTOにユニークな型のIDを定義
}
