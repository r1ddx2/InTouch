//
//  CRRefreshWrapper.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/18.
//

import UIKit
import CRRefresh

extension UITableView {
    func addRefreshHeader(refreshingBlock: @escaping () -> Void) {
        self.cr.addHeadRefresh(animator: RamotionAnimator()) {
            refreshingBlock()
        }
    }
    func endHeaderRefreshing() {
        self.cr.endHeaderRefresh()
    }
    func beginHeaderRefreshing() {
        self.cr.beginHeaderRefresh()
    }
    func addRefreshFooter(refreshingBlock: @escaping () -> Void) {
        self.cr.addFootRefresh(animator: RamotionAnimator()) {
            refreshingBlock()
        }
    }
    func endFooterRefreshing() {
        self.cr.endLoadingMore()
    }
    func endWithNoMoreData() {
        self.cr.noticeNoMoreData()
    }
    func resetNoMoreData() {
        self.cr.resetNoMore()
    }
    func removeHeader() {
        self.cr.removeHeader()
    }
    func removeFooter() {
        self.cr.removeFooter()
    }
}

