//
//  UserBlockView.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/24.
//

import UIKit

class UserBlockView: UIView {
    // MARK: - Subviews
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .iconProfileSelected)
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        return imageView
    }()
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Panda"
        label.font = .medium(size: 18)
        label.textColor = .ITBlack
        return label
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
        
    }
    private func setUpActions() {
        
    }
    
    
    // MARK: - Methods
    

}
