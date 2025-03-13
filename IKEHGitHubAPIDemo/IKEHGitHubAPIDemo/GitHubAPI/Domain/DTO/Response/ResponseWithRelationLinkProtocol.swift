//
//  ResponseWithRelationLink.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/27.
//

import Foundation

// TODO ResponseProtocolくらいにまとめても良さそう
protocol ResponseWithRelationLinkProtocol {
    var relationLink: RelationLink? { get set } // ページング情報
}
