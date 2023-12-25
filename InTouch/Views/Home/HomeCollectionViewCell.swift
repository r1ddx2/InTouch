//
//  HomeCollectionViewCell.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/4.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    static let identifier = "\(HomeCollectionViewCell.self)"

    var user: User?
    var newsletter: NewsLetter? {
        didSet {
            reloadData()
        }
    }

    // MARK: - Subview

    let tableView = UITableView()

    // MARK: - View Load

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayouts()
        setUpActions()
        setUpTableView()

        tableView.beginHeaderRefreshing()
    }

    private func setUpLayouts() {
        contentView.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
    }

    private func setUpActions() {}

    func reloadData() {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                self?.reloadData()
            }
            return
        }
        tableView.reloadData()
    }

    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        tableView.register(HomeTableViewTextCell.self, forCellReuseIdentifier: HomeTableViewTextCell.identifier)
        tableView.register(HomeTableViewImageCell.self, forCellReuseIdentifier: HomeTableViewImageCell.identifier)
        tableView.register(HomeTableViewImageAudioCell.self, forCellReuseIdentifier: HomeTableViewImageAudioCell.identifier)
        tableView.register(NewsletterHeaderViewCell.self, forCellReuseIdentifier: NewsletterHeaderViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 1000
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.cellLayoutMarginsFollowReadableWidth = false
    }
}

// MARK: - UITableView DataSource

extension HomeCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        guard let newsletter = newsletter else { return 0 }
        return newsletter.posts.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        guard let imageAudioCell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewImageAudioCell.identifier, for: indexPath) as? HomeTableViewImageAudioCell else {
            fatalError("Cannot create image cell")
        }

        guard let newsletter = newsletter else {
            return UITableViewCell()
        }

        guard indexPath.row != 0 else {
            headerCell.layoutCell(
                image: newsletter.newsCover,
                title: newsletter.title,
                date: newsletter.date.getLastWeekDateRange()
            )
            return headerCell
        }

        let post = newsletter.posts[indexPath.row - 1]
        let user = User(userId: post.userId, userName: post.userName, userIcon: post.userIcon)

        if post.imageBlocks.isEmpty == true {
            textCell.layoutCell(textBlock: post.textBlocks, user: user)
            return textCell

        } else if post.textBlocks.isEmpty == true {
            if post.audioBlocks.isEmpty == true {
                imageCell.layoutCell(imageBlocks: post.imageBlocks, user: user)
                return imageCell
            } else {
                imageAudioCell.layoutCell(imageBlocks: post.imageBlocks, audioBlocks: post.audioBlocks, user: user)
                return imageAudioCell
            }

        } else {
            cell.layoutCell(imageBlocks: post.imageBlocks, textBlocks: post.textBlocks, user: user)
            return cell
        }
    }

    // MARK: - UITableView Delegate

    func tableView(_: UITableView, shouldHighlightRowAt _: IndexPath) -> Bool {
        false
    }
}
