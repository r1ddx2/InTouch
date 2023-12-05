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
    case invalidDocument
    case updateFail
    case decodingFail
    case encodingFail
}

enum FFCollection: String {
    case groups
    case users
    case archived
    case newsletters
}

class FirestoreManager {
    typealias CompletionHandler<T> = (_ result: Result<T, Error>) -> Void
    
    static let shared = FirestoreManager()
    private let db = Firestore.firestore()
    // MARK: - Collection Reference
    func getRef(_ reference: FFCollection, group: String?) -> CollectionReference {
        switch reference {
        case .groups, .users: return getRef(collection: reference)
        case .newsletters, .archived: return getSubRef(subCollection: reference, from: group!)
        }
    }
    func getRefs(subCollection: FFCollection, groups: [String]) -> [CollectionReference] {
        return getRefs(subCollection: subCollection, from: groups)
    }
    
    private func getRef(collection: FFCollection) -> CollectionReference {
        db.collection(collection.rawValue)
    }
    private func getSubRef(subCollection: FFCollection, from group: String) -> CollectionReference {
        db.collection(FFCollection.groups.rawValue)
            .document(group)
            .collection(subCollection.rawValue)
    }
    private func getRefs(subCollection: FFCollection, from groups: [String]) -> [CollectionReference] {
        var references: [CollectionReference] = []
        for group in groups {
            let newsRef = db.collection(FFCollection.groups.rawValue)
                .document(group)
                .collection(subCollection.rawValue)
            print("------------")
            print("Group: \(group)")
            references.append(newsRef)
        }
        return references
    }
    // MARK: - Methods
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
                completion(.failure(FFError.invalidDocument))
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
    // MARK: - Update Document
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
    func updateNewsletter(
        documentId: String,
        reference: CollectionReference,
        updatePost: Post,
        updateNews: NewsLetter,
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
                var documentData = try document.data(as: NewsLetter.self)
             
                // Check if post already exists in the array
                if let existingIndex = documentData.posts.firstIndex(
                    where: { $0.userId == updatePost.userId }) {
                    // Exist, update post
                    documentData.posts[existingIndex] = updatePost
                } else {
                    // Don't exist, add to posts
                    documentData.posts.append(updatePost)
                }
            
                // Upload new data
                try reference.document(documentId).setData(from: documentData, merge: true) { error in
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
    // MARK: - Get Document
    func getDocument<T: Decodable>(
        asType: T.Type,
        documentId: String,
        reference: CollectionReference,
        completion: @escaping CompletionHandler<T>
        
    ) {
        reference.document(documentId).getDocument(completion: { snapshot, error in
            if let error {
                completion(.failure(error))
                return
            }
            guard let snapshot else {
                completion(.failure(FFError.unknownError))
                return
            }
            guard snapshot.exists else {
                completion(.failure(FFError.invalidDocument))
                return
            }
            
            do {
                let documentData = try snapshot.data(as: T.self)
                completion(.success(documentData))
            } catch {
                completion(.failure(error))
            }
            
        })
        
    }
    func getDocuments<T: Decodable>(
        asType: T.Type,
        documentId: String,
        references: [CollectionReference],
        completion: @escaping CompletionHandler<[T]>
    ) {
        var data: [T] = []
        let dispatchGroup = DispatchGroup()
        
        print("references: \(references)")
        for reference in references {
            dispatchGroup.enter()
            
            reference.document(documentId)
                .getDocument(completion: { (snapshot, error) in
                    
                defer {
                    dispatchGroup.leave()
                }
                if let error {
                    completion(.failure(error))
                    return
                }
                guard let snapshot else {
                    completion(.failure(FFError.unknownError))
                    return
                }
                guard snapshot.exists else {
                    completion(.failure(FFError.invalidDocument))
                    return
                }
                
                do {
                    let documentData = try snapshot.data(as: T.self)
                    data.append(documentData)
                    print(data)
                } catch {
                    completion(.failure(error))
                }
                
            })
        }
        dispatchGroup.notify(queue: .main) {
            completion(.success(data))
        }
        
    }
    
    // MARK: -
    func isDocumentExist(
        documentId: String,
        reference: CollectionReference,
        completion: @escaping CompletionHandler<String>
    ) {
        reference.getDocuments(completion: { snapshot, error in
            if let error {
                completion(.failure(error))
                return
            }
            guard let snapshot else {
                completion(.failure(FFError.unknownError))
                return
            }
            let documentExists = snapshot.documents.contains { $0.documentID == documentId }
            
            if documentExists {
                completion(.success(documentId))
            } else {
                completion(.failure(FFError.invalidDocument))
            }
            
            
        })
        
    }
    func addDocument(
        data: Codable,
        reference: CollectionReference,
        documentId: String,
        completion: @escaping CompletionHandler<String>
    ) {
        do {
           try reference.document(documentId).setData(from: data)
            
            completion(.success(documentId))
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
