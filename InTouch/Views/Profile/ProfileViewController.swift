//
//  ProfileViewController.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/8.
//

import UIKit

class ProfileViewController: ITBaseViewController {
    var groups: [Group] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    var user: User? = KeyChainManager.shared.loggedInUser {
        didSet {
            layoutPage()
            collectionView.reloadData()
        }
    }

    var newsletters: [NewsLetter] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    private let firestoreManager = FirestoreManager.shared

    override var isHideNavigationBar: Bool {
        true
    }

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

    let tableView = UITableView()
    let profileHeaderView = ProfileHeaderView()
    let myGroupsLabel: UILabel = {
        let label = UILabel()
        label.font = .medium(size: 16)
        label.textColor = .ITBlack
        label.text = "My Groups"
        return label
    }()

    let userCoverView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    let archivedLabel: UILabel = {
        let label = UILabel()
        label.font = .medium(size: 16)
        label.textColor = .ITBlack
        label.text = "Archived Newsletters"
        return label
    }()

    let logOutButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .iconLogOut).withRenderingMode(.alwaysOriginal), for: .normal)
        button.backgroundColor = .ITTransparentGrey
        button.cornerRadius = 15
        return button
    }()

    // MARK: - View Load

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchGroups()
        fetchUserData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchGroups()
        fetchUserData()
        setUpLayouts()
        setUpActions()
        setUpTableView()
    }

    private func setUpLayouts() {
        view.addSubview(userCoverView)
        view.addSubview(profileHeaderView)
        view.addSubview(myGroupsLabel)
        view.addSubview(collectionView)
        view.addSubview(archivedLabel)
        view.addSubview(tableView)
        view.addSubview(logOutButton)

        userCoverView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(100)
        }
        profileHeaderView.snp.makeConstraints { make in
            make.top.equalTo(userCoverView.snp.bottom).offset(24)
            make.left.right.equalTo(view)
            make.height.equalTo(124)
        }
        myGroupsLabel.snp.makeConstraints { make in
            make.top.equalTo(profileHeaderView.snp.bottom).offset(28)
            make.left.equalTo(view).offset(24)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(myGroupsLabel.snp.bottom).offset(4)
            make.left.right.equalTo(view)
            make.height.equalTo(100)
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
        logOutButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.width.equalTo(30)
        }
    }

    private func setUpActions() {
        logOutButton.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
        profileHeaderView.editProfileButton.addTarget(self, action: #selector(editProfileButtonTapped), for: .touchUpInside)
    }

    private func configureCollectionLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 70, height: 80)
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

    private func layoutPage() {
        guard let user = user else { return }
        userCoverView.loadImage(user.userCover)
        profileHeaderView.layoutView(with: user)
    }

    @objc private func addGroupButtonTapped() {
        showAddGroupPage()
    }

    @objc private func logOutButtonTapped() {
        KeyChainManager.shared.loggedInUser = nil
        backToRoot()
    }

    @objc private func editProfileButtonTapped() {
        guard let user = user else { return }
        let profileSettingVC = ProfileSettingsViewController()
        profileSettingVC.user = user
        profileSettingVC.isModalInPresentation = true
        profileSettingVC.modalPresentationStyle = .fullScreen
        present(profileSettingVC, animated: true)
    }

    // MARK: - API Methods

    private func fetchUserData() {
        guard let user = user else { return }
        self.user = nil
        firestoreManager.listenDocument(
            asType: User.self,
            documentId: user.userEmail!,
            reference: firestoreManager.getRef(.users, groupId: nil)
        ) { result in
            switch result {
            case let .success(user):
                self.user = user
                KeyChainManager.shared.loggedInUser = user

            case let .failure(error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    private func fetchGroups() {
        guard let user = user, let userGroups = user.groups else { return }
        let documentIds = userGroups.map(\.groupId)

        let reference = firestoreManager.getRef(.groups, groupId: nil)

        let dispatchGroup = DispatchGroup()
        let serialQueue = DispatchQueue(label: "serialQueue")
        let semaphore = DispatchSemaphore(value: 1)
        groups = []
        for documentId in documentIds {
            dispatchGroup.enter()
            serialQueue.async {
                semaphore.wait()

                self.firestoreManager.getDocument(
                    asType: Group.self,
                    documentId: documentId,
                    reference: reference,
                    completion: { result in

                        defer {
                            dispatchGroup.leave()
                        }

                        switch result {
                        case let .success(group):

                            self.groups.append(group)

                        case let .failure(error):
                            print("Error: \(error.localizedDescription)")
                        }
                        semaphore.signal()
                    }
                )
            }
        }
        dispatchGroup.notify(queue: .main) {
            self.fetchNewsletters()
        }
    }

    private func fetchNewsletters() {
        newsletters = []
        let groupIds = groups.map(\.groupId)
        let references = firestoreManager.getRefs(subCollection: .newsletters, groupIds: groupIds)

        let dispatchGroup = DispatchGroup()
        let serialQueue = DispatchQueue(label: "serialQueue")
        let semaphore = DispatchSemaphore(value: 1)
        var news: [[NewsLetter]] = [[]]

        for reference in references {
            dispatchGroup.enter()
            serialQueue.async {
                semaphore.wait()

                self.firestoreManager.getDocuments(
                    asType: NewsLetter.self,
                    reference: reference,
                    completion: { result in

                        defer {
                            dispatchGroup.leave()
                        }

                        switch result {
                        case let .success(newsletter):

                            news.append(newsletter)

                        case let .failure(error):
                            print("Error: \(error)")
                        }
                        semaphore.signal()
                    }
                )
            }
        }
        dispatchGroup.notify(queue: .main) {
            // Filter and organize all the newsletters
            self.newsletters = news.flatMap { $0 }
            self.newsletters.sort(by: { $0.date < $1.date })
            self.newsletters = self.newsletters.filter {
                $0.date < Date().getLastWeekDay()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        groups.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconAddCollectionViewCell.identifier, for: indexPath) as? IconAddCollectionViewCell else { fatalError("Cannot create cell") }

            cell.addButton.addTarget(self, action: #selector(addGroupButtonTapped), for: .touchUpInside)

            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconsCollectionViewCell.identifier, for: indexPath) as? IconsCollectionViewCell else { fatalError("Cannot create cell") }
            cell.layoutCell(group: groups[indexPath.item - 1])

            return cell
        }
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let groupProfileVC = GroupProfileViewController()
        groupProfileVC.group = groups[indexPath.item - 1]
        navigationController?.pushViewController(groupProfileVC, animated: true)
    }

    func collectionView(_: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if indexPath.item == 0 {
            return false
        } else {
            return true
        }
    }
}

// MARK: - UITableView Data Source & Delegate

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        guard newsletters.isEmpty == false else { return 0 }
        return newsletters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileNewsletterTableViewCell.identifier, for: indexPath) as? ProfileNewsletterTableViewCell else { fatalError("Cannot create cell") }

        cell.newsletter = newsletters[indexPath.row]
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsletterVC = NewsletterViewController()
        newsletterVC.newsletter = newsletters[indexPath.row]
        navigationController?.pushViewController(newsletterVC, animated: true)
    }
}
