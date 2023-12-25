//
//  KingFisherWrapper.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/26.
//

import Kingfisher
import UIKit

extension UIImageView {
    func loadImage(_ urlString: String?, placeHolder: UIImage? = nil) {
        guard let urlString = urlString else { return }
        let url = URL(string: urlString)
        kf.setImage(with: url, placeholder: placeHolder)
    }
}

class KingFisherWrapper {
    static let shared = KingFisherWrapper()
    let imageDownloader = ImageDownloader.default
    func downloadImage(url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let imageUrl = URL(string: url)!

        imageDownloader.downloadImage(
            with: imageUrl,
            options: [],
            progressBlock: nil,
            completionHandler: { result in
                switch result {
                case let .success(value):

                    let downloadedImage = value.image
                    completion(.success(downloadedImage))

                case let .failure(error):
                    completion(.failure(error))
                }
            }
        )
    }
}
