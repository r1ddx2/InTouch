//
//  User.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/20.
//

import Foundation

struct User {
    let archived: [ArchivedPost]
    let groups: [String]
    let post: Post
}

struct ArchivedPost {
    let date: Date
    let postID: String
    let userID: String
    let userName: String
    let imageBlocks: [ImageBlock]
    let textBlocks: [TextBlock]
}

struct Post {
    let date: Date
    let postID: String
    let userID: String
    let userName: String
    let imageBlocks: [ImageBlock]
    let textBlocks: [TextBlock]
}

struct ImageBlock {
    let caption: String
    let image: String
    let location: GeoPoint
    let place: String
}

struct TextBlock {
    let title: String
    let content: String
}

struct GeoPoint {
    let latitude: Double
    let longitude: Double
}
