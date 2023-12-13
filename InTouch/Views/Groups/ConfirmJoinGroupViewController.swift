//
//  ConfirmJoinGroupViewController.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/7.
//

import UIKit

class ConfirmJoinGroupViewController: ITBaseViewController {
    
    var user: User? = KeyChainManager.shared.loggedInUser
    var group: Group? {
        didSet {
            layoutPage()
        }
    }
    private let firestoreManager = FirestoreManager.shared
    
    // MARK: - Subviews
    let groupNameLabel: UILabel = {
        let label = UILabel()
        label.font = .bold(size: 24)
        label.textColor = .ITBlack
        label.text = "Join a Group"
        return label
    }()
    let memberLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 14)
        label.textColor = .ITBlack
        label.text = "Members"
        return label
    }()
    let memberCountLabel: UILabel = {
        let label = UILabel()
        label.font = .medium(size: 16)
        label.textColor = .ITBlack
        return label
    }()
    let groupIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.cornerRadius = 50
        return imageView
    }()
    let groupCoverView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("Join", for: .normal)
        button.backgroundColor = .ITYellow
        button.setTitleColor(.ITBlack, for: .normal)
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
        view.addSubview(groupCoverView)
        view.addSubview(groupIconView)
        view.addSubview(confirmButton)
        view.addSubview(cancelButton)
        view.addSubview(groupNameLabel)
        view.addSubview(memberLabel)
        view.addSubview(memberCountLabel)
        
        groupCoverView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(300)
        }
        groupIconView.snp.makeConstraints { make in
            make.height.width.equalTo(100)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(groupCoverView.snp.bottom).offset(-50)
        }
        groupNameLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(groupIconView.snp.bottom).offset(24)
            make.centerX.equalTo(view.snp.centerX)
        }
        memberCountLabel.snp.makeConstraints { make in
            make.top.equalTo(groupNameLabel.snp.bottom).offset(12)
            make.centerX.equalTo(view.snp.centerX)
        }
  
        memberLabel.snp.makeConstraints { make in
            make.top.equalTo(memberCountLabel.snp.bottom).offset(4)
            make.centerX.equalTo(view.snp.centerX)
        }
        confirmButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(memberLabel.snp.bottom).offset(60)
            make.left.equalTo(view).offset(24)
            make.right.equalTo(view).offset(-24)
            make.height.equalTo(45)
        }
        cancelButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(confirmButton.snp.bottom).offset(12)
            make.left.equalTo(view).offset(24)
            make.right.equalTo(view).offset(-24)
            make.height.equalTo(45)
        }
    }
    private func setUpActions() {
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
    }
    private func layoutPage() {
        guard let group = group, let groupMembers = group.members else { return }
        groupIconView.loadImage(group.groupIcon)
        groupCoverView.loadImage(group.groupCover)
        groupNameLabel.text = "\(group.groupName)"
        memberCountLabel.text = "\(groupMembers.count)"
    }
    
    // MARK: - Methods
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    @objc private func confirmButtonTapped() {
        guard let user = user, 
                let userGroups = user.groups,
                let group = group else { return }
        
        let groupList = userGroups.map { $0.groupId }
        
        // Check if already joined
        if groupList.contains(group.groupId) {
            dismiss(animated: true)
        } else {
            joinGroup()
        }
        
    }
    
    private func joinGroup() {
        guard let user = user, let group = group else { return }
        addGroupToUser(group)
        addMemberToGroup(user)
        dismiss(animated: true) {
            self.presentingViewController?.dismiss(animated: true)
        }
    }
    
    private func addGroupToUser(_ group: Group) {
        let usersGroup = Group(groupName: group.groupName, groupId: group.groupId, groupIcon: nil, groupCover: nil)
        
        if var user = user {
            
            user.groups?.append(usersGroup)
            let reference = firestoreManager.getRef(.users, groupId: nil)
            let documentId = user.userId
            
            firestoreManager.updateDocument(
                documentId: documentId,
                reference: reference,
                updateData: user) { result in
                    switch result {
                    case .success(let documentId):
                        print("Added to user: \(documentId)")
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                    }
                }
            
        }
    }
    
    private func addMemberToGroup(_ user: User) {
        guard var group = group else { return }
        let member = User(userId: user.userId, userName: user.userName)
        
        if var groupMembers = group.members {
            groupMembers.append(member)
            group.members = groupMembers
            self.group = group
            
            
            let reference = firestoreManager.getRef(.groups, groupId: nil)
            let documentId = group.groupId
            
            firestoreManager.updateDocument(
                documentId: documentId,
                reference: reference,
                updateData: group) { result in
                    switch result {
                    case .success(let documentId):
                        print("Added to group: \(documentId)")
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                    }
                }
            
        }
        
        
        
    }
}
