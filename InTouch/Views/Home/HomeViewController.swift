//
//  HomeViewController.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/17.
//

import FirebaseFirestore
import UIKit

class HomeViewController: ITBaseCollectionViewController {
    private let firestoreManager = FirestoreManager.shared

    var user: User? = KeyChainManager.shared.loggedInUser {
        didSet {
            fetchNewsletters()
        }
    }

    // MARK: - Subview

    let tabButtonsView = ButtonsScrollView()

    // MARK: - View Load

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        headerLoader()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationBar()
        setUpLayouts()
        setupCollectionView()

        tabButtonsView.addGroupHandler = {
            self.showAddGroupPage()
        }
    }

    private func setUpNavigationBar() {
        let navTitle = UILabel()
        navTitle.textColor = .ITBlack
        navTitle.text = "InTouch"
        navTitle.font = .boldSystemFont(ofSize: 26)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navTitle)

        let rightBarButton = UIBarButtonItem(image: UIImage(resource: .iconTimer).withRenderingMode(.alwaysOriginal),
                                             style: .plain,
                                             target: self,
                                             action: #selector(timerButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButton
    }

    private func setUpLayouts() {
        view.addSubview(collectionView)
        view.addSubview(tabButtonsView)

        tabButtonsView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalTo(view)
            make.height.equalTo(50)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(tabButtonsView.snp.bottom)
            make.left.right.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func setupCollectionView() {
        collectionView.collectionViewLayout = configureCollectionLayout()
        collectionView.isPagingEnabled = true
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
    }

    private func configureCollectionLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            section.orthogonalScrollingBehavior = .groupPaging

            return section
        }
        return layout
    }

    private func setUpTab() {
        guard let user = user, let groups = user.groups else { return }
        let groupNames = groups.map(\.groupName)
        tabButtonsView.setUpButtons(
            buttonsCount: groupNames.count,
            buttonTitles: groupNames,
            buttonStyle: .tab
        )
        tabButtonsView.didSwitchTabs = { index in
            self.scrollToNewsletter(at: index)
        }
    }

    // MARK: - Methods

    override func headerLoader() {
        fetchUserData()
    }

    private func fetchUserData() {
        guard let user = user, let email = user.userEmail else { return }
        endHeaderRefreshing()
        firestoreManager.getDocument(
            asType: User.self,
            documentId: email,
            reference: firestoreManager.getRef(.users, groupId: nil)
        ) { result in
            switch result {
            case let .success(user):
                self.user = user
                KeyChainManager.shared.loggedInUser = user
                self.setUpTab()

            case let .failure(error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    private func fetchNewsletters(for _: HomeCollectionViewCell? = nil) {
        guard let user = user, let groups = user.groups else { return }
        let groupIds = groups.map(\.groupId)
        let documentId = "\(Date().getLastWeekDateRange())"
        let references = firestoreManager.getRefs(subCollection: .newsletters, groupIds: groupIds)

        let serialQueue = DispatchQueue(label: "serialQueue")
        let semaphore = DispatchSemaphore(value: 1)
        datas = [[]]
        for reference in references {
            serialQueue.async {
                semaphore.wait()

                self.firestoreManager.getDocument(
                    asType: NewsLetter.self,
                    documentId: documentId,
                    reference: reference,
                    completion: { result in

                        switch result {
                        case let .success(newsletter):
                            self.datas[0].append(newsletter)

                        case let .failure(error):
                            print("Error: \(error.localizedDescription)")
                        }
                        semaphore.signal()
                    }
                )
            }
        }
    }

    @objc private func timerButtonTapped() {
        let timerVC = TimerViewController()
        present(timerVC, animated: true)
    }

    // MARK: - UICollectionView Data Source

    override func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        datas[0].count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else { fatalError("Cannot create cell") }

        cell.user = user
        cell.newsletter = datas[0][indexPath.item] as? NewsLetter
        cell.isUserInteractionEnabled = true
        return cell
    }

    func scrollToNewsletter(at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}
