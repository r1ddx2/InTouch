//
//  HomeTableHeaderView.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/22.
//

import UIKit

class HomeTableHeaderView: UIView {
    // MARK: - Subviews
    let coverImageView: UIImageView = {
        let coverImageView = UIImageView()
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.clipsToBounds = true
        return coverImageView
    }()
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .bold(size: 22)
        titleLabel.textColor = .ITBlack
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = .regular(size: 14)
        dateLabel.textColor = .ITBlack
        return dateLabel
    }()
        
        // MARK: - View Load
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    convenience init(image: UIImage, title: String, date: String) {
        self.init(frame: .zero)
        coverImageView.image = image
        titleLabel.text = title
        dateLabel.text = date
        setUpLayouts()
        setUpActions()
    }
    private func setUpLayouts() {
        self.addSubview(coverImageView)
        self.addSubview(titleLabel)
        self.addSubview(dateLabel)
        
        coverImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(5)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(80)
        }
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(coverImageView.snp.bottom).offset(12)
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).offset(-16)
        }
        dateLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).offset(-16)
        }

    }
    private func setUpActions() {
        
    }
    
    
    // MARK: - Methods
    

}
