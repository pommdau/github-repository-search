//
//  RepoTranslator.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/07.
//

import Foundation

struct RepoTranslator: DTOTranslator {
    typealias DTO = RepoDTO
    typealias Entity = Repo
    static func translate(from dto: RepoDTO) -> Repo {
        return .init(id: "\(dto.id)", name: dto.name, fullName: dto.fullName, owner: dto.owner, starsCount: dto.starsCount, watchersCount: dto.watchersCount, forksCount: dto.forksCount, openIssuesCount: dto.openIssuesCount, language: dto.language, description: dto.description)
    }
}
