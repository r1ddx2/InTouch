//
//  IconAddCollectionViewCell.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/8.
//

import UIKit

class IconAddCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "\(IconAddCollectionViewCell.self)"

    // MARK: - Subview
   
    let addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ITYellow
        button.cornerRadius = 30
        button.setImage(UIImage(resource: .iconAdd).withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    //MARK: - View Load
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        setUpLayouts()
    }
    private func setUpLayouts() {
        contentView.addSubview(addButton)
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.centerX.equalTo(contentView.snp.centerX)
            make.height.width.equalTo(60)
            make.bottom.equalTo(contentView).offset(-20)
        }
    }
   
}
