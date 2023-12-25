//
//  GroupSettingsViewController.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/11.
//

import MobileCoreServices
import UIKit
import UniformTypeIdentifiers

class GroupSettingsViewController: ITBaseViewController {
    var groupId: String?
    var group: Group? {
        didSet {
            layoutPage()
        }
    }

    var users: [User] = []
    var removedUsers: [User] = []
    var isIconPicker: Bool = true

    private let firestoreManager = FirestoreManager.shared
    private let cloudManager = CloudStorageManager.shared

    // MARK: - Subviews

    let groupCoverView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    let groupIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.cornerRadius = 50
        return imageView
    }()

    let groupNameLabel: UILabel = {
        let label = UILabel()
        label.font = .medium(size: 20)
        label.textColor = .ITBlack
        return label
    }()

    let membersCountLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 16)
        label.textColor = .ITDarkGrey
        return label
    }()

    let inviteCodeLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 13)
        label.textColor = .ITBlack
        label.text = "Join group with code"
        return label
    }()

    let inviteCodeTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .ITVeryLightGrey
        textField.cornerRadius = 8
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOffset = CGSize(width: 0, height: 1)
        textField.layer.shadowRadius = 4
        textField.layer.shadowOpacity = 0.2
        textField.font = .regular(size: 18)
        textField.addPadding(left: 12, right: 12)
        textField.isEnabled = false
        return textField
    }()

    let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .iconShare).withRenderingMode(.alwaysOriginal), for: .normal)
        button.backgroundColor = .ITBlack
        button.cornerRadius = 8
        return button
    }()

    let editNameButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .iconNameEdit).withRenderingMode(.alwaysOriginal), for: .normal)
        button.backgroundColor = .clear
        return button
    }()

    let editCoverImageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.4
        button.setImage(UIImage(resource: .iconCamera), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.cornerRadius = 14
        return button
    }()

    let editIconImageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.4
        button.setImage(UIImage(resource: .iconCamera), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.cornerRadius = 14
        return button
    }()

    let myMembersLabel: UILabel = {
        let label = UILabel()
        label.font = .medium(size: 16)
        label.textColor = .ITBlack
        label.text = "Members"
        return label
    }()

    let saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ITBlack
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .medium(size: 15)
        button.cornerRadius = 8
        return button
    }()

    let cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.backgroundColor = .ITVeryLightPink
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.ITBlack, for: .normal)
        cancelButton.titleLabel?.font = .medium(size: 15)
        cancelButton.cornerRadius = 8
        return cancelButton
    }()

    let tableView = UITableView()

    // MARK: - View Load

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        fetchGroupData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayouts()
        setUpActions()
        setUpTableView()
    }

    private func setUpLayouts() {
        view.addSubview(groupCoverView)
        view.addSubview(groupIconView)
        view.addSubview(groupNameLabel)
        view.addSubview(membersCountLabel)
        view.addSubview(myMembersLabel)
        view.addSubview(editNameButton)
        view.addSubview(editCoverImageButton)
        view.addSubview(editIconImageButton)
        view.addSubview(shareButton)
        view.addSubview(inviteCodeLabel)
        view.addSubview(inviteCodeTextField)
        view.addSubview(saveButton)
        view.addSubview(cancelButton)
        view.addSubview(tableView)

        groupCoverView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(120)
        }
        editCoverImageButton.snp.makeConstraints { make in
            make.height.width.equalTo(28)
            make.bottom.equalTo(groupCoverView.snp.bottom).offset(-16)
            make.right.equalTo(view).offset(-16)
        }
        groupIconView.snp.makeConstraints { make in
            make.height.width.equalTo(100)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(groupCoverView.snp.bottom).offset(-50)
        }
        editIconImageButton.snp.makeConstraints { make in
            make.width.height.equalTo(28)
            make.right.equalTo(groupIconView.snp.right)
            make.bottom.equalTo(groupIconView.snp.bottom)
        }
        groupNameLabel.snp.makeConstraints { make in
            make.top.equalTo(groupIconView.snp.bottom).offset(20)
            make.centerX.equalTo(view.snp.centerX)
        }
        editNameButton.snp.makeConstraints { make in
            make.centerY.equalTo(groupNameLabel.snp.centerY)
            make.left.equalTo(groupNameLabel.snp.right).offset(10)
            make.height.width.equalTo(20)
        }
        membersCountLabel.snp.makeConstraints { make in
            make.top.equalTo(groupNameLabel.snp.bottom).offset(10)
            make.centerX.equalTo(view.snp.centerX)
        }

        inviteCodeLabel.snp.makeConstraints { make in
            make.top.equalTo(membersCountLabel.snp.bottom).offset(24)
            make.left.equalTo(view).offset(16)
        }
        shareButton.snp.makeConstraints { make in
            make.right.equalTo(view).offset(-24)
            make.width.height.equalTo(40)
            make.centerY.equalTo(inviteCodeTextField.snp.centerY)
            make.left.equalTo(inviteCodeTextField.snp.right).offset(12)
        }
        inviteCodeTextField.snp.makeConstraints { make in
            make.top.equalTo(inviteCodeLabel.snp.bottom).offset(16)
            make.left.equalTo(view).offset(24)
            make.height.equalTo(40)
        }

        myMembersLabel.snp.makeConstraints { make in
            make.top.equalTo(inviteCodeTextField.snp.bottom).offset(24)
            make.left.equalTo(view).offset(24)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(myMembersLabel.snp.bottom).offset(8)
            make.right.left.equalTo(view)
            make.bottom.equalTo(saveButton.snp.top).offset(-16)
        }
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.left.equalTo(view).offset(24)
            make.width.equalTo((UIScreen.main.bounds.width - 56) / 2)
            make.height.equalTo(40)
        }
        cancelButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.left.equalTo(saveButton.snp.right).offset(8)
            make.right.equalTo(view).offset(-24)
            make.height.equalTo(40)
        }
    }

    private func setUpActions() {
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        editNameButton.addTarget(self, action: #selector(editNameButtonTapped), for: .touchUpInside)
        editIconImageButton.addTarget(self, action: #selector(editIconImageButtonTapped), for: .touchUpInside)
        editCoverImageButton.addTarget(self, action: #selector(editCoverImageButtonTapped), for: .touchUpInside)
    }

    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(GroupSettingsTableViewCell.self, forCellReuseIdentifier: GroupSettingsTableViewCell.identifier)
        tableView.rowHeight = 70
        tableView.separatorStyle = .none
    }

    // MARK: - API Methods

    private func fetchGroupData() {
        guard let groupId = groupId else { return }
        group = nil
        firestoreManager.listenDocument(
            asType: Group.self,
            documentId: groupId,
            reference: firestoreManager.getRef(.groups, groupId: nil)
        ) { result in
            switch result {
            case let .success(group):
                self.group = group
            case let .failure(error):
                print("Error: \(error)")
            }
        }
    }

    private func postGroupEdit() {
        guard var group = group else { return }

        let documentId = group.groupId
        let reference = firestoreManager.getRef(.groups, groupId: nil)

        firestoreManager.updateDocument(
            documentId: documentId,
            reference: reference,
            updateData: group
        ) { result in
            switch result {
            case let .success(documentId):
                print("Update group: \(documentId)")
            case let .failure(error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    private func postUserUpdate() {
        let documentIds = removedUsers.map(\.userEmail)
        let reference = firestoreManager.getRef(.users, groupId: nil)

        for (index, documentId) in documentIds.enumerated() {
            removedUsers[index].groups?.removeAll { $0.groupId == group?.groupId }
            let data = removedUsers[index]

            firestoreManager.updateDocument(
                documentId: documentId!,
                reference: reference,
                updateData: data
            ) { result in
                switch result {
                case let .success(documentId):
                    print("Update user: \(documentId)")
                case let .failure(error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }

    // MARK: - Methods

    private func layoutPage() {
        guard let group = group, let members = group.members else { return }
        groupCoverView.loadImage(group.groupCover)
        groupIconView.loadImage(group.groupIcon)
        groupNameLabel.text = "\(group.groupName)"
        membersCountLabel.text = "\(members.count) members"
        inviteCodeTextField.text = "\(group.groupId)"
    }

    private func updateGroupIcon(with image: UIImage) {
        groupIconView.image = image
    }

    private func updateGroupCover(with image: UIImage) {
        groupCoverView.image = image
    }

    private func shareText(_ text: String) {
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }

    // MARK: - Actions

    @objc private func saveButtonTapped() {
        postGroupEdit()
        postUserUpdate()
        dismiss(animated: true)
    }

    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }

    @objc private func shareButtonTapped() {
        guard let group = group else { return }
        let codeToShare = "Join my group at InTouch! \nJust enter the inivitation code: \(group.groupId)"
        shareText(codeToShare)
    }

    @objc private func editNameButtonTapped() {
        let editNameVC = EditGroupNameViewController()
        editNameVC.group = group
        configureSheetPresent(vc: editNameVC, height: 250)
    }

    @objc private func editIconImageButtonTapped() {
        isIconPicker = true
        showImagePicker()
    }

    @objc private func editCoverImageButtonTapped() {
        isIconPicker = false
        showImagePicker()
    }
}

// MARK: - UITableView Data Source & Delegate

extension GroupSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupSettingsTableViewCell.identifier, for: indexPath) as? GroupSettingsTableViewCell else { fatalError("Cannot create cell") }

        let user = users[indexPath.row]
        cell.user = user

        cell.removeMemberHandler = { isRemove in
            if let indexPath = tableView.indexPath(for: cell) {
                if isRemove {
                    self.removedUsers.append(cell.user!)
                    self.group?.members?.remove(at: indexPath.row)

                } else {
                    let member = User(userId: user.userId, userName: user.userName, userEmail: user.userEmail)
                    self.removedUsers = self.removedUsers.filter { $0.userId != member.userId }
                    self.group?.members?.append(member)
                }
            }
        }

        return cell
    }
}

// MARK: - UIImagePickerControllerDelegate

extension GroupSettingsViewController {
    func imagePickerController(_: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
    {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }

        // Update UI
        if isIconPicker {
            updateGroupIcon(with: selectedImage)
        } else {
            updateGroupCover(with: selectedImage)
        }

        // Prepare image to upload
        let mediaType = info[.mediaType] as! CFString
        if mediaType as String == UTType.image.identifier {
            if let imageURL = info[.imageURL] as? URL {
                guard let groupId = group?.groupId else { return }

                // Upload to Cloud Storage
                cloudManager.uploadURL(
                    fileUrl: imageURL,
                    filePathString: groupId
                ) { [weak self] result in
                    switch result {
                    case let .success(urlString):
                        if self?.isIconPicker == true {
                            self?.group?.groupIcon = urlString
                        } else {
                            self?.group?.groupCover = urlString
                        }
                        self?.dismiss(animated: true)

                    case let .failure(error):
                        print("Error: \(error.localizedDescription)")
                        self?.dismiss(animated: true)
                    }
                }
            }
        }
    }
}
