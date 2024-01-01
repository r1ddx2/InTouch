//
//  ProfileSettingsViewController.swift
//  InTouch
//
//  Created by Red Wang on 2024/1/1.
//

import MobileCoreServices
import UIKit
import UniformTypeIdentifiers

class ProfileSettingsViewController: ITBaseViewController {
    var user: User? {
        didSet {
            layoutPage()
        }
    }

    var isIconPicker: Bool = true

    private let firestoreManager = FirestoreManager.shared
    private let cloudManager = CloudStorageManager.shared

    // MARK: - Subviews

    let userCoverView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    let userIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.cornerRadius = 50
        return imageView
    }()

    let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .medium(size: 20)
        label.textColor = .ITBlack
        return label
    }()

    let userIdLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 16)
        label.textColor = .ITDarkGrey
        return label
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

    // MARK: - View Load

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayouts()
        setUpActions()
    }

    private func setUpLayouts() {
        view.addSubview(userCoverView)
        view.addSubview(userIconView)
        view.addSubview(userNameLabel)
        view.addSubview(userIdLabel)
        view.addSubview(editNameButton)
        view.addSubview(editCoverImageButton)
        view.addSubview(editIconImageButton)
        view.addSubview(saveButton)
        view.addSubview(cancelButton)

        userCoverView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(200)
        }
        editCoverImageButton.snp.makeConstraints { make in
            make.height.width.equalTo(28)
            make.bottom.equalTo(userCoverView.snp.bottom).offset(-16)
            make.right.equalTo(view).offset(-16)
        }
        userIconView.snp.makeConstraints { make in
            make.height.width.equalTo(100)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(userCoverView.snp.bottom).offset(-50)
        }
        editIconImageButton.snp.makeConstraints { make in
            make.width.height.equalTo(28)
            make.right.equalTo(userIconView.snp.right)
            make.bottom.equalTo(userIconView.snp.bottom)
        }
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(userIconView.snp.bottom).offset(20)
            make.centerX.equalTo(view.snp.centerX)
        }
        editNameButton.snp.makeConstraints { make in
            make.centerY.equalTo(userNameLabel.snp.centerY)
            make.left.equalTo(userNameLabel.snp.right).offset(10)
            make.height.width.equalTo(20)
        }
        userIdLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(10)
            make.centerX.equalTo(view.snp.centerX)
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
        editNameButton.addTarget(self, action: #selector(editNameButtonTapped), for: .touchUpInside)
        editIconImageButton.addTarget(self, action: #selector(editIconImageButtonTapped), for: .touchUpInside)
        editCoverImageButton.addTarget(self, action: #selector(editCoverImageButtonTapped), for: .touchUpInside)
    }

    // MARK: - Methods

    private func layoutPage() {
        guard let user = user else { return }
        userCoverView.loadImage(user.userCover)
        userIconView.loadImage(user.userIcon)
        userNameLabel.text = "\(user.userName)"
        userIdLabel.text = "@\(user.userId)"
    }

    private func updateUserIcon(with image: UIImage) {
        userIconView.image = image
    }

    private func updateUserCover(with image: UIImage) {
        userCoverView.image = image
    }

    private func postUserEdit() {
        guard var user = user else { return }
        let reference = firestoreManager.getRef(.users, groupId: nil)

        if let documentId = user.userEmail {
            firestoreManager.updateDocument(
                documentId: documentId,
                reference: reference,
                updateData: user
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

    // MARK: - Actions

    @objc private func saveButtonTapped() {
        postUserEdit()
        dismiss(animated: true)
    }

    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }

    @objc private func editNameButtonTapped() {
        let editNameVC = EditGroupNameViewController()
        editNameVC.user = user
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

// MARK: - UIImagePickerControllerDelegate

extension ProfileSettingsViewController {
    func imagePickerController(_: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
    {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }

        // Update UI
        if isIconPicker {
            updateUserIcon(with: selectedImage)
        } else {
            updateUserCover(with: selectedImage)
        }

        // Prepare image to upload
        let mediaType = info[.mediaType] as! CFString
        if mediaType as String == UTType.image.identifier {
            if let imageURL = info[.imageURL] as? URL {
                guard let userId = user?.userId else { return }

                // Upload to Cloud Storage
                cloudManager.uploadURL(
                    fileUrl: imageURL,
                    filePathString: userId
                ) { [weak self] result in
                    switch result {
                    case let .success(urlString):
                        if self?.isIconPicker == true {
                            self?.user?.userIcon = urlString
                        } else {
                            self?.user?.userCover = urlString
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
