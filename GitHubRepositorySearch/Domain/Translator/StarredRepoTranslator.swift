//
//  StarredRepoTranslator.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/08.
//

import Foundation
import struct IKEHGitHubAPIClient.StarredRepo

enum StarredRepoTranslator {
    /// 外部ライブラリのDTO -> アプリのEntiryに変換
    static func translate(from dto: IKEHGitHubAPIClient.StarredRepo) -> StarredRepo {
        StarredRepo(
            repoID: dto.repo.id,
            starredAt: dto.starredAt,
            isStarred: true
        )
    }
}
