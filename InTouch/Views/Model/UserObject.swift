//
//  User.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/20.
//

import UIKit
import FirebaseFirestore

struct User: Codable {
    var userID: String
    var userName: String
    var userIcon: String
    var userCover: String
    var archived: [ArchivedPost]?
    var groups: [String]?
    var weeklyPost: [Post]?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case userName = "user_name"
        case userIcon = "user_icon"
        case userCover = "user_cover"
        case archived
        case groups
        case weeklyPost = "weekly_post"
    }
}

struct ArchivedPost: Codable {
    var date: Date
    var postID: String
    var userID: String
    var userName: String
    var imageBlocks: [ImageBlock]
    var textBlocks: [TextBlock]
}

struct Post: Codable {
    var date: Timestamp
    var postID: String
    var userID: String
    var userName: String
    var imageBlocks: [ImageBlock]
    var textBlocks: [TextBlock]
    
    enum CodingKeys: String, CodingKey {
        case date
        case postID = "post_id"
        case userID = "user_id"
        case userName = "user_name"
        case imageBlocks = "image_blocks"
        case textBlocks = "text_blocks"
       
    }
}

struct ImageBlock: Codable {
    var caption: String
    var image: String
    var location: GeoPoint?
    var place: String?
    
    enum CodingKeys: String, CodingKey {
        case caption
        case image
        case location
        case place
    }
}

struct TextBlock: Codable {
    var title: String
    var content: String
}

