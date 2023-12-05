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

enum DraftType: String, CaseIterable {
    case image = "Images"
    case text = "Articles"
}


class DraftViewController: ITBaseViewController {
    
    private let firestoreManager = FirestoreManager.shared
    private let cloudManager = CloudStorageManager.shared

    var addedImageCell: ImageBlockDraftCell?
    
    var draft: Post? = Post(
        date: Date(),
        postId: "",
        userId: FakeData.userRed.userId,
        userIcon: FakeData.userRed.userIcon,
        userName: FakeData.userRed.userName,
        imageBlocks: [],
        textBlocks: []){
        didSet {
            reload()
        }
    }
    var pickerData: [String] = [] {
        didSet {
            headerView.groupPickerView.reloadAllComponents()
        }
    }

    // MARK: - Fake Data
    let user = FakeData.userRed
    
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
        fetchGroups()
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
    
    // MARK: - API Methods
    @objc private func submitButtonTapped(sender: UIButton) {
        // Get picker data
        let selectedGroup = pickerData[headerView.groupPickerView.selectedRow(inComponent: 0)]
        guard let draft = draft else { return }
        // Set up upload data
        let newsletter = NewsLetter(
            date: Date(),
            newsId: FakeData.postId,
            newsCover: FakeData.postId,
            posts: [draft],
            title: "\(selectedGroup) Weekly Newsletter"
        )
        
        submitPost(
            group: selectedGroup,
            post: draft,
            newsletter: newsletter
        )
        
    }
    private func submitPost(group: String, post: Post, newsletter: NewsLetter) {
        
        let reference = firestoreManager.getRef(.newsletters, group: group)
        // let documentId = Date().getThisWeekDateRange()
        let documentId = Date().getLastWeekDateRange()
        isNewsletterExist(
            reference: reference,
            documentId: documentId) { [weak self] result in
                guard let self = self else { return }
                switch result {
                    
                /// Update newsletter
                case true:
                    self.firestoreManager.updateNewsletter(
                        documentId: documentId,
                        reference: reference,
                        updatePost: post,
                        updateNews: newsletter) { result in
                            switch result {
                            case .success(let documentId):
                                print("Updated newsletter: \(documentId)")
                                self.dismiss(animated: true)
                            case .failure(let error):
                                print("Error: \(error.localizedDescription)")
                            }
                        }
                    
                /// Create newsletter
                case false:
                    self.firestoreManager.addDocument(
                        data: newsletter,
                        reference: reference,
                        documentId: documentId){ result in
                            switch result {
                            case .success(let documentId):
                                print("Updated newsletter: \(documentId)")
                            case .failure(let error):
                                print("Error: \(error.localizedDescription)")
                            }
                        }
                    
                }
            }
        
    }
    private func isNewsletterExist(reference: CollectionReference, documentId: String, completion: @escaping (Bool) -> Void) {
        
        // Check if the document already exists
        firestoreManager.isDocumentExist(
            documentId: documentId,
            reference: reference) { result in
                switch result {
                // Already exists
                case .success:
                    completion(true)
                // Don't exist
                case .failure(let error):
                    if error as? FFError == FFError.invalidDocument {
                        completion(false)
                    } else {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
        
    }
    private func fetchGroups() {
        
        firestoreManager.getDocument(
            asType: User.self,
            documentId: user.userId,
            reference: firestoreManager.getRef(.users, group: nil)) { result in
                switch result {
                case .success(let data):
                    guard let groups = data.groups else { return }
                    self.pickerData = groups
                    print("Updated: \(data)")
                    
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
                
            }
        
    }
    
    private func fetchDraft(selectedGroup: String) {
    
        firestoreManager.getDocument(
            asType: NewsLetter.self,
            documentId: Date().getLastWeekDateRange(),
            reference: firestoreManager.getRef(.newsletters, group: selectedGroup)) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let data):
                    let draft = data.posts.first { $0.userId == self.user.userId }
                    print(data)
                    self.draft = draft
                 print(draft)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
                
            }
    }
    
    // MARK: - Methods
    @objc private func dismissTapped(sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    @objc private func addImageBlockTapped() {
        guard draft?.imageBlocks.count ?? 0 <= 3 else {
            print("Too many blocks")
            return
        }
    
        draft?.imageBlocks.append(
            ImageBlock(
                caption: "Write something...",
                image: "",
                location: nil,
                place: nil )
        )
        reload()
    }
    @objc private func addTextBlockTapped() {
        guard draft?.textBlocks.count ?? 0 <= 3 else {
            print("Too many blocks")
            return
        }
    
        draft?.textBlocks.append(
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
    private func presentAddLocationVC(from cell: ImageBlockDraftCell) {
        let addLocationVC = AddLocationViewController()
        self.navigationController?.pushViewController(addLocationVC, animated: true)
        addLocationVC.didSelectLocation = { [weak self] location in
            guard let self = self else { return }
            
            cell.locationLabel.text = location.name
            if let indexPath = self.tableView.indexPath(for: cell) {
                self.draft?.imageBlocks[indexPath.row].location = location.coordinate?.toGeoPoint()
                self.draft?.imageBlocks[indexPath.row].place = location.address
            }
           
        }
    }
}

// MARK: - UITableView Data Source
extension DraftViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return DraftType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let draft = draft else{ return 0 }
        switch section{
        case 0: return draft.imageBlocks.count
        case 1: return draft.textBlocks.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let draft = draft else { return UITableViewCell() }
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageBlockDraftCell.identifier, for: indexPath) as? ImageBlockDraftCell else {
                fatalError("Cannot create image cell") }
            
            cell.layoutCell(imageBlock: draft.imageBlocks[indexPath.row])
  
            cell.editCaptionHandler = { [weak self] text in
                if let indexPath = self?.tableView.indexPath(for: cell) {
                    self?.draft?.imageBlocks[indexPath.row].caption = text
                }
            }
            cell.addImageHandler = { [weak self] in
                self?.addedImageCell = cell
                self?.showImagePicker()
            }
            
            cell.addLocationHandler = { [weak self] in
                self?.presentAddLocationVC(from: cell)
            }
            
            
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextBlockDraftCell.identifier, for: indexPath) as? TextBlockDraftCell else { fatalError("Cannot create text cell") }
         
            cell.layoutCell(textBlock: draft.textBlocks[indexPath.row])

            
            cell.editTitleHandler = { [weak self] text in
                if let indexPath = self?.tableView.indexPath(for: cell) {
                    self?.draft?.textBlocks[indexPath.row].title = text
                }
            }
            cell.editContentHandler = { [weak self] text in
                if let indexPath = self?.tableView.indexPath(for: cell) {
                    self?.draft?.textBlocks[indexPath.row].content = text
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
                draft?.imageBlocks.remove(at: indexPath.row)
            } else if indexPath.section == 1 {
                draft?.textBlocks.remove(at: indexPath.row)
            }
        }
    }
    
}
// MARK: - UIImagePickerControllerDelegate
extension DraftViewController {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        
        if let indexPath = tableView.indexPath(for: addedImageCell!) {
            print("indexPath: \(indexPath)")
            let mediaType = info[.mediaType] as! CFString
            if mediaType as String == UTType.image.identifier {
                if let imageURL = info[.imageURL] as? URL {
                    
                    cloudManager.uploadImages(
                        fileUrl: imageURL,
                        userName: user.userId) { [weak self] result in
                            switch result {
                            case .success(let urlString):
                                self?.draft?.imageBlocks[indexPath.row].image = urlString
                                
                            case .failure(let error):
                                print("Error: \(error.localizedDescription)")
                        
                            }
                            
                        }
                    
                }
                
            }
            
            dismiss(animated: true)
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
        fetchDraft(selectedGroup: pickerData[row])
    }


}

