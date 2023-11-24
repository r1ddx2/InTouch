//
//  DraftHeaderCell.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/20.
//

import UIKit

class DraftTableHeaderView: UIView {
    
    static let identifier = "DraftHeaderCell"
    
    var selectedGroup: String?
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
    convenience init(pickerData: [String], buttonCount: Int, buttonTitles: [String]) {
        self.init()
        setUpLayouts()
        setUpPickerView()
        setUpToolBar()
        buttonsView.setUpButtons(buttonsCount: buttonCount, buttonTitles: buttonTitles)
        self.pickerData = pickerData
    }
    private func setUpPickerView() {
        groupPickerView.delegate = self
        groupPickerView.dataSource = self
        
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
    private func setUpToolBar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: false)

        groupTextField.inputAccessoryView = toolbar
    }
    
    //MARK: - Methods
    @objc func doneButtonTapped() {
        // Perform any actions needed when the "Done" button is tapped
        // For example, dismiss the picker view
        groupTextField.endEditing(true)
    }
    func layoutCell() {
        
    }
}

// MARK: - UIPickerView Data Source & Delegate
extension DraftTableHeaderView: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        selectedGroup = pickerData[row]
    }


}
