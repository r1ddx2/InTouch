//
//  ActivityViewController.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/17.
//

import UIKit

class ActivityViewController: ITBaseViewController {
    // MARK: - Subviews
    let buttonsView = ButtonsScrollView()
    
    // MARK: - View Load
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpLayouts()
        setUpActions()
        buttonsView.setUpButtons(buttonsCount: 7, buttonTitles: ["Add text block", "Add image block", "Add text block", "Add text block", "Add text block", "Add text block", "Add text block"])
    }
    private func setUpLayouts() {
        view.addSubview(buttonsView)
        buttonsView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view).offset(50)
            make.left.equalTo(view)
            make.right.equalTo(view)
            //make.height.equalTo()
        }
    
    }
    
    
    private func setUpActions() {
        
    }
    
    
    // MARK: - Methods
}
