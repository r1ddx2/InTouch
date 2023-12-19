//
//  FakeData.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/30.
//

import Foundation



class FakeData {

    
        static var userRed = User(
        userId: "r1ddx",
        userName: "Red",
        userEmail: "r1ddx09@gmail.com",
        userIcon: "https://firebasestorage.googleapis.com:443/v0/b/intouch-da0b8.appspot.com/o/r1ddx%2F1701221724625.jpeg?alt=media&token=e3317296-edd0-4bc4-bbfe-936ac3ad8d8d"
    )
    static var postId: String {
        UUID().uuidString
    }
    
    static var userPanda = User(
        userId: "panda666",
        userName: "Panda",
        userEmail: "panda666@gmail.com",
        userIcon: "https://firebasestorage.googleapis.com:443/v0/b/intouch-da0b8.appspot.com/o/r1ddx%2F1701221470497.png?alt=media&token=f1a72527-1dc1-461d-81e0-562ff3466a3c"
    )
    
    
}
