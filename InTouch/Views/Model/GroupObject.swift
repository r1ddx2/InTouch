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
    var groupIcon: String? = "https://firebasestorage.googleapis.com/v0/b/intouch-da0b8.appspot.com/o/default%2FgroupIcons%2Fdefault5.png?alt=media&token=4f24c8d8-6616-459e-8107-3a5abb2d16be"
    var groupCover: String? = "https://firebasestorage.googleapis.com/v0/b/intouch-da0b8.appspot.com/o/default%2FgroupCovers%2Fapple.png?alt=media&token=0b159cf9-f7a1-4c23-a8bc-c3cc78943e89"
    var members: [User]?
    
    enum CodingKeys: String, CodingKey {
        case groupName = "group_name"
        case groupId = "group_id"
        case groupIcon = "group_icon"
        case groupCover = "group_cover"
        case members
    }
}
