//
//  MemberProfileViewController.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/25.
//
import UIKit

class MemberProfileViewController: ITBaseViewController {
    var user: User? = KeyChainManager.shared.loggedInUser
    
    // MARK: - Subviews
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .bold(size: 24)
        label.textColor = .ITBlack
        return label
    }()
    let userIdLabel: UILabel = {
        let label = UILabel()
        label.font = .medium(size: 20)
        label.textColor = .ITBlack
        return label
    }()
    let groupsLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 14)
        label.textColor = .ITBlack
        label.text = "Groups"
        return label
    }()

    let groupsCountLabel: UILabel = {
        let label = UILabel()
        label.font = .medium(size: 16)
        label.textColor = .ITBlack
        return label
    }()

    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.cornerRadius = 50
        return imageView
    }()

    let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()


    // MARK: - View Load

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayouts()
        layoutPageWithUser()
    }

    private func setUpLayouts() {
        view.addSubview(coverImageView)
        view.addSubview(iconImageView)
        view.addSubview(userIdLabel)
        view.addSubview(userNameLabel)
        view.addSubview(groupsLabel)
        view.addSubview(groupsCountLabel)

        coverImageView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(300)
        }
        iconImageView.snp.makeConstraints { make in
            make.height.width.equalTo(100)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(coverImageView.snp.bottom).offset(-50)
        }
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(24)
            make.centerX.equalTo(view.snp.centerX)
        }
        userIdLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(12)
            make.centerX.equalTo(view.snp.centerX)
        }
        groupsCountLabel.snp.makeConstraints { make in
            make.top.equalTo(userIdLabel.snp.bottom).offset(24)
            make.centerX.equalTo(view.snp.centerX)
        }
        groupsLabel.snp.makeConstraints { make in
            make.top.equalTo(groupsCountLabel.snp.bottom).offset(4)
            make.centerX.equalTo(view.snp.centerX)
        }
      
    }
    func layoutPageWithUser() {
        guard let user = user, let groups = user.groups else { return }
        iconImageView.loadImage(user.userIcon)
        coverImageView.loadImage(user.userCover)
        userNameLabel.text = "\(user.userName)"
        userIdLabel.text = "\(user.userId)"
        groupsCountLabel.text = "\(groups.count)"
    }
}
