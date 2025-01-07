//
//  User.swift
//  iOSEngineerCodeCheck
//
//  Created by HIROKI IKEUCHI on 2022/11/08.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

struct UserDTO: Identifiable, Equatable, Sendable & Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name = "login"
        case avatarImagePath = "avatar_url"
        case htmlPath = "html_url"
    }
    
    let id: Int
    let name: String
    let avatarImagePath: String
    let htmlPath: String  // e.g. https://github.com/apple
}
