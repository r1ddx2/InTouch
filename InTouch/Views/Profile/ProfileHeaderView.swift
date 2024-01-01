//
//  ProfileHeaderView.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/8.
//

import UIKit

class ProfileHeaderView: UIView {
    // MARK: - Subviews

    let userIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.cornerRadius = 35
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        imageView.layer.shadowRadius = 4
        imageView.layer.shadowOpacity = 0.2
        imageView.borderColor = .ITVeryLightGrey
        imageView.borderWidth = 1.0
        return imageView
    }()

    let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .bold(size: 20)
        label.textColor = .ITBlack
        return label
    }()

    let userIdLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 14)
        label.textColor = .ITBlack
        return label
    }()

    let groupsLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 13)
        label.textColor = .ITBlack
        label.text = "Groups"
        return label
    }()

    let groupsCountLabel: UILabel = {
        let label = UILabel()
        label.font = .medium(size: 17)
        label.textColor = .ITBlack
        return label
    }()

    let postsLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 13)
        label.textColor = .ITBlack
        label.text = "Posts"
        return label
    }()

    let postsCountLabel: UILabel = {
        let label = UILabel()
        label.font = .medium(size: 17)
        label.textColor = .ITBlack
        label.text = "25"
        return label
    }()

    let editProfileButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ITVeryLightGrey
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.ITBlack, for: .normal)
        button.titleLabel?.font = .medium(size: 13)
        button.cornerRadius = 8
        return button
    }()

    // MARK: - View Load

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayouts()
    }

    private func setUpLayouts() {
        addSubview(userIconView)
        addSubview(userNameLabel)
        addSubview(userIdLabel)
        addSubview(groupsLabel)
        addSubview(groupsCountLabel)
        addSubview(postsLabel)
        addSubview(postsCountLabel)
        addSubview(editProfileButton)

        userIconView.snp.makeConstraints { make in
            make.height.width.equalTo(70)
            make.top.equalTo(self)
            make.left.equalTo(self).offset(16)
        }
        userNameLabel.snp.makeConstraints { make in
            make.left.equalTo(userIconView.snp.right).offset(16)
            make.bottom.equalTo(userIconView.snp.centerY).offset(-2)
        }
        userIdLabel.snp.makeConstraints { make in
            make.left.equalTo(userIconView.snp.right).offset(16)
            make.top.equalTo(userIconView.snp.centerY).offset(2)
        }
        editProfileButton.snp.makeConstraints { make in
            make.left.equalTo(self).offset(24)
            make.top.equalTo(userIconView.snp.bottom).offset(24)
            make.height.equalTo(30)
            make.right.equalTo(self).offset(-24)
        }
        groupsLabel.snp.makeConstraints { make in
            make.centerY.equalTo(userIdLabel.snp.centerY)
            make.right.equalTo(editProfileButton.snp.right).offset(-32)
        }
        groupsCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(userNameLabel.snp.centerY)
            make.centerX.equalTo(groupsLabel.snp.centerX)
        }
        postsLabel.snp.makeConstraints { make in
            make.centerY.equalTo(userIdLabel.snp.centerY)
            make.right.equalTo(groupsLabel.snp.left).offset(-32)
        }
        postsCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(userNameLabel.snp.centerY)
            make.centerX.equalTo(postsLabel.snp.centerX)
        }
    }

    // MARK: - Methods

    func layoutView(with user: User) {
        guard let groups = user.groups else { return }
        userIconView.loadImage(user.userIcon)
        userNameLabel.text = "\(user.userName)"
        userIdLabel.text = "@\(user.userId)"
        groupsCountLabel.text = "\(groups.count)"
    }
}
