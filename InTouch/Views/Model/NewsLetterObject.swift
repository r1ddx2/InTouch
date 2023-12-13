//
//  NewsLetterObject.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/23.
//


import UIKit
import FirebaseFirestore


struct NewsLetter: Codable {
    var date: Date
    var newsId: String
    var newsCover: String
    var posts: [Post]
    var title: String
    
    enum CodingKeys: String, CodingKey {
        case date
        case newsId = "news_id"
        case newsCover = "news_cover"
        case posts
        case title
    }
    
}

struct Post: Codable {
    var date: Date = Date()
    var postId: String = ""
    var userId: String = ""
    var userIcon: String = ""
    var userName: String = ""
    var imageBlocks: [ImageBlock] = []
    var textBlocks: [TextBlock] = []
    
    enum CodingKeys: String, CodingKey {
        case date
        case postId = "post_id"
        case userId = "user_id"
        case userIcon = "user_icon"
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

