//
//  NewsletterHeaderViewCell.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/4.
//

import UIKit

class NewsletterHeaderViewCell: UITableViewCell {
    static let identifier = "\(NewsletterHeaderViewCell.self)"

    // MARK: - Subviews

    let coverImageView: UIImageView = {
        let coverImageView = UIImageView()
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.clipsToBounds = true
        return coverImageView
    }()

    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .bold(size: 22)
        titleLabel.textColor = .ITBlack
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        return titleLabel
    }()

    let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = .regular(size: 14)
        dateLabel.textColor = .ITBlack
        return dateLabel
    }()

    // MARK: - View Load

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayouts()
    }

    private func setUpLayouts() {
        contentView.addSubview(coverImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)

        coverImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.height.equalTo(100)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.bottom).offset(12)
            make.left.equalTo(contentView).offset(16)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(contentView).offset(16)
            make.bottom.equalTo(contentView).offset(-16)
        }
    }

    // MARK: - Methods

    func layoutCell(image: String, title: String, date: String) {
        coverImageView.loadImage(image)
        titleLabel.text = title
        dateLabel.text = date
    }
}
