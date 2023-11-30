//
//  HomeTableViewTextCell.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/27.
//
import UIKit


class HomeTableViewTextCell: UITableViewCell {
    static let identifier = "\(HomeTableViewTextCell.self)"
    
    // MARK: - Subviews
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .medium(size: 18)
        label.textColor = .ITBlack
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 16)
        label.textColor = .ITBlack
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
 
    private var userBlockView = UserBlockView()
    //MARK: - View Load
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayouts()
    }
    private func setUpLayouts() {
        contentView.addSubview(userBlockView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        userBlockView.snp.makeConstraints { (make) -> Void in
            make.top.right.left.equalTo(contentView)
            make.height.equalTo(62)
        }
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(userBlockView.snp.bottom).offset(8)
            make.left.equalTo(contentView).offset(16)
            make.right.equalTo(contentView).offset(-16)
        }
        contentLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(contentView).offset(16)
            make.bottom.equalTo(contentView).offset(-21)
            make.right.equalTo(contentView).offset(-16)
        }
    }
    //MARK: - Methods
    func layoutCell(textBlock: TextBlock, user: User) {
        titleLabel.text = textBlock.title
        contentLabel.text = textBlock.content
        setUpUserBlock(userName: user.userName, userIcon: user.userIcon)
    }
 
    private func setUpUserBlock(userName: String, userIcon: String) {
        userBlockView.userNameLabel.text = userName
        userBlockView.userIconImageView.loadImage(userIcon)
    }
    
}

