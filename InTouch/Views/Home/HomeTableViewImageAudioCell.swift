//
//  HomeTableViewImageAudioCell.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/21.

import UIKit

class HomeTableViewImageAudioCell: UITableViewCell {
    static let identifier = "\(HomeTableViewImageAudioCell.self)"
    
    // MARK: - Subview
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .ITLightGrey
        return view
    }()
    private var userBlockView = UserBlockView()
    var imageBlocksScrollView = ImageScrollView(frame: .zero)
    var audioBlocksScrollView = AudioScrollView(frame: .zero)
    
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
        contentView.addSubview(audioBlocksScrollView)
        contentView.addSubview(seperatorView)
        
        userBlockView.snp.makeConstraints { (make) -> Void in
            make.top.right.left.equalTo(contentView)
            make.height.equalTo(UserBlockView.height)
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
        audioBlocksScrollView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(seperatorView.snp.bottom)
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(82)
        }

    }
 
    //MARK: - Methods
    func layoutCell(imageBlocks: [ImageBlock], audioBlocks: [AudioBlock], user: User) {
        imageBlocksScrollView.setUpImageBlocks(imageBlocks: imageBlocks)
        audioBlocksScrollView.setUpAudioBlocks(audioBlocks: audioBlocks)
        setUpUserBlock(userName: user.userName, userIcon: user.userIcon!)
    }
    private func setUpUserBlock(userName: String, userIcon: String) {
        userBlockView.userNameLabel.text = userName
        userBlockView.userIconImageView.loadImage(userIcon)
    }
  
    
}

