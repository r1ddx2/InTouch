//
//  HomeViewController.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/17.
//

import UIKit
import FirebaseFirestore

class HomeViewController: ITBaseTableViewController {
    let currentGroup = "iOS Group"
    private let firestoreManager = FirestoreManager.shared
    
    var user: User?
    
    var newsletter: NewsLetter? {
        didSet {
            reloadData()
        }
    }
    
    // MARK: - Subviews
    let headerView = ButtonsScrollView()
    
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
        setUpTableView()
        setUpActions()
        fetchUserData()
    }
    private func setUpLayouts() {
    
        view.addSubview(tableView)
        
       
        tableView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
        }
        
    }
    private func setUpTableView() {
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        tableView.register(HomeTableViewTextCell.self, forCellReuseIdentifier: HomeTableViewTextCell.identifier)
        tableView.register(HomeTableViewImageCell.self, forCellReuseIdentifier: HomeTableViewImageCell.identifier)
        tableView.register(NewsletterHeaderViewCell.self, forCellReuseIdentifier: NewsletterHeaderViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 1000
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.tableHeaderView = headerView
        tableView.tableHeaderView?.frame.size.height = 50
    }
 
    private func setUpActions() {
        
    }
    private func setUpTab() {
        guard let groups = user?.groups else { return }
        headerView.setUpButtons(buttonsCount: groups.count, buttonTitles: groups, buttonStyle: .tab)
    }
    
    // MARK: - Methods}
    override func headerLoader() {
        fetchUserData()
        fetchNewsletter()
        endHeaderRefreshing()
    }
    private func fetchUserData() {
        self.user = nil
        firestoreManager.getDocument(
            asType: User.self,
            documentId: FakeData.userRed.userId,
            reference: firestoreManager.usersRef) { result in
                switch result {
                case .success(let data):
                    self.user = data
                    self.setUpTab()
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
                
            }
        
    }
    func fetchNewsletter() {
        self.newsletter = nil
        let lastWeek = Date().getLastWeekDateRange()
        let documentId = "\(lastWeek)"
        let reference = firestoreManager.getNewslettersRef(from: currentGroup)
        
        firestoreManager.getDocument(
            asType: NewsLetter.self,
            documentId: documentId,
            reference: reference) { result in
                switch result {
                case .success(let newsletter):
                    self.newsletter = newsletter
                    print("-------------------")
                    print("Newsletter: \(self.newsletter)")
                    print("-------------------")
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    
                    
                }
                
            }
    }
    // MARK: - UITableView DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let newsletter = newsletter else { return 0 }
        return newsletter.posts.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Header cell
        guard let headerCell = tableView.dequeueReusableCell(withIdentifier: NewsletterHeaderViewCell.identifier, for: indexPath) as? NewsletterHeaderViewCell else { fatalError("Cannot create cell")
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell else {
            fatalError("Cannot create cell")
        }
        guard let textCell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewTextCell.identifier, for: indexPath) as? HomeTableViewTextCell else {
            fatalError("Cannot create text cell")
        }
        guard let imageCell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewImageCell.identifier, for: indexPath) as? HomeTableViewImageCell else {
            fatalError("Cannot create image cell")
        }
        
        guard let newsletter = newsletter else {
            return UITableViewCell()
        }
     
        guard indexPath.row != 0 else {
            headerCell.layoutCell(
                image: newsletter.newsCover,
                title: newsletter.title,
                date: newsletter.date.getThisWeekDateRange()
            )
            return headerCell
        }
       
        let post = newsletter.posts[indexPath.row - 1]
        let user = User(userId: post.userId, userName: post.userName, userIcon: post.userIcon)
        
        if post.imageBlocks.isEmpty == true {
            textCell.layoutCell(textBlock: post.textBlocks, user: user)
            return textCell
            
        } else if post.textBlocks.isEmpty == true {
            imageCell.layoutCell(imageBlocks: post.imageBlocks, user: user)
            return imageCell
            
        } else {
            cell.layoutCell(imageBlocks: post.imageBlocks, textBlocks: post.textBlocks, user: user)
            return cell
        }
    }
    
    // MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        false
    }
    
}

