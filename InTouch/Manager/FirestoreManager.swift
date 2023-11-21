//
//  FirestoreWrapper.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/20.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import UIKit

enum FFError: Error {
    case unknownError
    case emptyCollection
    case emptyDocument
    case updateFail
    case decodingFail
    case encodingFail
}

enum FFCollection: String {
    case groups
    case users
}

enum FFSubCollection: String {
    case archived
    case weeklyPost = "weekly_post"
}

class FirestoreManager {
    
    typealias CompletionHandler<T> = (_ result: Result<T, Error>) -> Void
    
    static let shared = FirestoreManager()
    private let db = Firestore.firestore()

    var groupsRef: CollectionReference {
        db.collection(FFCollection.groups.rawValue)
    }
    var usersRef: CollectionReference {
        db.collection(FFCollection.users.rawValue)
    }
  
    func listenCollection<T: Decodable>(
        asType: T.Type,
        reference: CollectionReference,
        completion: @escaping CompletionHandler<[T]>
    ) {
        reference.addSnapshotListener { querySnapshot, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let querySnapshot else {
                completion(.failure(FFError.unknownError))
                return
            }
            
            
            let documentDecodeResult: [Result<T, Error>] = querySnapshot.documents
                .map { document in
                    do {
                        let documentData = try document.data(as: T.self)
                        return .success(documentData)
                    } catch {
                        return .failure(error)
                    }
                }
//            
//            let documetFailures = documentDecodeResult
//            let documentData = documentDecodeResult.successfulResults()
//            if documetFailures.isEmpty {
//                completion(.success(documentData))
//            } else {
//                documetFailures.forEach { completion(.failure($0)) }
//            }
//            
        }
        
        
    }
    
    func listenToDocument<T: Decodable>(
        asType: T.Type,
        documentId: String,
        reference: CollectionReference,
        completion: @escaping CompletionHandler<T>
        
    ) {
        reference.document(documentId).addSnapshotListener { snapshot, error in
            if let error {
                completion(.failure(error))
                return
            }
            guard let snapshot else {
                completion(.failure(FFError.unknownError))
                return
            }
            guard snapshot.exists else {
                completion(.failure(FFError.emptyDocument))
                return
            }
            
            do {
                let documentData = try snapshot.data(as: T.self)
                completion(.success(documentData))
            } catch {
                completion(.failure(error))
            }
            
            
            
        }
        
    }
    
    func updateDocument(
        documentId: String,
        reference: CollectionReference,
        updateData: Codable,
        completion: @escaping CompletionHandler<String>
    ) {
        reference.document(documentId).getDocument { (document, error) in
            if let error {
                completion(.failure(error))
                return
            }
            guard let document else {
                completion(.failure(FFError.unknownError))
                return
            }
            guard document.exists else {
                completion(.failure(FFError.emptyDocument))
                return
            }
            
            do {
                
                try reference.document(documentId).setData(from: updateData, merge: true) { error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(reference.document(documentId).documentID))
                }
                
            } catch {
                completion(.failure(FFError.decodingFail))
            }
            
        }
    }
    
    func updateSubDocument(
        parentRef: CollectionReference,
        parentDocId: String,
        subCollection: String,
        subDocId: String,
        updateData: Codable,
        completion: @escaping CompletionHandler<String>
    ) {
        let parentDocRef = parentRef.document(parentDocId)
        let subDocRef = parentDocRef.collection(subCollection)
        let documentToUpdateRef = subDocRef.document(subDocId)
        do {
            let encoder = JSONEncoder()
            
            let jsonData = try encoder.encode(updateData)
            
            let data = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
            
            documentToUpdateRef.updateData(data) { error in
                if let error = error {
                    completion(.failure(FFError.updateFail))
                } else {
                    completion(.success(subDocId))
                }
            }
            
        } catch {
            completion(.failure(FFError.encodingFail))
        }

    }

    func addDocument(
        data: Codable,
        reference: CollectionReference,
        completion: @escaping CompletionHandler<String>
    ) {
        do {
            let documentReference = try reference.addDocument(from: data)
            completion(.success(documentReference.documentID))
        } catch {
            completion(.failure(error))
        }
            
    }

    func deleteDocument(
        documentID: String,
        reference: CollectionReference,
        completion: @escaping CompletionHandler<Void>
    
    ) {
        reference.document(documentID).delete { error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
            
    }
    
    
    
}