//
//  HomeViewController.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/17.
//

import UIKit
import FirebaseFirestore

class HomeViewController: ITBaseCollectionViewController {
    
   
    private let firestoreManager = FirestoreManager.shared
    
    let userId: String = "r1ddx"
    var user: User? {
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
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: navTitle)
    }
    private func setUpLayouts() {
         view.addSubview(collectionView)
        view.addSubview(tabButtonsView)
        
        tabButtonsView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalTo(view)
            make.height.equalTo(50)
        }
         collectionView.snp.makeConstraints { (make) -> Void in
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
        guard let groups = KeyChainManager.shared.loggedInUser?.groups else { return }
        tabButtonsView.setUpButtons(buttonsCount: groups.count, buttonTitles: groups, buttonStyle: .tab)
        tabButtonsView.didSwitchTabs = { index in
            self.scrollToNewsletter(at: index)
            
        }
    }
    // MARK: - Methods}
    override func headerLoader() {
        fetchUserData()
        endHeaderRefreshing()
    }
    private func fetchUserData() {
        firestoreManager.getDocument(
            asType: User.self,
            documentId: userId,
            reference: firestoreManager.getRef(.users, group: nil)) { result in
                switch result {
                case .success(let user):
                    self.user = user
                    KeyChainManager.shared.loggedInUser = user
                    self.setUpTab()
                    
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                 
                }
                
            }
        
    }
    private func fetchNewsletters() {
        guard let user = user,
        let groups = user.groups else { return }
        let documentId = "\(Date().getLastWeekDateRange())"
        let references = firestoreManager.getRefs(subCollection: .newsletters, groups: groups)
        
        let serialQueue = DispatchQueue(label: "serialQueue")
        let semaphore = DispatchSemaphore(value: 1)

        for reference in references {
           
            serialQueue.async {
              
                semaphore.wait()
                
                self.firestoreManager.getDocument(
                    asType: NewsLetter.self,
                    documentId: documentId,
                    reference: reference,
                    completion: { result in
                        
                        switch result {
                        case .success(let newsletter):
                            self.datas[0].append(newsletter)
                            
                        case .failure(let error):
                            print("Error: \(error.localizedDescription)")
                            
                        }
                        semaphore.signal()
                    
                    })
            }
        }
    }
 override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

            return datas[0].count
        }
        
        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else { fatalError("Cannot create cell") }
           
            cell.user = self.user
            cell.newsletter = datas[0][indexPath.item] as? NewsLetter
            cell.isUserInteractionEnabled = true
            return cell
        }
  
        func scrollToNewsletter(at index: Int) {
            let indexPath = IndexPath(item: index, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    
}

