//
//  AddGroupViewController.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/6.
//

import UIKit

class AddGroupViewController: ITBaseViewController {
    // MARK: - Subviews
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .bold(size: 24)
        label.textColor = .ITBlack
        label.text = "Start by adding a group!"
        return label
    }()
    let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .iconClose), for: .normal)
        return button
    }()
    let joinGroupButton: UIButton = {
        let joinButton = UIButton()
        joinButton.backgroundColor = .ITYellow
        joinButton.setTitle("Join a Group", for: .normal)
        joinButton.setTitleColor(.ITBlack, for: .normal)
        joinButton.titleLabel?.font = .medium(size: 16)
        joinButton.cornerRadius = 8
        return joinButton
    }()
    let createGroupButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ITBlack
        button.setTitle("Create a group", for: .normal)
        button.titleLabel?.font = .medium(size: 16)
        button.setTitleColor(.white, for: .normal)
        button.cornerRadius = 8
        return button
    }()
    
    // MARK: - View Load
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayouts()
        setUpActions()
    }
    private func setUpLayouts() {
        view.addSubview(descriptionLabel)
        view.addSubview(dismissButton)
        view.addSubview(joinGroupButton)
        view.addSubview(createGroupButton)
        
        descriptionLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view).offset(24)
            make.left.equalTo(view).offset(24)
        }
        dismissButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.right.equalTo(view).offset(-16)
        }
        joinGroupButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(32)
            make.left.equalTo(view).offset(24)
            make.right.equalTo(view).offset(-24)
            make.height.equalTo(42)
        }
        createGroupButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(joinGroupButton.snp.bottom).offset(12)
            make.left.equalTo(view).offset(24)
            make.right.equalTo(view).offset(-24)
            make.height.equalTo(42)
        }
    
    }
    private func setUpActions() {
        joinGroupButton.addTarget(self, action: #selector(joinGroupButtonTapped), for: .touchUpInside)
        createGroupButton.addTarget(self, action: #selector(createGroupButtonTapped), for: .touchUpInside)
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
    }
    
    
    // MARK: - Methods
    @objc private func joinGroupButtonTapped() {
        let joinGroupVC = JoinGroupViewController()
        joinGroupVC.isModalInPresentation = true
        joinGroupVC.modalPresentationStyle = .fullScreen
        present(joinGroupVC, animated: true)
    }
    @objc private func createGroupButtonTapped() {
        let createGroupVC = CreateGroupViewController()
        createGroupVC.isModalInPresentation = true
        createGroupVC.modalPresentationStyle = .fullScreen
        present(createGroupVC, animated: true)
    }
    @objc private func dismissButtonTapped() {
        dismiss(animated: true)
    }
}
