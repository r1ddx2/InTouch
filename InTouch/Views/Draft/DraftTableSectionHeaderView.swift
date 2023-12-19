//
//  DraftTableSectionHeaderView.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/18.
//

import UIKit

class DraftTableSectionHeaderView: UITableViewHeaderFooterView {
    
    static let identifier = "\(DraftTableSectionHeaderView.self)"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.font = .regular(size: 14)
        label.textColor = .ITBlack
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupLayout() {
        contentView.backgroundColor = .white
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
    }
}
