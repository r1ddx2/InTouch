//
//  TextBlockDraft.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/17.
//

import UIKit

class TextBlockDraftCell: UITableViewCell {
    static let identifier = "TextBlockDraftCell"
    
    // MARK: - Subviews
    let titleLabel: UITextField = {
        let titleLabel = UITextField()
        titleLabel.font = .medium(size: 18)
        titleLabel.textColor = .ITBlack
        titleLabel.placeholder = "Title..."
        return titleLabel
    }()
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = .regular(size: 16)
        textView.textColor = .ITBlack
        textView.text = "Write about your week..."
        return textView
    }()
 
    //MARK: - View Load
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayouts()
    }
    private func setUpLayouts() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(textView)
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(12)
            make.left.equalTo(contentView).offset(16)
            make.right.equalTo(contentView).offset(-16)
        }
    
        textView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(contentView).offset(16)
            make.bottom.equalTo(contentView)
            make.right.equalTo(contentView).offset(-16)
        }
        
    }
    // MARK: - Methods
    func layoutCell() {
        
        
    }

}
