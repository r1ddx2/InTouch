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
    
    var currentGroup: String?
    var imageBlockCount: Int = 0
    var imageCells: [ImageBlockDraftCell] = []
    var textBlockCount: Int = 0
    var textCells: [TextBlockDraftCell] = []
    var addedImageCell: ImageBlockDraftCell?
    
    // MARK: - Fake data
    let postID = "adskjfks"
    let userID = "panda666"
    let userName = "Panda"
    
    // MARK: - Subviews
    let tableView = UITableView()
    let headerView = DraftTableHeaderView(pickerData: [], buttonCount: DraftType.allCases.count, buttonTitles: ["Add image block", "Add text block"])
    
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let dismissButton = UIBarButtonItem(image: UIImage(resource: .iconClose).withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(dismissTapped))
        navigationItem.rightBarButtonItem = dismissButton
        navigationItem.leftBarButtonItem = editButtonItem
        
        setUpTableView()
        setUpLayouts()
        setUpActions()
        setUpHeaderView()
        fetchGroups()
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
        headerView.buttonsView.buttonsArray[0].addTarget(self, action: #selector(addImageBlockTapped), for: .touchUpInside)
        headerView.buttonsView.buttonsArray[1].addTarget(self, action: #selector(addTextBlockTapped), for: .touchUpInside)
    }
    private func setUpActions() {
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Methods
    @objc private func submitButtonTapped(sender: UIButton) {
        // Get picker data
        guard let selectedGroup = headerView.selectedGroup else {
            return
        }
        // Set up upload data
        let imageBlocks = imageCells.map { $0.imageBlock }
        let textBlocks = textCells.map { $0.textBlock }
        
        let post = Post(
            date: Date(),
            postId: postID,
            userId: userID,
            userIcon: userID,
            userName: userName,
            imageBlocks: imageBlocks,
            textBlocks: textBlocks
        )
        let newsletter = NewsLetter(
            date: Date(),
            newsId: postID,
            newsCover: postID,
            posts: [post],
            title: "\(selectedGroup) Weekly Newsletter"
        )
        
        submitPost(
            group: selectedGroup,
            post: post,
            newsletter: newsletter
        )
        
    }
    private func submitPost(group: String, post: Post, newsletter: NewsLetter) {
        
        let reference = firestoreManager.getNewslettersRef(from: group)
        let documentId = Date().getDateRange()
        
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
    @objc private func dismissTapped(sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    @objc private func addImageBlockTapped() {
        guard imageBlockCount <= 3 else {
            print("Too many blocks")
            return
        }
        imageBlockCount += 1
        reload()
    }
    @objc private func addTextBlockTapped() {
        guard imageBlockCount + textBlockCount <= 5 else {
            print("Too many blocks")
            return
        }
        textBlockCount += 1
        reload()
    }
    
    private func fetchGroups() {
        
        firestoreManager.getDocument(
            asType: User.self,
            documentId: userID,
            reference: firestoreManager.usersRef) { result in
                switch result {
                case .success(let data):
                    guard let groups = data.groups else { return }
                    self.headerView.pickerData = groups
                    print("Updated: \(data)")
                    
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
                
            }
        
    }
    
    private func reload() {
        imageCells.removeAll()
        textCells.removeAll()
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
        case 0: return imageBlockCount
        case 1: return textBlockCount
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageBlockDraftCell.identifier, for: indexPath) as? ImageBlockDraftCell else {
                fatalError("Cannot create image cell") }
            
            imageCells.append(cell)
            
            cell.addImageHandler = { [weak self] in
                self?.addedImageCell = cell
                self?.showImagePicker()
            }
            
            
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextBlockDraftCell.identifier, for: indexPath) as? TextBlockDraftCell else { fatalError("Cannot create text cell") }
            
            textCells.append(cell)
            
            return cell
            
        default:
            return UITableViewCell(style: .default, reuseIdentifier: String(describing: ITBaseTableViewController.self))
        }
        
    }
    
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
                imageBlockCount -= 1
                imageCells.remove(at: indexPath.row)
            } else if indexPath.section == 1 {
                textBlockCount -= 1
                textCells.remove(at: indexPath.row)
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            reload()
        }
    }
    
}
// MARK: - UIImagePickerControllerDelegate
extension DraftViewController {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        
        if let indexPath = tableView.indexPath(for: addedImageCell!) {
            addedImageCell?.userImageView.image = selectedImage
            addedImageCell!.addImageButton.isEnabled = false
            addedImageCell!.addImageButton.isHidden = true
            
            let mediaType = info[.mediaType] as! CFString
            if mediaType as String == UTType.image.identifier {
                if let imageURL = info[.imageURL] as? URL {
                    
                    cloudManager.uploadImages(
                        fileUrl: imageURL,
                        userName: "r1ddx") { [weak self] result in
                            switch result {
                            case .success(let urlString):
                                self?.imageCells[indexPath.row].imageBlock.image = urlString
                                
                            case .failure(let error):
                                print("Error: \(error.localizedDescription)")
                                self?.addedImageCell!.addImageButton.isEnabled = true
                                self?.addedImageCell!.addImageButton.isHidden = false
                            }
                            
                        }
                    
                }
                
            }
            
            dismiss(animated: true)
        }
        
    }
}
