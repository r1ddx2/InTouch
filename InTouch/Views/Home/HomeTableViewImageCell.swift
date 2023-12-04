//
//  HomeTableViewImageCell.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/27.
//


import UIKit


class HomeTableViewImageCell: UITableViewCell {
    static let identifier = "\(HomeTableViewImageCell.self)"
    
    // MARK: - Subview
    private var userBlockView = UserBlockView()
    var imageBlocksScrollView = ImageScrollView(frame: .zero)
   
    //MARK: - View Load
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayouts()
        setupScrollView()
    }
    private func setUpLayouts() {
        contentView.addSubview(userBlockView)
        contentView.addSubview(imageBlocksScrollView)

        userBlockView.snp.makeConstraints { (make) -> Void in
            make.top.right.left.equalTo(contentView)
            make.height.equalTo(62)
        }
        imageBlocksScrollView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(userBlockView.snp.bottom).offset(8)
            make.left.right.equalTo(contentView)
            make.height.equalTo(385)
            make.bottom.equalTo(contentView)
        }
    
    }
    
    private func setupScrollView() {
        imageBlocksScrollView.isScrollEnabled = true
        imageBlocksScrollView.showsHorizontalScrollIndicator = false
    }
    //MARK: - Methods
    func layoutCell(imageBlocks: [ImageBlock], user: User) {
        setUpImageBlocks(imageBlocks: imageBlocks)
        setUpUserBlock(userName: user.userName, userIcon: user.userIcon)
    }
    private func setUpImageBlocks(imageBlocks array: [ImageBlock]) {
        imageBlocksScrollView.setUpImageBlocks(imageBlocks: array)
    }
    private func setUpUserBlock(userName: String, userIcon: String) {
        userBlockView.userNameLabel.text = userName
        userBlockView.userIconImageView.loadImage(userIcon)
        
    }
  
    
}

