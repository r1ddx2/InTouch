//
//  ImageBlockCollectionViewCell.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/24.
//

import UIKit


class ImageBlockView: UIView {

    // MARK: - Subview
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(resource: .apple)
        return imageView
    }()
    let captionLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 16)
        label.textColor = .ITBlack
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "去騎了腳踏車，我的手有點痛。這個星期最好玩的是我去騎了腳踏車，我的手有點痛。這個星期最好玩的是我去騎了腳踏車，我的手有點痛。這個星期最好玩的是我去騎了腳踏車，我的手有點痛。"
        return label
    }()

    // MARK: - View Load
    required init?(coder: NSCoder) {
        fatalError("Cannot create ImageCollectionViewCell")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayouts()
        setUpActions()
    }
    convenience init(image: String, caption: String) {
        self.init()
        setUpLayouts()
        setUpActions()
        imageView.loadImage(image)
        captionLabel.text = caption
    }
    private func setUpLayouts() {
        addSubview(imageView)
        addSubview(captionLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        captionLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(12)
            make.right.left.equalToSuperview()
        }
        
    }
    private func setUpActions() {
        
    }
    //MARK: - Methods
    
}
