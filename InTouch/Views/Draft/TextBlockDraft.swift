//
//  TextBlockDraft.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/17.
//

import UIKit

class TextBlockDraft: UIView {
    
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
 
    // MARK: - View Load
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setUpLayouts()
    }
    private func setUpLayouts() {
        addSubview(titleLabel)
        addSubview(textView)
        
        self.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(150)
        }

        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.snp.top).offset(12)
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).offset(-16)
        }
    
        textView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.left.equalTo(self).offset(16)
            make.bottom.equalTo(self)
            make.right.equalTo(self).offset(-16)
        }
        
    }

}
