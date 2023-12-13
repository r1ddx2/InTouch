//
//  DraftViewController.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/17.
//
import UIKit
import FirebaseFirestore
import MobileCoreServices
import UniformTypeIdentifiers
import GooglePlaces
import CoreLocation

enum DraftType: String, CaseIterable {
    case image = "Images"
    case text = "Articles"
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


    
    // MARK: - Subviews
    let tableView = UITableView()
    let headerView = DraftTableHeaderView(user: FakeData.userRed, buttonCount: DraftType.allCases.count, buttonTitles: ["Add image block", "Add text block"], buttonStyle: .round)
    
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
       
        setUpNavigationBar()
        setUpTableView()
        setUpLayouts()
        setUpActions()
        setUpHeaderView()
        fetchUser()
        headerView.changeIcon(userIcon: user?.userIcon)
    }
    private func setUpNavigationBar() {
        let dismissButton = UIBarButtonItem(image: UIImage(resource: .iconClose).withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(dismissTapped))
        navigationItem.rightBarButtonItem = dismissButton
        navigationItem.leftBarButtonItem = editButtonItem
    }
    private func setUpLayouts() {
        view.addSubview(tableView)
        view.addSubview(submitButton)
        tableView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view)
            make.right.equalTo(view)
        }
        submitButton.snp.makeConstraints { (make) -> Void in
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
    }
    private func setUpActions() {
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Button Actions
    @objc private func submitButtonTapped(sender: UIButton) {
        // Get picker data
        let pickerGroup = pickerData[headerView.groupPickerView.selectedRow(inComponent: 0)]
        let selectedGroup = groups.first { $0.groupName == pickerGroup }

        initializeDraft()
        
        // If newsletter exist
        if newsletter != nil {
            // Check if post already exists in the array
            if let existingIndex = newsletter?.posts.firstIndex(
                where: { $0.userId == draft.userId }) {
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
    private func submitPost(group: Group?, newsletter: NewsLetter?){
        guard let newsletter = newsletter, let group = group else { return }
     
        let reference = firestoreManager.getRef(.newsletters, groupId: group.groupId)
        let documentId = Date().getThisWeekDateRange()
        
        firestoreManager.updateDocument(
            documentId: documentId,
            reference: reference,
            updateData: newsletter) { result in
                switch result {
                case .success(let documentId):
                    print("Updated newsletter: \(documentId)")
                    self.dismiss(animated: true)
                    
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
    }
    private func fetchGroups() {
        guard let user = user, let groups = user.groups else { return }
        let documentIds = groups.map({ $0.groupId })
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
                        case .success(let group):
                            self.groups.append(group)
                      
                        case .failure(let error):
                            print("Error: \(error.localizedDescription)")
                            
                        }
                        semaphore.signal()
                    
                    })
            }
        }
    }
    private func fetchUser() {
        guard let user = user else { return }
        firestoreManager.listenDocument(
            asType: User.self,
            documentId: user.userId,
            reference: firestoreManager.getRef(.users, groupId: nil)) { result in
                switch result {
                case .success(let user):
                    self.user = user
                    if let groups = user.groups {
                        let groupNames = groups.map { $0.groupName }
                        self.pickerData = groupNames
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
                
            }
        
    }

    private func fetchDraft(groupId: String) {
       
        firestoreManager.listenDocument(
            asType: NewsLetter.self,
            documentId: Date().getThisWeekDateRange(),
            reference: firestoreManager.getRef(.newsletters, groupId: groupId)) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let newsletter):
                    self.newsletter = newsletter
                    if let draft = newsletter.posts.first(where: { $0.userId == self.user?.userId }) {
                        self.draft = draft
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.draft = Post()
                }
                
            }
    }
    
    // MARK: - Methods
    @objc private func dismissTapped(sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    @objc private func addImageBlockTapped() {

        draft.imageBlocks.append(
            ImageBlock(
                caption: "Write something...",
                image: "",
                location: nil,
                place: nil )
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
            content: "Write something...")
        )
        reload()
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return DraftType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0: return draft.imageBlocks.count
        case 1: return draft.textBlocks.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageBlockDraftCell.identifier, for: indexPath) as? ImageBlockDraftCell else {
                fatalError("Cannot create image cell") }
            
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
            
        default:
            return UITableViewCell(style: .default, reuseIdentifier: String(describing: ITBaseTableViewController.self))}}
    
}
// MARK: - UITable View Delegate
extension DraftViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: DraftTableSectionHeaderView.self)) as? DraftTableSectionHeaderView else {
            fatalError("Cannot create section header")
        }
        headerView.titleLabel.text = DraftType.allCases[section].rawValue
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0 {
                draft.imageBlocks.remove(at: indexPath.row)
            } else if indexPath.section == 1 {
                draft.textBlocks.remove(at: indexPath.row)
            }
        }
    }
    
}
// MARK: - UIImagePickerControllerDelegate
extension DraftViewController {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
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
                    
                    cloudManager.uploadImages(
                        fileUrl: imageURL,
                        userId: user.userId) { [weak self] result in
                            switch result {
                            case .success(let urlString):
                                self?.draft.imageBlocks[indexPath.row].image = urlString
                                self?.dismiss(animated: true)
                                
                            case .failure(let error):
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
        headerView.groupTextField.text = pickerData[row]
        if let selectedGroup = groups.first( where: { $0.groupName == pickerData[row] }) {
            
            fetchDraft(groupId: selectedGroup.groupId)
        }
    }


}

// MARK: - GMSAutocompleteViewController
 
extension DraftViewController: GMSAutocompleteViewControllerDelegate {
    func configureSearchController() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt64(
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
        if let indexPath = self.tableView.indexPath(for: cell) {
            self.draft.imageBlocks[indexPath.row].location = location.coordinate?.toGeoPoint()
            self.draft.imageBlocks[indexPath.row].place = location.name
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

