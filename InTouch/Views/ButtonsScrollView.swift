//
//  ButtonsScrollView.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/20.
//

import UIKit
import SnapKit

enum ButtonStyle {
    case round
    case tab
}

class ButtonsScrollView: UIScrollView {
    
    var selectedIndex = 0
    let indicatorView = UIView()
    var buttonsArray: [UIButton] = []
    
    var didSwitchTabs: ((Int) -> Void)?
    // MARK: - Constraints
    private var centerXConstraint: ConstraintMakerEditable!
    private var widthConstraint: ConstraintMakerEditable!
    
    // MARK: - Subview
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10  // Adjust as needed
        return stackView
    }()
    
    // MARK: - View Load
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayouts()
        setUpScrollView()
    }
    private func setUpScrollView() {
        self.backgroundColor = .white
        self.isScrollEnabled = true
        self.showsHorizontalScrollIndicator = false
    }
    private func setUpLayouts() {
        self.addSubview(stackView)
        stackView.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(self)
            make.top.equalTo(self).offset(10)
            make.bottom.equalTo(self).offset(-10)
            make.centerY.equalTo(self)
        }
    }
    // MARK: - Methods
    func setUpButtons(buttonsCount count: Int, buttonTitles titles: [String], buttonStyle style: ButtonStyle) {
        let buttonWidth = 100
        stackView.subviews.forEach { $0.removeFromSuperview() }
        buttonsArray.removeAll()
        
        if style == .tab {
            setUpAddGroupButton()
        }
        
        for i in 0..<count {
            let button = UIButton()
            button.setTitle(titles[i], for: .normal)
            button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.minimumScaleFactor = 0.5
            
            buttonsArray.append(button)
            stackView.addArrangedSubview(button)
            
            switch style {
            case .round:
                configureRoundButtons(button: button)
            
            case .tab:
                
                configureTabButtons(button: button)
                setUpIndicator()
                
                button.addTarget(self, action: #selector(switchTab(sender:)), for: .touchUpInside)
                if i == 0 {
                    button.isSelected = true
                }
                
            }
            
        }

    }
    // MARK: - Button Configurations
    private func configureRoundButtons(button: UIButton) {
        button.borderWidth = 0.5
        button.borderColor = .ITDarkGrey
        button.cornerRadius = 15
        button.titleLabel?.font = .regular(size: 14)
        button.setTitleColor(.ITBlack, for: .normal)
        button.setTitleColor(.ITDarkGrey, for: .highlighted)
    }
    private func configureTabButtons(button: UIButton) {
        button.titleLabel?.font = .regular(size: 14)
        button.setTitleColor(.ITLightGrey, for: .normal)
        button.setTitleColor(.ITBlack, for: .selected)
        button.backgroundColor = .clear
        button.setBackgroundImage(nil, for: .selected)
    }
    private func setUpAddGroupButton() {
        let button = UIButton(type: .system)
        button.setImage(UIImage(resource: .iconAdd).withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(addGroup(sender:)), for: .touchUpInside)
        stackView.addArrangedSubview(button)
    }
    
    // MARK: - Button Actions
    @objc func switchTab(sender: UIButton) {
        buttonsArray.forEach {
            $0.isSelected = false
        }
        sender.isSelected = true
        selectedIndex = buttonsArray.firstIndex(of: sender) ?? 0
        updateIndicator(to: sender)
        didSwitchTabs?(selectedIndex)
    }
    @objc func addGroup(sender: UIButton) {
    }
    
    private func setUpIndicator() {
        self.addSubview(indicatorView)
        indicatorView.backgroundColor = .ITDarkGrey
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        let defaultButton = buttonsArray[0]
     
        indicatorView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(1.5)
            make.top.equalTo(stackView.snp.bottom).offset(4)
            self.centerXConstraint = make.centerX.equalTo(defaultButton.snp.centerX)
            self.widthConstraint = make.width.equalTo(defaultButton.snp.width)
        }
    
        
    }
    private func updateIndicator(to button: UIButton) {
        UIView.animate(
            withDuration: 0.6,
            delay: 0.05,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0,
            options: .curveEaseInOut) {
            
            
                self.indicatorView.snp.remakeConstraints { make in
                    make.height.equalTo(1.5)
                    make.top.equalTo(self.stackView.snp.bottom).offset(4)
                    self.centerXConstraint = make.centerX.equalTo(button.snp.centerX)
                    self.widthConstraint = make.width.equalTo(button.snp.width)
                }
        
                self.layoutIfNeeded()
            }
    }
 
}
