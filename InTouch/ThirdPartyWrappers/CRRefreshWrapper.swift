//
//  CRRefreshWrapper.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/18.
//

import CRRefresh
import UIKit

extension UITableView {
    func addRefreshHeader(refreshingBlock: @escaping () -> Void) {
        cr.addHeadRefresh(animator: RamotionAnimator()) {
            refreshingBlock()
        }
    }

    func endHeaderRefreshing() {
        cr.endHeaderRefresh()
    }

    func beginHeaderRefreshing() {
        cr.beginHeaderRefresh()
    }

    func addRefreshFooter(refreshingBlock: @escaping () -> Void) {
        cr.addFootRefresh(animator: RamotionAnimator()) {
            refreshingBlock()
        }
    }

    func endFooterRefreshing() {
        cr.endLoadingMore()
    }

    func endWithNoMoreData() {
        cr.noticeNoMoreData()
    }

    func resetNoMoreData() {
        cr.resetNoMore()
    }

    func removeHeader() {
        cr.removeHeader()
    }

    func removeFooter() {
        cr.removeFooter()
    }
}

extension UICollectionView {
    func addRefreshHeader(refreshingBlock: @escaping () -> Void) {
        cr.addHeadRefresh(animator: RamotionAnimator()) {
            refreshingBlock()
        }
    }

    func endHeaderRefreshing() {
        cr.endHeaderRefresh()
    }

    func beginHeaderRefreshing() {
        cr.beginHeaderRefresh()
    }

    func addRefreshFooter(refreshingBlock: @escaping () -> Void) {
        cr.addFootRefresh(animator: RamotionAnimator()) {
            refreshingBlock()
        }
    }

    func endFooterRefreshing() {
        cr.endLoadingMore()
    }

    func endWithNoMoreData() {
        cr.noticeNoMoreData()
    }

    func resetNoMoreData() {
        cr.resetNoMore()
    }

    func removeHeader() {
        cr.removeHeader()
    }

    func removeFooter() {
        cr.removeFooter()
    }
}
