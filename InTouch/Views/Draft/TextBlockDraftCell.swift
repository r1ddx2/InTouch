//
//  TextBlockDraftCell.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/17.
//

import UIKit

class TextBlockDraftCell: UITableViewCell {
    static let identifier = "TextBlockDraftCell"

    var editTitleHandler: ((String) -> Void)?
    var editContentHandler: ((String) -> Void)?

    // MARK: - Subviews

    let titleTextField: UITextField = {
        let titleTextField = UITextField()
        titleTextField.font = .medium(size: 18)
        titleTextField.textColor = .ITBlack
        titleTextField.placeholder = "Title..."
        return titleTextField
    }()

    let contentTextView: UITextView = {
        let textView = UITextView()
        textView.font = .regular(size: 16)
        textView.textColor = .ITBlack
        textView.text = "Write about your week..."
        return textView
    }()

    // MARK: - View Load

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayouts()
        titleTextField.delegate = self
        contentTextView.delegate = self
    }

    private func setUpLayouts() {
        contentView.addSubview(titleTextField)
        contentView.addSubview(contentTextView)
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(12)
            make.left.equalTo(contentView).offset(16)
            make.right.equalTo(contentView).offset(-16)
        }

        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(8)
            make.left.equalTo(contentView).offset(16)
            make.bottom.equalTo(contentView)
            make.right.equalTo(contentView).offset(-16)
        }
    }

    // MARK: - Methods

    func layoutCell(textBlock: TextBlock) {
        titleTextField.text = textBlock.title
        contentTextView.text = textBlock.content
    }
}

// MARK: - UITextField, UITextView Delegate

extension TextBlockDraftCell: UITextViewDelegate, UITextFieldDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if let text = textView.text {
            editContentHandler?(text)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            editTitleHandler?(text)
        }
    }
}
