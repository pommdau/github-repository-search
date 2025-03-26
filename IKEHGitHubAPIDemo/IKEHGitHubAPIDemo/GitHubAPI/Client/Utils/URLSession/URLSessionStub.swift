//
//  StubURLSession.swift
//  iOSEngineerCodeCheckTests
//
//  Created by HIROKI IKEUCHI on 2022/12/01.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//
/*
 refs:
    下記のDownload materialsからダウンロードできるコードを参照
    [iOS Unit Testing and UI Testing Tutorial](https://www.kodeco.com/21020457-ios-unit-testing-and-ui-testing-tutorial)
 
 */

import Foundation
import HTTPTypes

/// GitHubAPIClientのテストで使用するURLSessionのStub
final class URLSessionStub: URLSessionProtocol {
    
    // MARK: - Property
        
    private let stubbedData: Data?
    private let stubbedResponse: HTTPResponse?
    private let stubbedError: Error?
    
    // MARK: - LifeCycle
    
    init(
        data: Data? = nil,
        response: HTTPResponse? = nil,
        error: Error? = nil
    ) {
        self.stubbedData = data
        self.stubbedResponse = response
        self.stubbedError = error
    }
    
    // MARK: - Methods
                  
    func data(for request: HTTPRequest) async throws -> (Data, HTTPResponse) {
        // エラーを投げる場合
        if let stubbedError {
            throw stubbedError
        }
        
        // レスポンスを返す場合
        guard let stubbedData,
              let stubbedResponse else {
            fatalError("(date, response)かerrorのどちらかの値を設定してください")
        }
        return (stubbedData, stubbedResponse)
    }
    
    func upload(for request: HTTPRequest, from bodyData: Data) async throws -> (Data, HTTPResponse) {
        // エラーを投げる場合
        if let stubbedError {
            throw stubbedError
        }
        
        // レスポンスを返す場合
        guard let stubbedData,
              let stubbedResponse else {
            fatalError("(date, response)かerrorのどちらかの値を設定してください")
        }
        return (stubbedData, stubbedResponse)
    }
}
