//
//  GroupObject.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/23.
//

import UIKit
import FirebaseFirestore


struct Group: Codable {
    var groupName: String
    var groupId: String
    var groupIcon: String
    var groupCover: String
    var members: [User]
    
    enum CodingKeys: String, CodingKey {
        case groupName = "group_name"
        case groupId = "group_id"
        case groupIcon = "group_icon"
        case groupCover = "group_cover"
        case members
    }
}
