//
//  IconsCollectionViewCell.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/8.
//
import UIKit

class IconsCollectionViewCell: UICollectionViewCell {
    static let identifier = "\(IconsCollectionViewCell.self)"

    // MARK: - Subview

    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.cornerRadius = 30
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        imageView.layer.shadowRadius = 4
        imageView.layer.shadowOpacity = 0.2
        imageView.borderColor = .ITVeryLightGrey
        imageView.borderWidth = 1.0
        return imageView
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 10)
        label.textColor = .ITBlack
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    // MARK: - View Load

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayouts()
    }

    private func setUpLayouts() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)

        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.centerX.equalTo(contentView.snp.centerX)
            make.height.width.equalTo(60)
        }
        nameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(contentView)
            make.centerX.equalTo(iconImageView.snp.centerX)
        }
    }

    func layoutCell(group: Group) {
        iconImageView.loadImage(group.groupIcon)
        nameLabel.text = "\(group.groupName)"
    }

    func layoutCell(user: User) {
        iconImageView.loadImage(user.userIcon)
        nameLabel.text = "\(user.userName)"
        nameLabel.font = .regular(size: 12)
    }
}
