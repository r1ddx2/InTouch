//
//  ITBaseTableViewController.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/18.
//
import UIKit

class ITBaseTableViewController: ITBaseViewController,
    UITableViewDataSource,
    UITableViewDelegate
{
    var tableView: UITableView!

    var datas: [[Any]] = [[]] {
        didSet {
            reloadData()
        }
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetUp()
        tableView.beginHeaderRefreshing()
    }

    // MARK: - Private Method

    private func tableViewSetUp() {
        if tableView == nil {
            let tableView = UITableView()
            self.tableView = tableView
        }

        tableView.dataSource = self
        tableView.delegate = self

        tableView.addRefreshHeader(refreshingBlock: { [weak self] in
            self?.headerLoader()
        })
    }

    // MARK: - Public Method

    func reloadData() {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                self?.reloadData()
            }
            return
        }
        tableView.reloadData()
    }

    func headerLoader() {
        tableView.endHeaderRefreshing()
    }

    func footerLoader() {
        tableView.endFooterRefreshing()
    }

    func endHeaderRefreshing() {
        tableView.endHeaderRefreshing()
    }

    func endFooterRefreshing() {
        tableView.endFooterRefreshing()
    }

    func endWithNoMoreData() {
        tableView.endWithNoMoreData()
    }

    func resetNoMoreData() {
        tableView.resetNoMoreData()
    }

    // MARK: - UITableViewDataSource. Subclass should override these method for setting properly.

    func numberOfSections(in _: UITableView) -> Int {
        datas.count
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        datas[section].count
    }

    func tableView(_: UITableView, cellForRowAt _: IndexPath) -> UITableViewCell {
        UITableViewCell(style: .default, reuseIdentifier: String(describing: ITBaseTableViewController.self))
    }
}
