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
    private var imageBlocksScrollView = UIScrollView()

    private var imageBlocksArray: [ImageBlockView] = []
    
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
            make.height.equalTo(385)
        }
        seperatorView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(imageBlocksScrollView.snp.bottom)
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
    
    private func setupScrollView() {
        imageBlocksScrollView.isScrollEnabled = true
        imageBlocksScrollView.showsHorizontalScrollIndicator = false
    }
    //MARK: - Methods
    func layoutCell(imageBlocks: [ImageBlock], textBlock: TextBlock, user: User) {
        setUpImageBlocks(imageBlocks: imageBlocks)
        setUpTextBlock(textBlock: textBlock)
        setUpUserBlock(userName: user.userName, userIcon: user.userIcon, placeLabel: imageBlocks[0].place ?? "" )
    }
    private func setUpImageBlocks(imageBlocks array: [ImageBlock]) {
        let count = array.count
        let viewWidth = 325
        var previousView: ImageBlockView?
        
        for i in 0..<count {
            let view = ImageBlockView(image: array[i].image, caption: array[i].caption)
            imageBlocksScrollView.addSubview(view)
            imageBlocksArray.append(view)
            
            view.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(imageBlocksScrollView)
                make.height.width.equalTo(viewWidth)
            }
            if let previousView = previousView {
                view.snp.makeConstraints { (make) -> Void in
                    make.left.equalTo(previousView.snp.right).offset(16)
                }
            } else {
                view.snp.makeConstraints { (make) -> Void in
                    make.left.equalTo(imageBlocksScrollView.snp.left).offset(16)
                }
            }
            previousView = view
            
        }
        
        let totalWidth = CGFloat(count) * CGFloat(viewWidth) + CGFloat(count - 1) * 16 + CGFloat(32)
        imageBlocksScrollView.contentSize = CGSize(width: totalWidth, height: 50.0)
        
    }
    private func setUpTextBlock(textBlock: TextBlock) {
        titleLabel.text = textBlock.title
        contentLabel.text = textBlock.content
    }
    private func setUpUserBlock(userName: String, userIcon: String, placeLabel: String) {
        userBlockView.userNameLabel.text = userName
        userBlockView.userIconImageView.loadImage(userIcon)
      
    }
  
    
}

