//
//  HomeTableViewTextCell.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/27.
//
import UIKit

class HomeTableViewTextCell: UITableViewCell {
    static let identifier = "\(HomeTableViewTextCell.self)"

    var stackTextBlocks = StackTextBlockView(frame: .zero)

    private var userBlockView = UserBlockView()

    // MARK: - View Load

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayouts()
    }

    private func setUpLayouts() {
        contentView.addSubview(userBlockView)
        contentView.addSubview(stackTextBlocks)

        userBlockView.snp.makeConstraints { make in
            make.top.right.left.equalTo(contentView)
            make.height.equalTo(56)
        }
        stackTextBlocks.snp.makeConstraints { make in
            make.top.equalTo(userBlockView.snp.bottom)
            make.left.right.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-8)
        }
    }

    // MARK: - Methods

    func layoutCell(textBlock: [TextBlock], user: User) {
        stackTextBlocks.setUpTextBlocks(textBlocks: textBlock)
        setUpUserBlock(userName: user.userName, userIcon: user.userIcon!)
    }

    private func setUpUserBlock(userName: String, userIcon: String) {
        userBlockView.userNameLabel.text = userName
        userBlockView.userIconImageView.loadImage(userIcon)
    }
}
