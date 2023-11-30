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
    
    var newsletter: NewsLetter? {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Subviews
    let headerView = HomeTableHeaderView(image: UIImage(resource: .apple), title: "iOS Group Weekly Newsletter", date: "\(Date().getThisWeekDateRange())")
    
    // MARK: - View Load
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayouts()
        setUpTableView()
        setUpActions()
        
        fetchNewsletter()
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
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 1000
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.tableHeaderView = headerView
        tableView.tableHeaderView?.frame.size.height = 170
    }
 
    private func setUpActions() {
        
    }
    
    
    // MARK: - Methods}
    override func headerLoader() {
        fetchNewsletter()
        endHeaderRefreshing()
    }
    func fetchNewsletter() {
        let lastWeek = Date().getThisWeekDateRange()
        let documentId = "\(lastWeek)"
        let reference = firestoreManager.getNewslettersRef(from: currentGroup)
        
        firestoreManager.getDocument(
            asType: NewsLetter.self,
            documentId: documentId,
            reference: reference) { result in
                switch result {
                case .success(let newsletter):
                    self.newsletter = newsletter
                    print(newsletter)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    
                    
                }
                
            }
        
    }
    // MARK: - UITableView DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsletter?.posts.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell else {
            fatalError("Cannot create cell")
        }
        guard let textCell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewTextCell.identifier, for: indexPath) as? HomeTableViewTextCell else {
            fatalError("Cannot create cell")
        }
        guard let imageCell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewImageCell.identifier, for: indexPath) as? HomeTableViewImageCell else {
            fatalError("Cannot create cell")
        }
        let post = newsletter?.posts[indexPath.row]
        let user = User(userId: post!.userId, userName: post!.userName, userIcon: post!.userIcon)
        guard post?.imageBlocks.isEmpty == false else {
            textCell.layoutCell(textBlock: post!.textBlocks[0], user: user)
            return textCell
        }
        guard post?.textBlocks.isEmpty == false else {
            imageCell.layoutCell(imageBlocks: post!.imageBlocks, user: user)
            return imageCell
        }
      
        cell.layoutCell(imageBlocks: post!.imageBlocks, textBlock: post!.textBlocks[0], user: user)
        return cell
        
    }
    
    // MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        false
    }
    
    
    
}

