//
//  GitHubAPIClient+request.swift
//  iOSEngineerCodeCheck
//
//  Created by HIROKI IKEUCHI on 2022/11/30.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
import HTTPTypes

struct ResponseHeader {
    var ralationLink: RelationLink?
    
    init(headerFields: HTTPFields) {
        if let link = headerFields.first(where: { $0.name.rawName == "Link" }) {
            self.ralationLink = RelationLink.create(rawValue: link.value)
        }
    }
}

extension GitHubAPIClient {
    struct Response<Body> {
        var header: ResponseHeader
        var body: Body
    }
}

extension GitHubAPIClient {
    func request<Request>(with request: Request) async throws -> GitHubAPIClient.Response<Request.ResponseBody> where Request: GitHubAPIRequestProtocol {
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
            let responseBody = try JSONDecoder().decode(Request.ResponseBody.self, from: data)
            return Response(
                header: .init(headerFields: httpResponse.headerFields),
                body: responseBody
            )
        } catch {
            throw GitHubAPIClientError.responseParseError(error)
        }
    }
}
