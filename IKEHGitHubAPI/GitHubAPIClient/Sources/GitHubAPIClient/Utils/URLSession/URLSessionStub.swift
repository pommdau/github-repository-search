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
    
    /// ダミーの成功データを返すStubの作成
    init() {
        self.stubbedData = "dummy data".data(using: .utf8)
        self.stubbedResponse = .init(status: .ok)
        self.stubbedError = nil
    }
    
    /// 指定したレスポンスを返すStubの作成
    init(data: Data? = nil, response: HTTPResponse? = nil) {
        self.stubbedData = data
        self.stubbedResponse = response
        self.stubbedError = nil
    }
    
    /// 指定したエラーをthrowするStubの作成
    init(error: Error? = nil) {
        self.stubbedData = nil
        self.stubbedResponse = nil
        self.stubbedError = error
    }
    
    // MARK: - Connection Methods
                  
    func data(for request: HTTPRequest) async throws -> (Data, HTTPResponse) {
        if let stubbedError {
            throw stubbedError
        }
        
        guard let stubbedData,
              let stubbedResponse else {
            fatalError("Invalid Property")
        }
        return (stubbedData, stubbedResponse)
    }
    
    func upload(for request: HTTPRequest, from bodyData: Data) async throws -> (Data, HTTPResponse) {
        if let stubbedError {
            throw stubbedError
        }
        
        // レスポンスを返す場合
        guard let stubbedData,
              let stubbedResponse else {
            fatalError("Invalid Property")
        }
        return (stubbedData, stubbedResponse)
    }
}
