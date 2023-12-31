//
//  DraftViewController.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/17.
//
import CoreLocation
import FirebaseFirestore
import GooglePlaces
import MobileCoreServices
import UIKit
import UniformTypeIdentifiers

enum DraftType: String, CaseIterable {
    case image = "Images"
    case text = "Articles"
    case audio = "Audio"
}

class DraftViewController: ITBaseViewController {
    private let firestoreManager = FirestoreManager.shared
    private let cloudManager = CloudStorageManager.shared
    private let googlePlaceManager = GooglePlacesManager.shared

    var modifyCell: ImageBlockDraftCell?

    // MARK: - Data

    var user: User? = KeyChainManager.shared.loggedInUser {
        didSet {
            fetchGroups()
        }
    }

    var groups: [Group] = []
    var draft = Post() {
        didSet {
            reload()
        }
    }

    var newsletter: NewsLetter?

    var pickerData: [String] = [] {
        didSet {
            headerView.groupPickerView.reloadAllComponents()
        }
    }

    var localAudioURLs: [URL] = []

    // MARK: - Subviews

    let tableView = UITableView()
    var headerView: DraftTableHeaderView!

    let submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Submit Newsletter", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .bold(size: 16)
        button.backgroundColor = .ITBlack
        button.layer.cornerRadius = 8
        return button
    }()

    // MARK: - View Load

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        initializeHeaderView()
        setUpNavigationBar()
        setUpTableView()
        setUpLayouts()
        setUpActions()
        setUpHeaderView()
        fetchUser()
        headerView.changeIcon(userIcon: user?.userIcon)
    }

    private func initializeHeaderView() {
        guard let user = user else { return }
        headerView = DraftTableHeaderView(user: user, buttonCount: DraftType.allCases.count, buttonTitles: ["Add image block", "Add text block", "Add audio block"], buttonStyle: .round)
    }

    private func setUpNavigationBar() {
        let dismissButton = UIBarButtonItem(image: UIImage(resource: .iconClose).withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(dismissTapped))
        navigationItem.rightBarButtonItem = dismissButton
        navigationItem.leftBarButtonItem = editButtonItem
    }

    private func setUpLayouts() {
        view.addSubview(tableView)
        view.addSubview(submitButton)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view)
            make.right.equalTo(view)
        }
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(16)
            make.left.equalTo(view).offset(16)
            make.right.equalTo(view).offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(45)
        }
    }

    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TextBlockDraftCell.self, forCellReuseIdentifier: TextBlockDraftCell.identifier)
        tableView.register(ImageBlockDraftCell.self, forCellReuseIdentifier: ImageBlockDraftCell.identifier)
        tableView.register(AudioBlockDraftCell.self, forCellReuseIdentifier: AudioBlockDraftCell.identifier)
        tableView.register(DraftTableSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: DraftTableSectionHeaderView.identifier)
        tableView.rowHeight = 170
        tableView.sectionHeaderHeight = 45
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.tableHeaderView = headerView
        tableView.tableHeaderView?.frame.size.height = 170
        tableView.tableHeaderView?.frame.size.width = UIScreen.main.bounds.width
        tableView.tableFooterView = UIView()
    }

    private func setUpHeaderView() {
        headerView.groupPickerView.dataSource = self
        headerView.groupPickerView.delegate = self
        headerView.buttonsView.buttonsArray[0].addTarget(self, action: #selector(addImageBlockTapped), for: .touchUpInside)
        headerView.buttonsView.buttonsArray[1].addTarget(self, action: #selector(addTextBlockTapped), for: .touchUpInside)
        headerView.buttonsView.buttonsArray[2].addTarget(self, action: #selector(addAudioBlockTapped), for: .touchUpInside)
    }

    private func setUpActions() {
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }

    // MARK: - Button Actions

    @objc private func submitButtonTapped(sender _: UIButton) {
        // Get picker data
        let pickerGroup = pickerData[headerView.groupPickerView.selectedRow(inComponent: 0)]
        let selectedGroup = groups.first { $0.groupName == pickerGroup }
        print("picker:\(pickerGroup)")
        print("selected: \(selectedGroup)")

        initializeDraft()

        // If newsletter exist
        if newsletter != nil {
            // Check if post already exists in the array
            if let existingIndex = newsletter?.posts.firstIndex(
                where: { $0.userId == draft.userId })
            {
                // Exist, update post
                newsletter?.posts[existingIndex] = draft
            } else {
                // Don't exist, add to posts
                newsletter?.posts.append(draft)
            }
            // If newsletter doesn't exist
        } else {
            initializeNewsletter(with: selectedGroup)
            newsletter?.posts = [draft]
        }

        submitPost(group: selectedGroup, newsletter: newsletter)
    }

    // MARK: - Methods

    private func initializeNewsletter(with group: Group?) {
        guard let group = group else { return }
        if let groupCover = group.groupCover {
            newsletter = NewsLetter(
                date: Date(),
                newsId: generateRandomCode(),
                newsCover: groupCover,
                posts: [],
                title: "\(group.groupName) Weekly Newsletter"
            )
        }
    }

    private func initializeDraft() {
        guard let user = user, let userIcon = user.userIcon else { return }
        draft.userId = user.userId
        draft.userIcon = userIcon
        draft.userName = user.userName
        draft.postId = generateRandomCode()
    }

    // MARK: - API Methods

    private func submitPost(group: Group?, newsletter: NewsLetter?) {
        guard let newsletter = newsletter else { return }
        guard let group = group else { return }

        let reference = firestoreManager.getRef(.newsletters, groupId: group.groupId)
        let documentId = Date().getLastWeekDateRange()

        firestoreManager.updateDocument(
            documentId: documentId,
            reference: reference,
            updateData: newsletter
        ) { result in
            switch result {
            case let .success(documentId):
                print("Updated newsletter: \(documentId)")
                self.dismiss(animated: true)

            case let .failure(error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    private func fetchGroups() {
        guard let user = user, let groups = user.groups else { return }
        let documentIds = groups.map(\.groupId)
        let reference = firestoreManager.getRef(.groups, groupId: nil)

        let serialQueue = DispatchQueue(label: "serialQueue")
        let semaphore = DispatchSemaphore(value: 1)

        for documentId in documentIds {
            serialQueue.async {
                semaphore.wait()

                self.firestoreManager.listenDocument(
                    asType: Group.self,
                    documentId: documentId,
                    reference: reference,
                    completion: { result in

                        switch result {
                        case let .success(group):
                            self.groups.append(group)
                            print("all groups: \(self.groups)")
                        case let .failure(error):
                            print("Error: \(error.localizedDescription)")
                        }
                        semaphore.signal()
                    }
                )
            }
        }
    }

    private func fetchUser() {
        guard let user = user else { return }
        firestoreManager.listenDocument(
            asType: User.self,
            documentId: user.userEmail!,
            reference: firestoreManager.getRef(.users, groupId: nil)
        ) { result in
            switch result {
            case let .success(user):
                self.user = user
                if let groups = user.groups {
                    let groupNames = groups.map(\.groupName)
                    self.pickerData = groupNames
                }
            case let .failure(error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    private func fetchDraft(groupId: String) {
        firestoreManager.listenDocument(
            asType: NewsLetter.self,
            documentId: Date().getLastWeekDateRange(),
            reference: firestoreManager.getRef(.newsletters, groupId: groupId)
        ) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case

                let .success(newsletter):
                self.newsletter = newsletter
                if let draft = newsletter.posts.first(where: { $0.userId == self.user?.userId }) {
                    self.draft = draft
                }
            case let .failure(error):
                print("Error: \(error.localizedDescription)")
                self.draft = Post()
            }
        }
    }

    // MARK: - Methods

    @objc private func dismissTapped(sender _: UIBarButtonItem) {
        dismiss(animated: true)
    }

    @objc private func addImageBlockTapped() {
        draft.imageBlocks.append(
            ImageBlock(
                caption: "Write something...",
                image: "",
                location: nil,
                place: nil
            )
        )
        reload()
    }

    @objc private func addTextBlockTapped() {
//        guard draft?.textBlocks.count ?? 0 <= 3 else {
//            print("Too many blocks")
//            return
//        }
        draft.textBlocks.append(
            TextBlock(
                title: "",
                content: "Write something..."
            )
        )
        reload()
    }

    @objc func addAudioBlockTapped() {
        let audioVC = AudioRecordViewController()

        audioVC.urlHandler = { [weak self] url in
            guard let self = self else { return }
            self.draft.audioBlocks.append(
                AudioBlock(audioUrl: url)
            )
            self.reload()
            print("draft: \(draft.audioBlocks)")
        }
        audioVC.isModalInPresentation = true
        configureSheetPresent(vc: audioVC, height: 240)
    }

    private func reload() {
        tableView.reloadData()
    }

    private func updateButtonUI(active: Bool, for buttonIndex: Int) {
        if active {
            headerView.buttonsView.buttonsArray[buttonIndex].setTitleColor(.ITDarkGrey, for: .normal)
            headerView.buttonsView.buttonsArray[buttonIndex].isUserInteractionEnabled = false
        } else {
            headerView.buttonsView.buttonsArray[buttonIndex].setTitleColor(.ITBlack, for: .normal)
            headerView.buttonsView.buttonsArray[buttonIndex].isUserInteractionEnabled = true
        }
    }
}

// MARK: - UITableView Data Source

extension DraftViewController: UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        DraftType.allCases.count
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return draft.imageBlocks.count
        case 1: return draft.textBlocks.count
        case 2: return draft.audioBlocks.count
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageBlockDraftCell.identifier, for: indexPath) as? ImageBlockDraftCell else {
                fatalError("Cannot create image cell")
            }

            cell.layoutCell(imageBlock: draft.imageBlocks[indexPath.row])

            cell.editCaptionHandler = { [weak self] text in
                if let indexPath = self?.tableView.indexPath(for: cell) {
                    self?.draft.imageBlocks[indexPath.row].caption = text
                }
            }
            cell.addImageHandler = { [weak self] in
                self?.modifyCell = cell
                self?.showImagePicker()
            }

            cell.addLocationHandler = { [weak self] in
                // self?.presentAddLocationVC(from: cell)
                self?.modifyCell = cell
                self?.configureSearchController()
            }

            return cell

        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextBlockDraftCell.identifier, for: indexPath) as? TextBlockDraftCell else { fatalError("Cannot create text cell") }

            cell.layoutCell(textBlock: draft.textBlocks[indexPath.row])
            cell.editTitleHandler = { [weak self] text in
                if let indexPath = self?.tableView.indexPath(for: cell) {
                    self?.draft.textBlocks[indexPath.row].title = text
                }
            }
            cell.editContentHandler = { [weak self] text in
                if let indexPath = self?.tableView.indexPath(for: cell) {
                    self?.draft.textBlocks[indexPath.row].content = text
                }
            }
            return cell

        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AudioBlockDraftCell.identifier, for: indexPath) as? AudioBlockDraftCell else { fatalError("Cannot create text cell") }
            cell.audioBlockView.downloadAudio(remoteURL: draft.audioBlocks[indexPath.row].audioUrl)
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 100
            return cell

        default:
            return UITableViewCell()
        }
    }
}

// MARK: - UITable View Delegate

extension DraftViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: DraftTableSectionHeaderView.self)) as? DraftTableSectionHeaderView
        else {
            fatalError("Cannot create section header")
        }
        headerView.titleLabel.text = DraftType.allCases[section].rawValue
        return headerView
    }

    func tableView(_: UITableView, shouldHighlightRowAt _: IndexPath) -> Bool {
        false
    }

    func tableView(_: UITableView, heightForFooterInSection _: Int) -> CGFloat {
        0.01
    }

    func tableView(_: UITableView, canEditRowAt _: IndexPath) -> Bool {
        true
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.isEditing = true
        tableView.allowsSelectionDuringEditing = editing
        if !editing {
            tableView.isEditing = false
        }
    }

    func tableView(_: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            switch indexPath.section {
            case 0: draft.imageBlocks.remove(at: indexPath.row)
            case 1: draft.textBlocks.remove(at: indexPath.row)
            case 2: draft.audioBlocks.remove(at: indexPath.row)
            default: break
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

extension DraftViewController {
    func imagePickerController(_: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
    {
        guard let selectedImage = info[.editedImage] as? UIImage,
              let cell = modifyCell,
              let user = user else { return }
        // Update UI
        cell.userImageView.image = selectedImage

        // Upload Cloud Storage
        if let indexPath = tableView.indexPath(for: cell) {
            let mediaType = info[.mediaType] as! CFString
            if mediaType as String == UTType.image.identifier {
                if let imageURL = info[.imageURL] as? URL {
                    cloudManager.uploadURL(
                        fileUrl: imageURL,
                        filePathString: user.userId
                    ) { [weak self] result in
                        switch result {
                        case let .success(urlString):
                            self?.draft.imageBlocks[indexPath.row].image = urlString
                            self?.dismiss(animated: true)

                        case let .failure(error):
                            print("Error: \(error.localizedDescription)")
                            cell.userImageView.image = nil
                            self?.dismiss(animated: true)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - UIPickerView Data Source & Delegate

extension DraftViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in _: UIPickerView) -> Int {
        1
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        pickerData.count
    }

    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        pickerData[row]
    }

    func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
        headerView.groupTextField.text = pickerData[row]
        if let selectedGroup = groups.first(where: { $0.groupName == pickerData[row] }) {
            fetchDraft(groupId: selectedGroup.groupId)
        }
    }
}

// MARK: - GMSAutocompleteViewController

extension DraftViewController: GMSAutocompleteViewControllerDelegate {
    func configureSearchController() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        let fields = GMSPlaceField(rawValue: UInt64(
            UInt(GMSPlaceField.name.rawValue) |
                UInt(GMSPlaceField.placeID.rawValue) |
                UInt(GMSPlaceField.coordinate.rawValue) |
                UInt(GMSPlaceField.formattedAddress.rawValue)
        ))
        autocompleteController.placeFields = fields

        let navigationController = ITBaseNavigationController(rootViewController: autocompleteController)
        present(navigationController, animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Get selected Place
        let location = Place(
            name: place.name ?? "",
            identifier: place.placeID ?? "",
            address: place.formattedAddress ?? "",
            coordinate: place.coordinate
        )

        // Modify the image cell location
        guard let cell = modifyCell else {
            return
        }
        cell.locationLabel.text = location.name
        if let indexPath = tableView.indexPath(for: cell) {
            draft.imageBlocks[indexPath.row].location = location.coordinate?.toGeoPoint()
            draft.imageBlocks[indexPath.row].place = location.name
        }

        // Dismiss
        navigationController?.popToRootViewController(animated: false)
        viewController.dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: \(error.localizedDescription)")
        viewController.dismiss(animated: true, completion: nil)
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
