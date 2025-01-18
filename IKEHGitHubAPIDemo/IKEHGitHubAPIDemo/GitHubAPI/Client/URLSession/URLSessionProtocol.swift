//
//  URLSessionProtocol.swift
//  iOSEngineerCodeCheck
//
//  Created by HIROKI IKEUCHI on 2022/12/01.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
import HTTPTypes

protocol URLSessionProtocol {
    func data(for request: HTTPRequest) async throws -> (Data, HTTPResponse)
    func upload(for request: HTTPRequest, from bodyData: Data) async throws -> (Data, HTTPResponse)
}
