//
//  ITBaseCollectionViewController.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/4.
//
import UIKit

class ITBaseCollectionViewController: ITBaseViewController,
    UICollectionViewDataSource, UICollectionViewDelegate
{
    var collectionView: UICollectionView!

    var datas: [[Any]] = [[]] {
        didSet {
            reloadData()
        }
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewSetUp()
    }

    // MARK: - Private Method

    private func collectionViewSetUp() {
        if collectionView == nil {
            let collectionView = UICollectionView(
                frame: CGRect.zero,
                collectionViewLayout: UICollectionViewLayout()
            )
            self.collectionView = collectionView
        }

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.addRefreshHeader(refreshingBlock: { [weak self] in
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
        collectionView.reloadData()
    }

    func headerLoader() {
        collectionView.endHeaderRefreshing()
    }

    func footerLoader() {
        collectionView.endFooterRefreshing()
    }

    func endHeaderRefreshing() {
        collectionView.endHeaderRefreshing()
    }

    func endFooterRefreshing() {
        collectionView.endFooterRefreshing()
    }

    func endWithNoMoreData() {
        collectionView.endWithNoMoreData()
    }

    func resetNoMoreData() {
        collectionView.resetNoMoreData()
    }

    // MARK: - UICollectionViewDataSource. Subclass should override these method for setting properly.

    func numberOfSections(in _: UICollectionView) -> Int {
        datas.count
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        datas[section].count
    }

    func collectionView(
        _: UICollectionView,
        cellForItemAt _: IndexPath
    ) -> UICollectionViewCell {
        UICollectionViewCell()
    }
}
