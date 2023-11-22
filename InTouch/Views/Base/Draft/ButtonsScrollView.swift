//
//  ButtonsScrollView.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/20.
//

import UIKit

class ButtonsScrollView: UIView {
    var buttonsArray: [UIButton] = []
    
    // MARK: - Subviews
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    // MARK: - View Load
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayouts()
    }
    private func setUpLayouts() {
        addSubview(scrollView)
        
        scrollView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.left.equalTo(self).offset(12)
            make.bottom.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(40)
        }
    }
    // MARK: - Methods
    func setUpButtons(buttonsCount count: Int, buttonTitles titles: [String]) {
        let buttonWidth = 115
        var previousButton: UIButton?
        
        for i in 0..<count {
            let button = UIButton(type: .system)
            button.setTitle(titles[i], for: .normal)
            configureButton(button: button)
            buttonsArray.append(button)
            scrollView.addSubview(button)
         
            button.snp.makeConstraints { (make) -> Void in
                make.centerY.equalTo(scrollView.snp.centerY)
                make.height.equalTo(30)
                make.width.equalTo(buttonWidth)
            }
            if let previousButton = previousButton {
                button.snp.makeConstraints { (make) -> Void in
                    make.left.equalTo(previousButton.snp.right).offset(8)
                }
            } else {
                button.snp.makeConstraints { (make) -> Void in
                    make.left.equalTo(scrollView.snp.left).offset(8)
                }
            }
            previousButton = button
            
        }
        let totalWidth = CGFloat(count) * CGFloat(buttonWidth) + CGFloat(count - 1) * 8 + CGFloat(16)
        scrollView.contentSize = CGSize(width: totalWidth, height: 50.0)
        
    }
    
    private func configureButton(button: UIButton) {
        button.borderWidth = 0.5
        button.borderColor = .ITDarkGrey
        button.cornerRadius = 15
        button.titleLabel?.font = .regular(size: 14)
        button.setTitleColor(.ITBlack, for: .normal)
        button.setTitleColor(.ITDarkGrey, for: .highlighted)
    }
    
    
}
