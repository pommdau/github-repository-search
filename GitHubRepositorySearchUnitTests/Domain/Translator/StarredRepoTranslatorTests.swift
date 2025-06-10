//
//  StarredRepoTranslatorTests.swift
//  GitHubRepositorySearchUnitTests
//
//  Created by HIROKI IKEUCHI on 2025/06/10.
//

@testable import GitHubRepositorySearch
import XCTest
import ConcurrencyExtras
import IKEHGitHubAPIClient

final class StarredRepoTranslatorTests: XCTestCase {
    
    /// DTO -> Entiryへの変換: 成功
    func testTranslateSuccess() async throws {
        
        // MARK: Given
        guard let testDTO: IKEHGitHubAPIClient.StarredRepo = .Mock.random(count: 1).first else {
            XCTFail("Test data generation failed.")
            return
        }
                
        // MARK: When
        let starredRepo: GitHubRepositorySearch.StarredRepo = StarredRepoTranslator.translate(from: testDTO)
        
        // MARK: Then
        XCTAssertEqual(starredRepo.isStarred, true)
        XCTAssertEqual(starredRepo.id, testDTO.id)
        XCTAssertEqual(starredRepo.starredAt, testDTO.starredAt)
    }
}
