//
//  KeychainManager.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/6.
//

import KeychainAccess

class KeyChainManager {
    static let shared = KeyChainManager()

    private let service: Keychain

    private let userKey: String = "userKey"

    private init() {
        service = Keychain(service: Bundle.main.bundleIdentifier!)
    }

    var loggedInUser: User? {
        get {
            guard let userData = service[data: userKey] else {
                return nil
            }
            return try? JSONDecoder().decode(User.self, from: userData)
        }
        set {
            let uuid = UUID().uuidString
            if let encodedUser = try? JSONEncoder().encode(newValue) {
                service[data: userKey] = encodedUser
            }
        }
    }
}
