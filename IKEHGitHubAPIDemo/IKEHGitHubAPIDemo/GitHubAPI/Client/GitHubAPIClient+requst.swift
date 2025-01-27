//
//  GitHubAPIClient+requst.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import Foundation
import HTTPTypes

// MARK: - Public

extension GitHubAPIClient {
                
    func noResponseRequest<Request>(with request: Request) async throws where Request: GitHubAPIRequestProtocol {
        let (data, httpResponse) = try await sendRequest(with: request)
        try checkResponseForOAuth(data: data, httpResponse: httpResponse)
    }
    
    func defaultRequest<Request>(with request: Request) async throws -> Request.Response where Request: GitHubAPIRequestProtocol {
        let (data, httpResponse) = try await sendRequest(with: request)
        try checkResponseDefault(data: data, httpResponse: httpResponse)
        let response: Request.Response = try decodeResponse(data: data, httpResponse: httpResponse)
        return response
    }
    
    func oauthRequest<Request>(with request: Request) async throws -> Request.Response where Request: GitHubAPIRequestProtocol {
        let (data, httpResponse) = try await sendRequest(with: request)
        try checkResponseForOAuth(data: data, httpResponse: httpResponse)
        let response: Request.Response = try decodeResponse(data: data, httpResponse: httpResponse)
        return response
    }
//        
//    func searchRequest<Request, Item>(with request: Request) async throws
//    -> SearchResponse<Item> where Request: GitHubAPIRequestProtocol, Item: Decodable & Sendable {
//        let (data, httpResponse) = try await sendRequest(with: request)
//        try checkResponseDefault(data: data, httpResponse: httpResponse)
//        let response: SearchResponse<Item> = try decodeResponse(data: data, httpResponse: httpResponse)
//        return response
//    }
//    
//    func starredRepoRequest<Request>(with request: Request) async throws
//    -> ListResponse<Repo> where Request: GitHubAPIRequestProtocol {
//        let (data, httpResponse) = try await sendRequest(with: request)
//        try checkResponseDefault(data: data, httpResponse: httpResponse)
//        let response: ListResponse<Repo> = try decodeResponse(data: data, httpResponse: httpResponse)
//        return response
//    }
}

// MARK: - Helpers

extension GitHubAPIClient {
            
    // MARK: Send Request
    
    private func sendRequest<Request: GitHubAPIRequestProtocol>(with request: Request) async throws -> (Data, HTTPResponse) {
        // リクエストの作成
        guard let httpRequest = request.buildHTTPRequest() else {
            throw GitHubAPIClientError.invalidRequest
        }

        // リクエストの送信
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
                                
        return (data, httpResponse)
    }
    
    // MARK: Check Response Success/Fail
    
    private func checkResponseDefault(data: Data, httpResponse: HTTPResponse) throws {
        // 200番台であれば成功
        if (200..<300).contains(httpResponse.status.code) {
            return
        }
        
        let errorResponse: GitHubAPIError
        do {
            errorResponse = try JSONDecoder().decode(GitHubAPIError.self, from: data)
        } catch {
            // 未対応のエラーレスポンス(通常通らない)
            print(String(data: data, encoding: .utf8)!)
            throw GitHubAPIClientError.responseParseError(error)
        }
        throw GitHubAPIClientError.apiError(errorResponse)
    }
    
    private func checkResponseForOAuth(data: Data, httpResponse: HTTPResponse) throws {
        /**
         OAuthの仕様で失敗時にも200番が返ってくる
         /そのためレスポンスがエラーの形式かどうかで確認する
         */
                
        let oAuthError: OAuthError
        do {
            oAuthError = try JSONDecoder().decode(OAuthError.self, from: data)
        } catch {
            // エラーの形式でないなら成功レスポンス
            return
        }
        throw GitHubAPIClientError.apiError(oAuthError)
    }
    
    // MARK: Decode Response
    
    /// レスポンスのデータをDTOへデコード
    private func decodeResponse<Response: Decodable>(data: Data, httpResponse: HTTPResponse) throws -> Response {
        var response: Response
        do {
            response = try JSONDecoder().decode(Response.self, from: data)
        } catch {
            throw GitHubAPIClientError.responseParseError(error)
        }
        response = try Self.attachRelationLink(to: response, from: httpResponse)
        return response
    }
    
    static private func attachRelationLink<Response>(to response: Response, from httpResponse: HTTPResponse) throws -> Response {
        if var responseWithRelationLink = response as? ResponseWithRelationLink,
           let link = httpResponse.headerFields.first(where: { $0.name.rawName == "Link" }) {
            // Responseにページング情報を付与
            responseWithRelationLink.relationLink = RelationLink.create(rawValue: link.value)
            guard let responseWithRelationLink = (responseWithRelationLink as? Response) else {
                throw GitHubAPIClientError.responseParseError(MessageError(description: "ページング情報の取得に失敗しました"))
            }
            return responseWithRelationLink
        } else {
            return response
        }
    }
}
