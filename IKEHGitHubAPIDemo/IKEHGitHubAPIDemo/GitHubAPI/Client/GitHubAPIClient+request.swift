//
//  GitHubAPIClient+request.swift
//  iOSEngineerCodeCheck
//
//  Created by HIROKI IKEUCHI on 2022/11/30.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
import HTTPTypes

extension GitHubAPIClient {
    struct ResponseHeaderField: Equatable, Sendable {
        let key: String
        let value: String
    }
}

extension GitHubAPIClient {
    func request<Request>(with request: Request) async throws -> (Request.ResponseBody, [ResponseHeaderField]) where Request: GitHubAPIRequestProtocol {
        // リクエストの作成と送信
        guard let httpRequest = request.buildHTTPRequest() else {
            throw GitHubAPIClientError.invalidRequest
        }
        
        let (data, httpResponse): (Data, HTTPResponse)
        do {
            if let body = request.body {
                (data, httpResponse) = try await urlSession.upload(for: httpRequest, from: body)
            } else {
                (data, httpResponse) = try await urlSession.data(for: httpRequest)
            }
        } catch {
            throw GitHubAPIClientError.connectionError(error)
        }
                    
        // レスポンスが失敗のとき
        if !(200..<300).contains(httpResponse.status.code) {
            #if DEBUG
//            let errorString = String(data: data, encoding: .utf8) ?? ""
//            print(errorString)
            #endif
            let gitHubAPIError: GitHubAPIErrorDTO
            do {
                gitHubAPIError = try JSONDecoder().decode(GitHubAPIErrorDTO.self, from: data)
            } catch {
                throw GitHubAPIClientError.responseParseError(error)
            }
            throw GitHubAPIClientError.apiError(gitHubAPIError)
        }

        // レスポンスが成功のとき
        #if DEBUG
        //        let responseString = String(data: data, encoding: .utf8) ?? ""
        //        print(responseString)
        #endif
        do {
            let response = try JSONDecoder().decode(Request.ResponseBody.self, from: data)
            return (response, httpResponse.headerFields.map { .init(key: $0.name.rawName, value: $0.value) })
        } catch {
            throw GitHubAPIClientError.responseParseError(error)
        }
    }
}
