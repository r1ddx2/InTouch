//
//  DraftHeaderCell.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/20.
//

import UIKit

class DraftTableViewHeaderView: UITableViewCell {
    
    static let identifier = "DraftHeaderCell"
    
    var pickerData: [String] = [] {
        didSet {
            groupPickerView.reloadAllComponents()
        }
    }
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
        userIcon.layer.cornerRadius = 20
        return userIcon
    }()
    let groupPickerView: UIPickerView = {
        let groupPickerView = UIPickerView()
        
        return groupPickerView
    }()
    let groupTextField: UITextField = {
        let groupTextField = UITextField()
        
        return groupTextField
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayouts()
        setUpButtons()
        setUpPickerView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUpPickerView() {
        groupPickerView.delegate = self
        groupPickerView.dataSource = self
        
        groupTextField.inputView = groupPickerView
        groupTextField.placeholder = "Select a group"
    }
    private func setUpButtons() {
        buttonsView.setUpButtons(buttonsCount: 7, buttonTitles: ["Add text block", "Add image block", "Add text block", "Add text block", "Add text block", "Add text block", "Add text block"])
    }
    private func setUpLayouts() {
        contentView.addSubview(userIcon)
        contentView.addSubview(groupTextField)
        contentView.addSubview(addBlocksLabel)
        contentView.addSubview(buttonsView)
        
        userIcon.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(24)
            make.left.equalTo(contentView).offset(16)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        groupTextField.snp.makeConstraints { make in
            make.centerY.equalTo(userIcon.snp.centerY)
            make.left.equalTo(userIcon.snp.right).offset(16)
            make.height.equalTo(30)
        }
        addBlocksLabel.snp.makeConstraints { make in
            make.top.equalTo(userIcon.snp.bottom).offset(24)
            make.left.equalTo(contentView).offset(16)
        }
        buttonsView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(addBlocksLabel.snp.bottom).offset(8)
            make.left.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
    
    }
    //MARK: - Methods
    func layoutCell() {
        
    }
}

// MARK: - UIPickerView Data Source & Delegate
extension DraftTableViewHeaderView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        groupTextField.text = pickerData[row]
    }
}
