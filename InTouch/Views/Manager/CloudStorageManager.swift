//
//  CloudStorageManager.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/21.
//
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

enum CSError: Error {
    case invalidType
    case uploadFail
    case downloadFail
}

class CloudStorageManager {
    typealias CompletionHandler<T> = (_ result: Result<T, Error>) -> Void
    
    static let shared = CloudStorageManager()
    private let storage = Storage.storage()
    private let db = Firestore.firestore()
    
    // MARK: - Upload Image
    
    func uploadImages(
        fileUrl: URL,
        userId: String,
        completion: @escaping CompletionHandler<String>
    ) {
        
        let timestamp = Int(Date().timeIntervalSince1970 * 1000)
        let fileExtension = fileUrl.pathExtension
        let filePath = "\(userId)/\(timestamp).\(fileExtension)"
        let storageRef = storage.reference().child(filePath)
        
        storageRef.putFile(
            from: fileUrl,
            metadata: nil,
            completion: { (storageMetaData, error) in
                if let error = error {
                    completion(.failure(CSError.uploadFail))
                    return
                }
                
                storageRef.downloadURL { (url, error) in
                    if let error = error  {
                        completion(.failure(CSError.downloadFail))
                        return
                    }
                    if let urlString = url?.absoluteString {
                        completion(.success(urlString))
                        return
                    }
                    completion(.failure(CSError.invalidType))
                }
                
        })
        
    }
         
    func uploadGroupImages(
        fileUrl: URL,
        groupId: String,
        completion: @escaping CompletionHandler<String>
    ) {
        
        let timestamp = Int(Date().timeIntervalSince1970 * 1000)
        let fileExtension = fileUrl.pathExtension
        let filePath = "\(groupId)/\(timestamp).\(fileExtension)"
        let storageRef = storage.reference().child(filePath)
        
        storageRef.putFile(
            from: fileUrl,
            metadata: nil,
            completion: { (storageMetaData, error) in
                if let error = error {
                    completion(.failure(CSError.uploadFail))
                    return
                }
                
                storageRef.downloadURL { (url, error) in
                    if let error = error  {
                        completion(.failure(CSError.downloadFail))
                        return
                    }
                    if let urlString = url?.absoluteString {
                        completion(.success(urlString))
                        return
                    }
                    completion(.failure(CSError.invalidType))
                }
                
        })
        
    }
    // MARK: - Audio
    
    func uploadAudio(
        fileUrl: URL,
        userId: String,
        completion: @escaping CompletionHandler<String>
    ) {
        let timestamp = Int(Date().timeIntervalSince1970 * 1000)
        let fileExtension = fileUrl.pathExtension
        let filePath = "\(userId)/\(timestamp).\(fileExtension)"
        let storageRef = storage.reference().child(filePath)
        
        storageRef.putFile(
            from: fileUrl,
            metadata: nil,
            completion: { (storageMetaData, error) in
                if let error = error {
                    completion(.failure(CSError.uploadFail))
                    return
                }
                
                storageRef.downloadURL { (url, error) in
                    if let error = error  {
                        completion(.failure(CSError.downloadFail))
                        return
                    }
                    if let urlString = url?.absoluteString {
                        completion(.success(urlString))
                        return
                    }
                    completion(.failure(CSError.invalidType))
                }
                
        })
        
    }
}

