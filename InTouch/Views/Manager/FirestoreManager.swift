//
//  FirestoreManager.swift
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

    func getRef(_ reference: FFCollection, groupId: String? = nil) -> CollectionReference {
        switch reference {
        case .groups, .users: return getRef(collection: reference)
        case .newsletters, .archived: return getSubRef(subCollection: reference, from: groupId!)
        }
    }

    func getRefs(subCollection: FFCollection, groupIds: [String]) -> [CollectionReference] {
        getRefs(subCollection: subCollection, from: groupIds)
    }

    private func getRef(collection: FFCollection) -> CollectionReference {
        db.collection(collection.rawValue)
    }

    private func getSubRef(subCollection: FFCollection, from groupId: String) -> CollectionReference {
        db.collection(FFCollection.groups.rawValue)
            .document(groupId)
            .collection(subCollection.rawValue)
    }

    private func getRefs(subCollection: FFCollection, from groupIds: [String]) -> [CollectionReference] {
        groupIds.map { group in
            let newsRef = db.collection(FFCollection.groups.rawValue)
                .document(group)
                .collection(subCollection.rawValue)
            return newsRef
        }
    }

    // MARK: - Get Document

    func listenDocument<T: Decodable>(
        asType _: T.Type,
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

    func getDocument<T: Decodable>(
        asType _: T.Type,
        documentId: String,
        reference: CollectionReference,
        completion: @escaping CompletionHandler<T>

    ) {
        reference.document(documentId).getDocument { snapshot, error in
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

    func getDocuments<T: Decodable>(
        asType _: T.Type,
        reference: CollectionReference,
        completion: @escaping CompletionHandler<[T]>

    ) {
        reference.getDocuments { querySnapshot, error in
            if let error {
                completion(.failure(error))
                return
            }
            guard let querySnapshot else {
                completion(.failure(FFError.unknownError))
                return
            }

            do {
                var data: [T] = []
                for document in querySnapshot.documents {
                    let documentData = try document.data(as: T.self)
                    data.append(documentData)
                }
                completion(.success(data))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func getDifferentDocs<T: Decodable>(
        asType _: T.Type,
        documentId: String,
        references: [CollectionReference],
        completion: @escaping CompletionHandler<[T]>
    ) {
        var data: [T] = []

        for reference in references {
            reference.document(documentId)
                .getDocument(completion: { snapshot, error in

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

                    } catch {
                        completion(.failure(error))
                    }

                })
        }
    }

    // MARK: - Modify Document

    func updateDocument(
        documentId: String,
        reference: CollectionReference,
        updateData: Codable,
        completion: @escaping CompletionHandler<String>
    ) {
        reference.document(documentId).getDocument { document, error in
            if let error {
                completion(.failure(error))
                return
            }
            guard let document else {
                completion(.failure(FFError.unknownError))
                return
            }
            // If document don't exist, create document
            guard document.exists else {
                do {
                    try reference.document(documentId).setData(from: updateData)

                    completion(.success(documentId))
                } catch {
                    completion(.failure(FFError.decodingFail))
                }
                return
            }
            // If exist, update document
            do {
                try
                    reference.document(documentId).setData(from: updateData, merge: false) { error in
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
