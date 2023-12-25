//
//  HomeTableViewCell.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/22.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    static let identifier = "\(HomeTableViewCell.self)"

    var textBlocksArray: [TextBlockView] = []

    // MARK: - Subview

    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .ITLightGrey
        return view
    }()

    private var userBlockView = UserBlockView()
    var imageBlocksScrollView = ImageScrollView(frame: .zero)
    var stackTextBlockView = StackTextBlockView(frame: .zero)

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
        contentView.addSubview(imageBlocksScrollView)
        contentView.addSubview(stackTextBlockView)
        contentView.addSubview(seperatorView)

        userBlockView.snp.makeConstraints { make in
            make.top.right.left.equalTo(contentView)
            make.height.equalTo(UserBlockView.height)
        }
        imageBlocksScrollView.snp.makeConstraints { make in
            make.top.equalTo(userBlockView.snp.bottom).offset(8)
            make.left.right.equalTo(contentView)
            make.height.equalTo(410)
        }
        seperatorView.snp.makeConstraints { make in
            make.top.equalTo(imageBlocksScrollView.snp.bottom).offset(16)
            make.left.equalTo(contentView).offset(16)
            make.right.equalTo(contentView).offset(-16)
            make.height.equalTo(0.5)
        }
        stackTextBlockView.snp.makeConstraints { make in
            make.top.equalTo(seperatorView.snp.bottom).offset(16)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
    }

    // MARK: - Methods

    func layoutCell(imageBlocks: [ImageBlock], textBlocks: [TextBlock], user: User) {
        imageBlocksScrollView.setUpImageBlocks(imageBlocks: imageBlocks)
        stackTextBlockView.setUpTextBlocks(textBlocks: textBlocks)
        setUpUserBlock(userName: user.userName, userIcon: user.userIcon!)
    }

    private func setUpUserBlock(userName: String, userIcon: String) {
        userBlockView.userNameLabel.text = userName
        userBlockView.userIconImageView.loadImage(userIcon)
    }
}
