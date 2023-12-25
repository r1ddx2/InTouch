//
//  AuthState.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/15.
//

import Foundation
import UIKit

enum AuthState {
    case emptyInput
    case emailAlreadyInUse
    case invalidEmail // wrong email format
    case weakPassword // wrong password format (6 characters)
    case wrongPassword
    case userNotFound
    case unexpectedError
    case logInSuccess
    case signUpSuccess

    var actionTitle: String {
        "OK"
    }

    var title: String {
        switch self {
        case .emptyInput, .emailAlreadyInUse,
             .invalidEmail, .weakPassword,
             .wrongPassword, .userNotFound, .unexpectedError:
            return "Error"

        case .logInSuccess, .signUpSuccess:
            return "Success"
        }
    }

    var message: String {
        switch self {
        case .emptyInput:
            return "Input should not be empty"
        case .emailAlreadyInUse:
            return "Account already exist"
        case .invalidEmail:
            return "Invalid email format"
        case .weakPassword:
            return "Password needs at least 6 characters"
        case .wrongPassword:
            return "Wrong password"
        case .userNotFound:
            return "Account doesn't exist"
        case .logInSuccess:
            return "Log in success"
        case .signUpSuccess:
            return "Sign up success"
        default:
            return "Unknown Error, try again"
        }
    }
}
