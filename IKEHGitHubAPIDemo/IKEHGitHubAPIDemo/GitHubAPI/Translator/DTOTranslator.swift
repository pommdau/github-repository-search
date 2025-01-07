//
//  DTOTranslator.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/07.
//

import Foundation

protocol DTOTranslator {
    associatedtype DTO: Identifiable, Equatable, Sendable & Decodable
    associatedtype Entity: Identifiable, Equatable, Sendable & Decodable
    static func translate(from dto: DTO) -> Entity
}
