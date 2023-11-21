//
//  FirestoreWrapper.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/20.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

enum FFError: Error {
    case unknownError
    case emptyCollection
    case emptyDocument
}

enum FFCollection: String {
    case groups
    case users
}

class FirestoreManager {
    typealias CompletionHandler<T> = (_ result: Result<T, Error>) -> Void

    let db = Firestore.firestore()

    var groupsRef: CollectionReference {
        db.collection(FFCollection.groups.rawValue)
    }
    var usersRef: CollectionReference {
        db.collection(FFCollection.users.rawValue)
    }

    func listenCollection<T: Decodable>(
        asType: T.Type,
        completion: @escaping CompletionHandler<[T]>,
        reference: CollectionReference
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

            let documetFailures = documentDecodeResult.failedResults()
            let documentData = documentDecodeResult.successfulResults()


            if documetFailures.isEmpty {
                completion(.success(documentData))
            } else {
                documetFailures.forEach { completion(.failure($0)) }
            }
        }
    }

    func listenToDocument<T: Decodable>(
        asType: T.Type,
        documentId: String,
        completion: @escaping CompletionHandler<T>,
        reference: CollectionReference
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

            do {
                let documentData = try snapshot.data(as: T.self)
                completion(.success(documentData))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func addDocument(
        data: Codable,
        completion: @escaping CompletionHandler<String>,
        reference: CollectionReference) {
        do {
            let documentReference = try reference.addDocument(from: data)
            completion(.success(documentReference.documentID))
        } catch {
            completion(.failure(error))
        }
    }

    func deleteDocument(
        documentID: String,
        completion: @escaping CompletionHandler<Void>,
        reference: CollectionReference) {
        reference.document(documentID).delete { error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
