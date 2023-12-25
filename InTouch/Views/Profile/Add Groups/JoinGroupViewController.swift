//
//  JoinGroupViewController.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/6.
//

import UIKit

class JoinGroupViewController: ITBaseViewController {
    private let firestoreManager = FirestoreManager.shared

    // MARK: - Subviews

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .bold(size: 24)
        label.textColor = .ITBlack
        label.text = "Join a Group"
        return label
    }()

    let groupCodeTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .ITVeryLightGrey
        textField.cornerRadius = 8
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOffset = CGSize(width: 0, height: 1)
        textField.layer.shadowRadius = 4
        textField.layer.shadowOpacity = 0.2
        textField.font = .regular(size: 18)
        textField.placeholder = " Enter group code"
        textField.addPadding(left: 12, right: 12)
        return textField
    }()

    let joinButton: UIButton = {
        let button = UIButton()
        button.setTitle("Join", for: .normal)
        button.backgroundColor = .ITBlack
        button.titleLabel?.textColor = .white
        button.cornerRadius = 8
        button.titleLabel?.font = .medium(size: 18)
        return button
    }()

    let cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.backgroundColor = .ITVeryLightPink
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.ITBlack, for: .normal)
        cancelButton.titleLabel?.font = .medium(size: 18)
        cancelButton.cornerRadius = 8
        return cancelButton
    }()

    // MARK: - View Load

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayouts()
        setUpActions()
    }

    private func setUpLayouts() {
        view.addSubview(groupCodeTextField)
        view.addSubview(joinButton)
        view.addSubview(cancelButton)
        view.addSubview(descriptionLabel)

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.centerX.equalTo(view.snp.centerX)
        }
        groupCodeTextField.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            make.left.equalTo(view).offset(24)
            make.width.equalTo(260)
            make.height.equalTo(45)
        }

        joinButton.snp.makeConstraints { make in
            make.left.equalTo(groupCodeTextField.snp.right).offset(12)
            make.centerY.equalTo(groupCodeTextField.snp.centerY)
            make.right.equalTo(view).offset(-24)
            make.height.equalTo(45)
        }
        cancelButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-32)
            make.left.equalTo(view).offset(24)
            make.right.equalTo(view).offset(-24)
            make.height.equalTo(45)
        }
    }

    private func setUpActions() {
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        joinButton.addTarget(self, action: #selector(joinButtonTapped), for: .touchUpInside)
    }

    // MARK: - Methods

    @objc private func cancelTapped() {
        dismiss(animated: true)
    }

    @objc private func joinButtonTapped() {
        guard let groupId = groupCodeTextField.text,
              groupId != ""
        else {
            return
        }
        fetchGroupInfo(groupId)
    }

    private func fetchGroupInfo(_ documentId: String) {
        let reference = firestoreManager.getRef(.groups, groupId: nil)

        firestoreManager.getDocument(
            asType: Group.self,
            documentId: documentId,
            reference: reference
        ) { result in
            switch result {
            case let .success(group):
                self.showConfirmJoinPage(for: group)

            case let .failure(error):
                print("Error \(error.localizedDescription)")
            }
        }
    }

    private func showConfirmJoinPage(for group: Group) {
        let confirmJoinVC = ConfirmJoinGroupViewController()
        confirmJoinVC.group = group
        configureSheetPresent(vc: confirmJoinVC, height: 680)
    }
}
