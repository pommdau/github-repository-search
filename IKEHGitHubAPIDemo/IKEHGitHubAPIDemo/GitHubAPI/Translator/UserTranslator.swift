//
//  UserTranslator.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/07.
//

import Foundation

struct UserTranslator: DTOTranslator {
    typealias DTO = UserDTO
    typealias Entity = User
    
    static func translate(from dto: UserDTO) -> User {
        return .init(
            id: "\(dto.id)",
            name: dto.name,
            avatarImageURL: URL(string: dto.avatarImagePath),
            html: URL(string: dto.htmlPath)
        )
    }
}
