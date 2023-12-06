//
//  KingFisherWrapper.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/26.
//

import UIKit
import Kingfisher

extension UIImageView {

    func loadImage(_ urlString: String?, placeHolder: UIImage? = nil) {
        guard let urlString = urlString else { return }
        let url = URL(string: urlString)
        self.kf.setImage(with: url, placeholder: placeHolder)
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
                case .success(let value):
                     
                    let downloadedImage = value.image
                   completion(.success(downloadedImage))
            
                case .failure(let error):
                 completion(.failure(error))
                   
                }
            }
        )
    }

}
