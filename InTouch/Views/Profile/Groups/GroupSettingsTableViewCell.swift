//
//  GroupSettingsTableViewCell.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/11.
//

import UIKit

class GroupSettingsTableViewCell: UITableViewCell {
    static let identifier = "\(GroupSettingsTableViewCell.self)"
    var user: User? {
        didSet {
            layoutCell()
        }
    }

    var removeMemberHandler: ((Bool) -> Void)?
    var isRemove: Bool = true

    // MARK: - Subview

    let userIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .iconProfileSelected)
        imageView.layer.cornerRadius = 25
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .medium(size: 15)
        label.textColor = .ITBlack
        return label
    }()

    let userIdLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 14)
        label.textColor = .ITBlack
        return label
    }()

    let removeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Remove", for: .normal)
        button.backgroundColor = .ITYellow
        button.setTitleColor(.ITBlack, for: .normal)
        button.cornerRadius = 8
        button.titleLabel?.font = .regular(size: 12)
        return button
    }()

    // MARK: - View Load

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayouts()
        setUpActions()
    }

    private func setUpLayouts() {
        contentView.addSubview(userIconView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(userIdLabel)
        contentView.addSubview(removeButton)

        userIconView.snp.makeConstraints { make in
            make.height.width.equalTo(50)
            make.centerY.equalTo(contentView.snp.centerY)
            make.left.equalTo(contentView).offset(24)
        }
        userNameLabel.snp.makeConstraints { make in
            make.left.equalTo(userIconView.snp.right).offset(16)
            make.bottom.equalTo(userIconView.snp.centerY).offset(-1)
        }
        userIdLabel.snp.makeConstraints { make in
            make.left.equalTo(userIconView.snp.right).offset(16)
            make.top.equalTo(userIconView.snp.centerY).offset(1)
        }
        removeButton.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.width.equalTo(60)
            make.centerY.equalTo(userIconView.snp.centerY)
            make.right.equalTo(contentView).offset(-24)
        }
    }

    private func setUpActions() {
        removeButton.addTarget(self, action: #selector(removeUserTapped), for: .touchUpInside)
    }

    // MARK: - Methods

    func layoutCell() {
        guard let user = user else { return }
        userIconView.loadImage(user.userIcon)
        userNameLabel.text = user.userName
        userIdLabel.text = "@\(user.userId)"
    }

    @objc func removeUserTapped() {
        removeMemberHandler?(isRemove)
        updateButtonUI()
        if isRemove {
            isRemove = false
        } else {
            isRemove = true
        }
    }

    func updateButtonUI() {
        if isRemove {
            removeButton.setTitleColor(.white, for: .normal)
            removeButton.backgroundColor = .ITBlack
            removeButton.setTitle("Add", for: .normal)
        } else {
            removeButton.setTitleColor(.ITBlack, for: .normal)
            removeButton.backgroundColor = .ITYellow
            removeButton.setTitle("Remove", for: .normal)
        }
    }
}
