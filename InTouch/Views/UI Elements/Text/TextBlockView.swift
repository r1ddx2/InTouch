//
//  TextBlockView.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/22.
//

import UIKit

class TextBlockView: UIView {
    // MARK: - Subviews

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .medium(size: 18)
        label.textColor = .ITBlack
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 16)
        label.textColor = .ITBlack
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    // MARK: - View Load

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayouts()
    }

    convenience init(title: String, content: String) {
        self.init()
        setUpLayouts()
        titleLabel.text = title
        contentLabel.text = content
    }

    private func setUpLayouts() {
        addSubview(titleLabel)
        addSubview(contentLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(16)
            make.left.equalTo(self).offset(21)
            make.right.equalTo(self).offset(-21)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(self).offset(21)
            make.bottom.equalTo(self).offset(-21)
            make.right.equalTo(self).offset(-21)
        }
    }
}
