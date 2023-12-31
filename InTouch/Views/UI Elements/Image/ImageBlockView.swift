//
//  ImageBlockView.swift
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
        imageView.layer.cornerRadius = 8
        return imageView
    }()

    let placeIcon: UIButton = {
        let icon = UIButton()
        icon.setImage(UIImage(resource: .iconLocation), for: .normal)
        return icon
    }()

    let placeLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 14)
        label.textColor = .ITBlack
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    let captionLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 16)
        label.textColor = .ITBlack
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    // MARK: - View Load

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("Cannot create ImageCollectionViewCell")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayouts()
    }

    convenience init(image: String, caption: String, place: String?) {
        self.init()
        setUpLayouts()
        imageView.loadImage(image)
        captionLabel.text = caption
        if let place = place {
            placeLabel.text = place
        }
    }

    private func setUpLayouts() {
        addSubview(imageView)
        addSubview(captionLabel)
        addSubview(placeLabel)
        addSubview(placeIcon)
        placeIcon.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.height.width.equalTo(18)
        }
        placeLabel.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.left.equalTo(placeIcon.snp.right).offset(8)
        }
        imageView.snp.makeConstraints { make in
            make.top.equalTo(placeIcon.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        captionLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(12)
            make.right.left.equalToSuperview()
        }
    }

    private func resetLayout() {
        subviews.forEach { $0.removeFromSuperview() }
        addSubview(imageView)
        addSubview(captionLabel)

        imageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        captionLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(12)
            make.right.left.equalToSuperview()
        }
        layoutIfNeeded()
    }

    // MARK: - Methods
}
