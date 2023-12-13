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
    let userIconView: UIImageView = {
        let userIcon = UIImageView()
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
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.borderColor = .ITBlack
        textField.backgroundColor = .ITVeryLightGrey
        textField.cornerRadius = 8
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOffset = CGSize(width: 0, height: 1)
        textField.layer.shadowRadius = 4
        textField.layer.shadowOpacity = 0.2
        textField.font = .regular(size: 18)
        textField.placeholder = "Select a group"
        textField.addPadding(left: 12, right: 12)
        return textField
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
        userIconView.loadImage(user.userIcon)
    }
    private func setUpPickerView() {
        groupTextField.inputView = groupPickerView
        groupTextField.placeholder = "Select a group"
    }
    private func setUpLayouts() {
        self.addSubview(userIconView)
        self.addSubview(groupTextField)
        self.addSubview(addBlocksLabel)
        self.addSubview(buttonsView)
        
        userIconView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(24)
            make.left.equalTo(self).offset(24)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        groupTextField.snp.makeConstraints { make in
            make.centerY.equalTo(userIconView.snp.centerY)
            make.left.equalTo(userIconView.snp.right).offset(24)
           // make.right.equalTo(self.snp.right).offset(-24)
         make.height.equalTo(40)
          make.width.equalTo(265)
        }
        addBlocksLabel.snp.makeConstraints { make in
            make.top.equalTo(userIconView.snp.bottom).offset(16)
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
    func changeIcon(userIcon: String?) {
        if let userIcon = userIcon {
            userIconView.loadImage(userIcon)
        }
    }
}
