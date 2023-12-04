//
//  HomeTableViewCell.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/22.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    static let identifier = "\(HomeTableViewCell.self)"
    
    // MARK: - Subview
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
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .ITLightGrey
        return view
    }()
    private var userBlockView = UserBlockView()
    var imageBlocksScrollView = ImageScrollView(frame: .zero)

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
        contentView.addSubview(imageBlocksScrollView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(seperatorView)
        
        userBlockView.snp.makeConstraints { (make) -> Void in
            make.top.right.left.equalTo(contentView)
            make.height.equalTo(62)
        }
        imageBlocksScrollView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(userBlockView.snp.bottom).offset(8)
            make.left.right.equalTo(contentView)
            make.height.equalTo(410)
        }
        seperatorView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(imageBlocksScrollView.snp.bottom).offset(16)
            make.left.equalTo(contentView).offset(16)
            make.right.equalTo(contentView).offset(-16)
            make.height.equalTo(0.5)
        }
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(seperatorView.snp.bottom).offset(16)
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
    func layoutCell(imageBlocks: [ImageBlock], textBlock: TextBlock, user: User) {
        setUpImageBlocks(imageBlocks: imageBlocks)
        setUpTextBlock(textBlock: textBlock)
        setUpUserBlock(userName: user.userName, userIcon: user.userIcon)
    }
    private func setUpImageBlocks(imageBlocks array: [ImageBlock]) {
        imageBlocksScrollView.setUpImageBlocks(imageBlocks: array)
    }
    private func setUpTextBlock(textBlock: TextBlock) {
        titleLabel.text = textBlock.title
        contentLabel.text = textBlock.content
    }
    private func setUpUserBlock(userName: String, userIcon: String) {
        userBlockView.userNameLabel.text = userName
        userBlockView.userIconImageView.loadImage(userIcon)
    }
  
    
}

