//
//  AudioManager.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/18.
//

import UIKit
import AVFoundation


enum AudioError: Error {
    case invalidURL
    case downloadFail
    case invalidDuration
}
class AudioManager {
    
    typealias CompletionHandler<T> = (_ result: Result<T, Error>) -> Void
    static let shared = AudioManager()
    
    func downloadAudio(
        remoteURL: String,
        completion: @escaping CompletionHandler<URL>) {
        if let url = URL(string: remoteURL) {
            let request = URLRequest(url: url)
            URLSession.shared.downloadTask(with: request) { downloadedURL, urlResponse, error in
                if let error = error {
                    completion(.failure(AudioError.downloadFail))
                }
                guard let downloadedURL = downloadedURL else { return }
                
                let cachesFolderURL = try? FileManager.default.url(
                    for: .cachesDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: false
                )
                let recordingIdentifier = UUID().uuidString
                let audioFileURL = cachesFolderURL!.appendingPathComponent("\(recordingIdentifier).m4a")
                try? FileManager.default.copyItem(at: downloadedURL, to: audioFileURL)
                
                completion(.success(audioFileURL))
               
            }.resume()
            
        } else {
            completion(.failure(AudioError.invalidURL))
        }
    
    }
    func getPlayerProgress(
        player: AVPlayer,
        completion: @escaping CompletionHandler<Double>) {
            let currentTime = player.currentTime().seconds
           
            if let currentItem = player.currentItem, currentItem.duration.isValid && currentItem.duration.seconds > 0 {
                let duration = currentItem.duration.seconds
                let progress = currentTime / duration
                completion(.success(progress))
            } else {
               completion(.failure(AudioError.invalidDuration))
            }
        }
    
    
    
}
