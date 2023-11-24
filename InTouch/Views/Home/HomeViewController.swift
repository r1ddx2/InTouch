//
//  HomeViewController.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/17.
//

import UIKit

class HomeViewController: ITBaseViewController {
    
    // MARK: - Subviews
    let tableView = UITableView()
    let headerView = HomeTableHeaderView(image: UIImage(resource: .apple), title: "iOS Group Weekly Newsletter", date: "2023.11.20 ~ 2023.11.26")
    
    // MARK: - Lifecycle
    
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
        tableView.dataSource = self
        tableView.delegate = self

        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.tableHeaderView = headerView
        tableView.tableHeaderView?.frame.size.height = 170
        
    }
 
    private func setUpActions() {
        
    }
    
    
    // MARK: - Methods}
    
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
    
    
    
}

extension HomeViewController: UITableViewDelegate {
    
}
