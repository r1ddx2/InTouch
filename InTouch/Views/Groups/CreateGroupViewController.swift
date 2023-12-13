//
//  CreateGroupViewController.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/6.
//
import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class CreateGroupViewController: ITBaseViewController {
    
    private let cloudManager = CloudStorageManager.shared
    private let firestoreManager = FirestoreManager.shared
    
    var user: User? {
        return KeyChainManager.shared.loggedInUser
    }
    
    var groupToCreate: Group?
    // MARK: - Subviews
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .bold(size: 24)
        label.textColor = .ITBlack
        label.text = "Create a Group"
        return label
    }()
    let editView: UIView = {
        let view = UIView()
        view.borderColor = .ITLightGrey
        view.borderWidth = 1
        view.cornerRadius = 8
        return view
    }()
    let groupNameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.cornerRadius = 8
        textField.font = .regular(size: 18)
        textField.placeholder = " Enter group title"
        return textField
    }()
    let editImageButton: UIButton = {
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
    let groupIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .default)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.cornerRadius = 40
        return imageView
    }()
    let createButton: UIButton = {
        let createButton = UIButton()
        createButton.backgroundColor = .ITYellow
        createButton.setTitle("Create group", for: .normal)
        createButton.setTitleColor(.ITBlack, for: .normal)
        createButton.titleLabel?.font = .medium(size: 18)
        createButton.cornerRadius = 8
        return createButton
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
        view.addSubview(descriptionLabel)
        view.addSubview(editView)
        editView.addSubview(groupNameTextField)
        editView.addSubview(groupIconView)
        editView.addSubview(editImageButton)
        view.addSubview(createButton)
        view.addSubview(cancelButton)
      
      
        descriptionLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.centerX.equalTo(view.snp.centerX)
        }
        editView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            make.height.equalTo(120)
            make.left.equalTo(view).offset(16)
            make.right.equalTo(view).offset(-16)
        }
        groupIconView.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(editView.snp.centerY)
            make.left.equalTo(editView).offset(16)
            make.width.height.equalTo(80)
        }
        editImageButton.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(28)
            make.right.equalTo(groupIconView.snp.right)
            make.bottom.equalTo(groupIconView.snp.bottom)
        }
        groupNameTextField.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(editView.snp.centerY)
            make.left.equalTo(groupIconView.snp.right).offset(16)
            make.right.equalTo(editView).offset(-16)
            make.height.equalTo(50)
        }
    
        createButton.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(cancelButton.snp.top).offset(-12)
            make.left.equalTo(view).offset(24)
            make.right.equalTo(view).offset(-24)
            make.height.equalTo(45)
        }
        cancelButton.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-32)
            make.left.equalTo(view).offset(24)
            make.right.equalTo(view).offset(-24)
            make.height.equalTo(45)
        }
        
    }
    private func setUpActions() {
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        editImageButton.addTarget(self, action: #selector(editImageTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    
    // MARK: - Methods
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    @objc private func createButtonTapped() {
        guard let groupName = groupNameTextField.text,
            groupName != "" else {
            return
        }
        
        // Input group name
        if groupToCreate == nil {
            initializeGroup(with: groupName)
        } else {
            groupToCreate?.groupName = groupName
        }
        
        if let group = groupToCreate {
            createGroup(group)
        }
    }
    
    @objc private func editImageTapped() {
        showImagePicker()
    }
    private func createGroup(_ group: Group) {
        guard let group = groupToCreate else { return }
        addGroupDoc(group)
        addGroupToUser(group)
        dismissToRoot()
    }
    private func addGroupDoc(_ group: Group) {

        let reference = firestoreManager.getRef(.groups, groupId: nil)
        let documentId = group.groupId
        
        firestoreManager.addDocument(
            data: group,
            reference: reference,
            documentId: documentId){ result in
                switch result {
                case .success(let documentId):
                    print("Added Group: \(documentId)")
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
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
    private func initializeGroup(with groupName: String = "") {
        guard let user = user else { return }
        let groupMember = User(userId: user.userId, userName: user.userName)
        groupToCreate = Group(
            groupName: groupName,
            groupId: generateRandomCode(),
            members: [groupMember]
        )
    }
    private func updateGroupIcon(with image: UIImage) {
        groupIconView.image = image
    }
}

// MARK: - UIImagePickerControllerDelegate


extension CreateGroupViewController {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
            // Update UI
            updateGroupIcon(with: selectedImage)
        
            // Prepare image to upload
            let mediaType = info[.mediaType] as! CFString
            if mediaType as String == UTType.image.identifier {
                if let imageURL = info[.imageURL] as? URL {
                    
                    // Create group if nil
                    if groupToCreate == nil {
                       initializeGroup()
                    }
                    guard let groupId = groupToCreate?.groupId else { return }

                    // Upload to Cloud Storage
                    cloudManager.uploadGroupImages(
                        fileUrl: imageURL,
                        groupId: groupId) { [weak self] result in
                            
                            switch result {
                            case .success(let urlString):
                                self?.groupToCreate?.groupIcon = urlString
                                self?.dismiss(animated: true)
                                
                            case .failure(let error):
                                print("Error: \(error.localizedDescription)")
                                self?.dismiss(animated: true)
                            }
                            
                        }
                    
            }
            
           
        }
        
    }

}
