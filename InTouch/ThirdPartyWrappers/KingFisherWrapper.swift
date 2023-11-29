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
