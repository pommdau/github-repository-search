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
    
    func request<Request>(with request: Request) async throws(GitHubAPIClientError) -> (Data, HTTPResponse) where Request: GitHubAPIRequestProtocol {
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
            let gitHubAPIError: GitHubAPIError
            do {
                gitHubAPIError = try JSONDecoder().decode(GitHubAPIError.self, from: data)
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
        
        return (data, httpResponse)
    }
        
    func search<Request>(with request: Request) async throws -> Request.SearchResponseType where Request: GitHubAPIRequestProtocol {
        // リクエストの作成と送信
        let (data, httpResponse): (Data, HTTPResponse) = try await self.request(with: request)
        
        // レスポンスのデータをDTOへデコード
        var searchResponse: Request.SearchResponseType
        do {
            searchResponse = try JSONDecoder().decode(Request.SearchResponseType.self, from: data)
        } catch {
            throw GitHubAPIClientError.responseParseError(error)
        }
        
        // ヘッダにページング情報があれば返り値に追加
        if let link = httpResponse.headerFields.first(where: { $0.name.rawName == "Link" }) {
            searchResponse.relationLink = RelationLink.create(rawValue: link.value)
        }
        
        return searchResponse
    }
    
    func request<Request>(with request: Request) async throws(GitHubAPIClientError) -> (Data, HTTPResponse) where Request: NewGitHubAPIRequestProtocol {
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
            let gitHubAPIError: GitHubAPIError
            do {
                gitHubAPIError = try JSONDecoder().decode(GitHubAPIError.self, from: data)
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
        
        return (data, httpResponse)
    }
}
