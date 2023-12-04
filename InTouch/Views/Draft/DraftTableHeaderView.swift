//
//  DraftHeaderCell.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/20.
//

import UIKit

class DraftTableHeaderView: UIView {
    
    static let identifier = "DraftHeaderCell"

    // MARK: - Subview
    let buttonsView = ButtonsScrollView()
    let addBlocksLabel: UILabel = {
        let addBlocksLabel = UILabel()
        addBlocksLabel.text = "Add new blocks"
        addBlocksLabel.font = .regular(size: 12)
        addBlocksLabel.textColor = .ITBlack
        return addBlocksLabel
    }()
    let userIcon: UIImageView = {
        let userIcon = UIImageView()
        userIcon.image = UIImage(resource: .iconProfile)
        userIcon.clipsToBounds = true
        userIcon.contentMode = .scaleAspectFill
        userIcon.layer.cornerRadius = 25
        return userIcon
    }()
    let groupPickerView: UIPickerView = {
        let groupPickerView = UIPickerView()
        
        return groupPickerView
    }()
    let groupTextField: UITextField = {
        let groupTextField = UITextField()
        groupTextField.borderStyle = .roundedRect
        groupTextField.borderColor = .ITBlack
        groupTextField.backgroundColor = .ITLightGrey
        return groupTextField
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    convenience init(user: User, buttonCount: Int, buttonTitles: [String], buttonStyle: ButtonStyle) {
        self.init()
        setUpLayouts()
        setUpPickerView()
        
        buttonsView.setUpButtons(buttonsCount: buttonCount, buttonTitles: buttonTitles, buttonStyle: buttonStyle)
        userIcon.loadImage(user.userIcon)
    }
    private func setUpPickerView() {
        groupTextField.inputView = groupPickerView
        groupTextField.placeholder = "Select a group"
    }
    private func setUpLayouts() {
        self.addSubview(userIcon)
        self.addSubview(groupTextField)
        self.addSubview(addBlocksLabel)
        self.addSubview(buttonsView)
        
        userIcon.snp.makeConstraints { make in
            make.top.equalTo(self).offset(32)
            make.left.equalTo(self).offset(24)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        groupTextField.snp.makeConstraints { make in
            make.centerY.equalTo(userIcon.snp.centerY)
            make.left.equalTo(userIcon.snp.right).offset(24)
            make.right.equalTo(self).offset(-24)
            make.height.equalTo(40)
        }
        addBlocksLabel.snp.makeConstraints { make in
            make.top.equalTo(userIcon.snp.bottom).offset(16)
            make.left.equalTo(self).offset(16)
        }
        buttonsView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(addBlocksLabel.snp.bottom).offset(8)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
        }
    }
    
    //MARK: - Methods
    @objc func doneButtonTapped() {
        groupTextField.endEditing(true)
    }
}
