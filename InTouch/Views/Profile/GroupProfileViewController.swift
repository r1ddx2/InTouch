//
//  GroupProfileViewController.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/8.
//

import UIKit

class GroupProfileViewController: ITBaseViewController {
    
    var group: Group? {
        didSet {
            layoutPage()
            collectionView.reloadData()
        }
    }
    var users: [User] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    var newsletters: [NewsLetter] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let firestoreManager = FirestoreManager.shared
    // MARK: - Subviews
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(IconsCollectionViewCell.self, forCellWithReuseIdentifier: IconsCollectionViewCell.identifier)
        collectionView.register(IconAddCollectionViewCell.self, forCellWithReuseIdentifier: IconAddCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
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
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .iconBack).withRenderingMode(.alwaysOriginal), for: .normal)
        button.backgroundColor = .ITTransparentGrey
        button.cornerRadius = 15
        return button
    }()
    let settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .iconSettings).withRenderingMode(.alwaysOriginal), for: .normal)
        button.backgroundColor = .ITTransparentGrey
        button.cornerRadius = 15
        return button
    }()
    let myMembersLabel: UILabel = {
        let label = UILabel()
        label.font = .medium(size: 16)
        label.textColor = .ITBlack
        label.text = "Members"
        return label
    }()
    let archivedLabel: UILabel = {
        let label = UILabel()
        label.font = .medium(size: 16)
        label.textColor = .ITBlack
        label.text = "Archived Newsletters"
        return label
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
        fetchGroupData()
        setUpLayouts()
        setUpActions()
        setUpTableView()
    }
    private func setUpLayouts() {
        view.addSubview(groupCoverView)
        view.addSubview(groupIconView)
        view.addSubview(groupNameLabel)
        view.addSubview(membersCountLabel)
        view.addSubview(collectionView)
        view.addSubview(backButton)
        view.addSubview(settingsButton)
        view.addSubview(myMembersLabel)
        view.addSubview(archivedLabel)
        view.addSubview(tableView)
        
        groupCoverView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(120)
        }
        groupIconView.snp.makeConstraints { make in
            make.height.width.equalTo(100)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(groupCoverView.snp.bottom).offset(-50)
        }
        groupNameLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(groupIconView.snp.bottom).offset(20)
            make.centerX.equalTo(view.snp.centerX)
        }
        membersCountLabel.snp.makeConstraints { make in
            make.top.equalTo(groupNameLabel.snp.bottom).offset(10)
            make.centerX.equalTo(view.snp.centerX)
        }
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.height.width.equalTo(30)
        }
        settingsButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.width.equalTo(30)
        }
        myMembersLabel.snp.makeConstraints { make in
            make.top.equalTo(membersCountLabel.snp.bottom).offset(24)
            make.left.equalTo(view).offset(24)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(myMembersLabel.snp.bottom).offset(16)
            make.height.equalTo(85)
            make.right.left.equalTo(view)
        }
        archivedLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(16)
            make.left.equalTo(view).offset(24)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(archivedLabel.snp.bottom).offset(12)
            make.left.right.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    private func setUpActions() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
    }
    private func configureCollectionLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 75, height: 85)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return layout
    }
    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProfileNewsletterTableViewCell.self, forCellReuseIdentifier: ProfileNewsletterTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 1000
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.cellLayoutMarginsFollowReadableWidth = false
    }
    
    // MARK: - Methods
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc private func settingsButtonTapped() {
        guard let group = group else { return }
        let groupSettingVC = GroupSettingsViewController()
        groupSettingVC.groupId = group.groupId
        groupSettingVC.users = users
        groupSettingVC.isModalInPresentation = true
        groupSettingVC.modalPresentationStyle = .fullScreen
        present(groupSettingVC, animated: true)
    }
    @objc private func addMemberButtonTapped() {
        
    }
    private func layoutPage() {
        guard let group = group, let members = group.members else { return }
        groupCoverView.loadImage(group.groupCover)
        groupIconView.loadImage(group.groupIcon)
        groupNameLabel.text = "\(group.groupName)"
        membersCountLabel.text = "\(members.count) members"
    }
    // MARK: - API Methods
    private func fetchUsers() {
        users = []
        guard let group = group, let members = group.members else { return }
        
        let documentIds = members.map({ $0.userEmail })
        let reference = firestoreManager.getRef(.users, groupId: nil)
        
        let serialQueue = DispatchQueue(label: "serialQueue")
        let semaphore = DispatchSemaphore(value: 1)
        
        for documentId in documentIds {
            
            serialQueue.async {
                semaphore.wait()
                
                self.firestoreManager.listenDocument(
                    asType: User.self,
                    documentId: documentId!,
                    reference: reference,
                    completion: { result in
                        
                        switch result {
                        case .success(let user):
                            
                            self.users.append(user)
                            print(self.users)
                            
                        case .failure(let error):
                            print("Error: \(error.localizedDescription)")
                            
                        }
                        semaphore.signal()
                        
                    })
            }
        }
    }
    private func fetchGroupData() {
        guard let group = group else { return }
        self.group = nil
        firestoreManager.listenDocument(
            asType: Group.self,
            documentId: group.groupId,
            reference: firestoreManager.getRef(.groups, groupId: nil)) { result in
                switch result {
                case .success(let group):
                    self.group = group
                    self.fetchUsers()
                    self.fetchNewsletters()
                    
                case .failure(let error):
                    print("Error: \(error)")
                    
                }
                
            }
        
    }
    
    private func fetchNewsletters() {
        guard let group = group else { return }
        newsletters = []
        let groupId = group.groupId
        let reference = firestoreManager.getRef(.newsletters, groupId: groupId)
        
        firestoreManager.getDocuments(
            asType: NewsLetter.self,
            reference: reference,
            completion: { result in
                
                switch result {
                case .success(let newsletter):
                    var news = newsletter
                    news.sort(by: { $0.date > $1.date })
                    self.newsletters = news
                    print("xxxxxxxxxxxxxxxxxxx")
                    print(self.newsletters)
                    print("xxxxxxxxxxxxxxxxxxx")
                case .failure(let error):
                    print("Error: \(error)")
                    
                }
                
            })
        
        
    }
    
    
}
// MARK: - UICollectionViewDataSource
extension GroupProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard users.isEmpty == false else { return 0 }
        return users.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconAddCollectionViewCell.identifier, for: indexPath) as? IconAddCollectionViewCell else { fatalError("Cannot create cell") }
          
            cell.addButton.addTarget(self, action: #selector(addMemberButtonTapped), for: .touchUpInside)
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconsCollectionViewCell.identifier, for: indexPath) as? IconsCollectionViewCell else { fatalError("Cannot create cell") }
       
            print("Users: \(users)")
            cell.layoutCell(user: users[indexPath.item - 1])
            
            return cell
        }
    
    }
}

// MARK: - UITableView Data Source
extension GroupProfileViewController: UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard newsletters.isEmpty == false else { return 0 }
        return newsletters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileNewsletterTableViewCell.identifier, for: indexPath) as? ProfileNewsletterTableViewCell else { fatalError("Cannot create cell") }
        
        cell.newsletter = newsletters[indexPath.row]
        return cell
    }
    
}

