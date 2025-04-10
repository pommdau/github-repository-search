//
//  RepoTest.swift
//  IKEHGitHubAPIDemoTests
//
//  Created by HIROKI IKEUCHI on 2025/03/28.
//

import Foundation
import XCTest
@testable import IKEHGitHubAPIDemo

final class MappingModelTest: XCTestCase {

    /// JSON文字列 -> Repoへのデコードのテスト
    func testRepoDecodeSuccess() throws {
        
        // MARK: Given
        let testJsonString = Repo.Mock.JsonString.sample
        guard let testData = testJsonString.data(using: .utf8) else {
            XCTFail("Falied to convert JSON string to Data")
            return
        }
        
        // MARK: When
        let repo = try JSONDecoder().decode(Repo.self, from: testData)
        
        // MARK: Then
        // 各プロパティ値の確認
        // repo.ownerに関してはUser側の同種のテストで担保する
        XCTAssertEqual(repo.rawID, 44838949)
        XCTAssertEqual(repo.name, "swift")
        XCTAssertEqual(repo.fullName, "swiftlang/swift")
        XCTAssertEqual(repo.starsCount, 68269)
        XCTAssertEqual(repo.watchersCount, 68269)
        XCTAssertEqual(repo.forksCount, 10441)
        XCTAssertEqual(repo.openIssuesCount, 8110)
        XCTAssertEqual(repo.language, "C++")
        XCTAssertEqual(repo.htmlPath, "https://github.com/swiftlang/swift")
        XCTAssertEqual(repo.websitePath, "https://swift.org")
        XCTAssertEqual(repo.description, "The Swift Programming Language")
        XCTAssertEqual(repo.createdAt, "2015-10-23T21:15:07Z")
        XCTAssertEqual(repo.updatedAt, "2025-03-28T03:02:18Z")
    }

}
