//
//  AuthManager.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/15.
//

import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import UIKit

class AuthManager {
    static let shared = AuthManager()

    var alertState: AuthState = .unexpectedError

    var userID: String?
    var userEmail: String?
    var currentUser: User?

    func signUp(userInput: Info, completion: @escaping (Result<String, Error>) -> Void) {
        guard !userInput.email.isEmpty, !userInput.password.isEmpty else {
            alertState = AuthState.emptyInput
            return
        }

        Auth.auth().createUser(
            withEmail: userInput.email,
            password: userInput.password
        ) { authResult, error in
            if let error = error as? NSError {
                switch error.code {
                case AuthErrorCode.emailAlreadyInUse.rawValue:
                    self.alertState = AuthState.emailAlreadyInUse

                case AuthErrorCode.invalidEmail.rawValue:
                    self.alertState = AuthState.invalidEmail

                case AuthErrorCode.weakPassword.rawValue:
                    self.alertState = AuthState.weakPassword

                default:
                    print("Error: \(error.localizedDescription)")
                }
                completion(.failure(error))
            }

            guard let authResult = authResult, let email = authResult.user.email else {
                return
            }

            self.alertState = AuthState.signUpSuccess
            completion(.success(email))
        }
    }

    func logIn(userInput: Info, completion: @escaping (Result<String, Error>) -> Void) {
        guard !userInput.email.isEmpty, !userInput.password.isEmpty else {
            alertState = AuthState.emptyInput
            return
        }

        Auth.auth().signIn(
            withEmail: userInput.email,
            password: userInput.password
        ) { authResult, error in

            if let error = error as? NSError {
                switch error.code {
                case AuthErrorCode.wrongPassword.rawValue:
                    self.alertState = AuthState.wrongPassword

                case AuthErrorCode.userNotFound.rawValue:
                    self.alertState = AuthState.userNotFound

                default:
                    print("Error: \(error)")
                }
                completion(.failure(error))
            }

            guard let authResult = authResult, let email = authResult.user.email else {
                return
            }

            self.alertState = AuthState.logInSuccess
            completion(.success(email))
        }
    }
}
