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
    
    private func request<Request>(with request: Request) async throws(GitHubAPIClientError) -> (Data, HTTPResponse) where Request: GitHubAPIRequestProtocol {
        // リクエストの作成と送信
        guard let httpRequest = request.buildHTTPRequest() else {
            throw GitHubAPIClientError.invalidRequest
        }
        print(httpRequest.url?.absoluteString)
        
        let (data, httpResponse): (Data, HTTPResponse)
        do {
            if let body = request.body {
                (data, httpResponse) = try await urlSession.upload(for: httpRequest, from: body)
            } else {
//                do {
//                    let (data, httpResponse) = try await urlSession.data(for: httpRequest)
//                } catch {
//                    print(error.localizedDescription)
//                }
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
        let responseString = String(data: data, encoding: .utf8) ?? ""
//        print(responseString)
        print(httpResponse.headerFields)
        #endif
        
        return (data, httpResponse)
    }
    
    func search<Request, Item>(with request: Request) async throws -> SearchResponse<Item>
    where Request: GitHubAPIRequestProtocol & SearchRequestProtocol, Item: Decodable & Sendable {        
        // リクエストの作成と送信
        let (data, httpResponse): (Data, HTTPResponse) = try await self.request(with: request)
        
        // レスポンスのデータをDTOへデコード
        var response: SearchResponse<Item>
        do {
            response = try JSONDecoder().decode(SearchResponse<Item>.self, from: data)
        } catch {
            throw GitHubAPIClientError.responseParseError(error)
        }
        
        // ヘッダにページング情報があれば返り値に追加
        if let link = httpResponse.headerFields.first(where: { $0.name.rawName == "Link" }) {
            response.relationLink = RelationLink.create(rawValue: link.value)
        }
        return response
    }
}

// MARK: - OAuth用

extension GitHubAPIClient {
    func request<Request>(with request: Request) async throws(GitHubAPIClientError) -> Request.Response
    where Request: GitHubAPIRequestProtocol {
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
        
        // レスポンスのデータをDTOへデコード
        var response: Request.Response
        do {
            response = try JSONDecoder().decode(Request.Response.self, from: data)
        } catch {
            throw GitHubAPIClientError.responseParseError(error)
        }
        
        return response
    }
}
