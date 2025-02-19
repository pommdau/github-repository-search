//
//  GitHubDTO.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/31.
//

import Foundation
import SwiftID

// そのクラスに対応したID型を定義する汎用型
struct SwiftID<T>: StringIDProtocol {
    let rawValue: String
}

/// GitHubAPIで扱うDTOモデル用のプロトコル
protocol GitHubDTO: Identifiable, Codable, Sendable, Hashable, Equatable {
    associatedtype Model
    var id: SwiftID<Model> { get } // 各DTOにユニークな型のIDを定義
}
