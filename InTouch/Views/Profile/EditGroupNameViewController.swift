//
//  EditGroupNameViewController.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/11.
//
import UIKit


class EditGroupNameViewController: ITBaseViewController {
    var group: Group? {
        didSet {
            configurePage()
        }
    }
    private let firestoreManager = FirestoreManager.shared
    // MARK: - Subviews
    let saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ITBlack
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .medium(size: 15)
        button.cornerRadius = 8
        return button
    }()
    let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .ITDarkGrey
        return view
    }()
    let editTextField: UITextField = {
        let textField = UITextField()
        textField.font = .regular(size: 22)
        textField.textColor = .ITBlack
        textField.placeholder = "Enter group name"
        
        return textField
    }()
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .medium(size: 22)
        label.textColor = .ITBlack
        label.text = "Group name"
        return label
    }()
    // MARK: - View Load
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayouts()
        setUpActions()
    }
    private func setUpLayouts() {
        view.addSubview(descriptionLabel)
        view.addSubview(underlineView)
        view.addSubview(editTextField)
        view.addSubview(saveButton)
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.left.equalTo(view).offset(24)
        }
        editTextField.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            make.left.equalTo(view).offset(24)
            make.right.equalTo(view).offset(-24)
            make.height.equalTo(40)
        }
        underlineView.snp.makeConstraints { make in
            make.top.equalTo(editTextField.snp.bottom).offset(2)
            make.left.equalTo(view).offset(24)
            make.right.equalTo(view).offset(-24)
            make.height.equalTo(1)
        }
       
        saveButton.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.left.equalTo(view).offset(24)
            make.right.equalTo(view).offset(-24)
            make.height.equalTo(40)
        }
        
    }
    private func setUpActions() {
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    // MARK: - Methods
    @objc func saveButtonTapped() {
        postGroupName()
        dismiss(animated: true)
    }
    func configurePage() {
        guard let group = group else { return }
        editTextField.text = group.groupName
    }
    private func postGroupName() {
        guard var group = group,
                let text = editTextField.text,
        text != "" else { return }
        group.groupName = text
        
        let documentId = group.groupId
        let reference = firestoreManager.getRef(.groups, groupId: nil)
        
        firestoreManager.updateDocument(
            documentId: documentId,
            reference: reference,
            updateData: group) { result in
                switch result {
                case .success(let documentId):
                    print("Update group: \(documentId)")
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        
        
        
    }
}
