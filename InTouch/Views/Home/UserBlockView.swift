//
//  UserBlockView.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/24.
//

import UIKit

class UserBlockView: UIView {
    // MARK: - Subviews
    let userIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .iconProfileSelected)
        imageView.layer.cornerRadius = 20
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .medium(size: 16)
        label.textColor = .ITBlack
        return label
    }()
    let moreOptionsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .iconMoreOptions), for: .normal)
        return button
    }()
    
    // MARK: - View Load
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayouts()
        setUpActions()
    }
    private func setUpLayouts() {
        addSubview(userIconImageView)
        addSubview(userNameLabel)
        addSubview(moreOptionsButton)
        
        userIconImageView.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(self).offset(16)
            make.height.width.equalTo(40)
        }
        userNameLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(userIconImageView.snp.centerY)
            make.left.equalTo(userIconImageView.snp.right).offset(16)
        }
        moreOptionsButton.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(userIconImageView.snp.centerY)
            make.right.equalTo(self).offset(-12)
            make.height.width.equalTo(30)
        }
    }
    private func setUpActions() {
    }
    // MARK: - Methods
    

}
