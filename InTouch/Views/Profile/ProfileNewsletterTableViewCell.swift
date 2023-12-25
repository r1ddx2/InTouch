//
//  ProfileNewsletterTableViewCell.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/11.
//

import UIKit

class ProfileNewsletterTableViewCell: UITableViewCell {
    static let identifier = "\(ProfileNewsletterTableViewCell.self)"

    var newsletter: NewsLetter? {
        didSet {
            layoutCell()
        }
    }

    // MARK: - Subview

    let letterCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    let letterTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .ITBlack
        label.font = .medium(size: 16)
        return label
    }()

    let letterDateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .ITBlack
        label.font = .regular(size: 14)
        return label
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
        contentView.addSubview(letterCoverImageView)
        contentView.addSubview(letterTitleLabel)
        contentView.addSubview(letterDateLabel)

        letterCoverImageView.snp.makeConstraints { make in
            make.top.left.bottom.equalTo(contentView)
            make.height.width.equalTo(80)
        }
        letterTitleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(letterCoverImageView.snp.centerY).offset(-5)
            make.left.equalTo(letterCoverImageView.snp.right).offset(16)
            make.right.equalTo(contentView.snp.right).offset(-16)
        }
        letterDateLabel.snp.makeConstraints { make in
            make.top.equalTo(letterCoverImageView.snp.centerY).offset(5)
            make.left.equalTo(letterCoverImageView.snp.right).offset(16)
            make.right.equalTo(contentView.snp.right).offset(-16)
        }
    }

    // MARK: - Methods

    func layoutCell() {
        guard let newsletter = newsletter else { return }
        letterCoverImageView.loadImage(newsletter.newsCover)
        letterTitleLabel.text = newsletter.title
        letterDateLabel.text = newsletter.date.getThisWeekDateRange()
    }
}
