//
//  ImageBlockDraft.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/17.
//

import UIKit

class ImageBlockDraftCell: UITableViewCell {
    
    static let identifier = "ImageBlockDraftCell"
    var addImageHandler: (() -> Void)?
    // MARK: - Subview
    // Location
    let locationView: UIView = {
        let locationView = UIView()
        locationView.backgroundColor = .white
        return locationView
    }()
    let locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.textColor = .ITDarkGrey
        locationLabel.font = .regular(size: 14)
        locationLabel.text = "Add a location"
        return locationLabel
    }()
    let indicatorImageView: UIImageView = {
        let indicatorImageView = UIImageView()
        indicatorImageView.image = UIImage(resource: .iconRight)
        return indicatorImageView
    }()
    let addLocationButton: UIButton = {
        let addLocationButton = UIButton()
        return addLocationButton
    }()
    private let seperatorView: UIView = {
        let seperatorView = UIView()
        seperatorView.backgroundColor = .ITLightGrey
        return seperatorView
    }()
    // Image and Text
    let userImageView: UIImageView = {
        let userImageView = UIImageView()
        userImageView.borderColor = .ITLightGrey
        userImageView.borderWidth = 0.5
        return userImageView
    }()
    let addImageButton: UIButton = {
        let addImageButton = UIButton()
        addImageButton.setImage(UIImage(resource: .iconAdd), for: .normal)
        return addImageButton
    }()
    let captionTextView: UITextView = {
        let captionTextView = UITextView()
        captionTextView.textColor = .ITBlack
        captionTextView.font = .regular(size: 16)
        captionTextView.text = "Write about this photo..."
        return captionTextView
    }()
   
    //MARK: - View Load
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayouts()
        addImageButton.addTarget(self, action: #selector(addImageTapped), for: .touchUpInside)
        
    }
    private func setUpLayouts() {
        locationView.addSubview(locationLabel)
        locationView.addSubview(addLocationButton)
        locationView.addSubview(seperatorView)
        locationView.addSubview(indicatorImageView)
        contentView.addSubview(locationView)
        contentView.addSubview(userImageView)
        contentView.addSubview(captionTextView)
        contentView.addSubview(addImageButton)
        locationView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.height.equalTo(40)
        }
        locationLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(locationView.snp.centerY)
            make.left.equalTo(locationView).offset(16)
        }
        indicatorImageView.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(locationView.snp.centerY)
            make.right.equalTo(locationView).offset(-16)
        }
        addLocationButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(locationView)
            make.bottom.equalTo(locationView)
            make.right.equalTo(locationView)
            make.width.equalTo(100)
        }
        seperatorView.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(locationView)
            make.left.equalTo(locationView)
            make.right.equalTo(locationView)
            make.height.equalTo(0.5)
        }
        userImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(locationView.snp.bottom).offset(12)
            make.left.equalTo(contentView).offset(16)
            make.bottom.equalTo(contentView).offset(-12)
            make.height.equalTo(106)
            make.width.equalTo(userImageView.snp.height)
        }
        captionTextView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(locationView.snp.bottom).offset(8)
            make.left.equalTo(userImageView.snp.right).offset(8)
            make.right.equalTo(contentView).offset(-16)
            make.bottom.equalTo(contentView).offset(-8)
        }
        addImageButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(35)
            make.width.equalTo(35)
            make.center.equalTo(userImageView)
        }
    }
    //MARK: - Methods
    @objc private func addImageTapped() {
        addImageHandler?()
    }
    func layoutCell() {
        
    }
}
