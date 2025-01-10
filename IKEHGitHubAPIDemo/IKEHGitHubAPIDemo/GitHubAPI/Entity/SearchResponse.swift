//
//  SearchResponse.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/07.
//

import Foundation
import struct HTTPTypes.HTTPFields

/*
 x-github-request-id: F16F:3AF5C4:372690:3F327A:677CE900
 x-ratelimit-reset: 1736239420
 x-ratelimit-resource: search
 Link: <https://api.github.com/search/repositories?q=swift&page=2>; rel="next", <https://api.github.com/search/repositories?q=swift&page=34>; rel="last"
 x-ratelimit-used: 1
 Access-Control-Allow-Origin: *
 Date: Tue, 07 Jan 2025 08:42:41 GMT
 x-github-media-type: github.v3; format=json
 Vary: Accept,Accept-Encoding, Accept, X-Requested-With
 Strict-Transport-Security: max-age=31536000; includeSubdomains; preload
 x-github-api-version-selected: 2022-11-28
 x-ratelimit-limit: 10
 Accept-Ranges: bytes
 content-security-policy: default-src 'none'
 x-ratelimit-remaining: 9
 x-frame-options: deny
 Content-Type: application/json; charset=utf-8
 Server: github.com
 x-xss-protection: 0
 referrer-policy: origin-when-cross-origin, strict-origin-when-cross-origin
 x-content-type-options: nosniff
 Content-Encoding: gzip
 Cache-Control: no-cache
 access-control-expose-headers: ETag, Link, Location, Retry-After, X-GitHub-OTP, X-RateLimit-Limit, X-RateLimit-Remaining, X-RateLimit-Used, X-RateLimit-Resource, X-RateLimit-Reset, X-OAuth-Scopes, X-Accepted-OAuth-Scopes, X-Poll-Interval, X-GitHub-Media-Type, X-GitHub-SSO, X-GitHub-Request-Id, Deprecation, Sunset
 */

//struct SearchResponseHeader: Equatable, Sendable {
//    var ralationLink: RelationLink?
//}
//
//struct SearchResponse<Item>: Equatable, Sendable where Item: Equatable & Sendable {
//    var header: SearchResponseHeader
//    var items: [Item]
//    
//    init(headerFields: HTTPFields, items: [Item]) {
//        self.header = HTTPFieldsTranslator.translate(from: headerFields)
//        self.items = items
//    }
//}
