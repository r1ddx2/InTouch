//
//  HomeViewController.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/17.
//

import UIKit
import FirebaseFirestore

class HomeViewController: ITBaseCollectionViewController {
    
    let currentGroup = FakeData.userRed.groups![0]
    private let firestoreManager = FirestoreManager.shared
    override var isHideNavigationBarOnScroll: Bool {
        return true
    }
    
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
        setUpLayouts()
        setupCollectionView()
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
        collectionView.isUserInteractionEnabled = false
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
        guard let groups = user?.groups else { return }
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
            documentId: FakeData.userRed.userId,
            reference: firestoreManager.getRef(.users, group: nil)) { result in
                switch result {
                case .success(let user):
                    self.user = user
                    self.setUpTab()
                    
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                 
                }
                
            }
        
    }
    private func fetchNewsletters() {
        print("User:\(self.user)")
        guard let user = user,
        let groups = user.groups else { return }
   
        let documentId = "\(Date().getLastWeekDateRange())"
        let references = firestoreManager.getRefs(subCollection: .newsletters, groups: groups).getReversed()
        
        firestoreManager.getDocuments(
            asType: NewsLetter.self,
            documentId: documentId,
            references: references,
            completion: { result in
                switch result {
                case .success(let newsletter):
                    self.datas = [newsletter]
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    
                }
                
            })
    }
 override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     print(datas[0].count)
     print(datas)
            return datas[0].count
        }
        
        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else { fatalError("Cannot create cell") }
           
            cell.user = self.user
            cell.newsletter = datas[0][indexPath.item] as? NewsLetter
           
            return cell
        }
  
        func scrollToNewsletter(at index: Int) {
            let indexPath = IndexPath(item: index, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    
}
extension HomeViewController: HomeCollectionViewCellDelegate {
    func didLoadHeader(_ cell: HomeCollectionViewCell, tableView: UITableView)  {
      
    }
    
    
}
