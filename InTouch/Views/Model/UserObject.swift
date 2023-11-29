//
//  User.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/20.
//

import UIKit
import FirebaseFirestore

struct User: Codable {
    var userId: String
    var userName: String
    var userIcon: String
    var userCover: String?
    var groups: [String]?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case userName = "user_name"
        case userIcon = "user_icon"
        case userCover = "user_cover"
        case groups
    }
}
