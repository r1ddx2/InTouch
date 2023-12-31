//
//  UserObject.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/20.
//

import FirebaseFirestore
import UIKit

struct User: Codable {
    var userId: String
    var userName: String
    var userEmail: String?
    var userIcon: String?
    var userCover: String?
    var groups: [Group]?

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case userName = "user_name"
        case userEmail = "user_email"
        case userIcon = "user_icon"
        case userCover = "user_cover"
        case groups
    }
}
