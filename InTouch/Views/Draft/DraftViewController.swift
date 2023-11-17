//
//  DraftViewController.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/17.
//
import UIKit

class DraftViewController: ITBaseViewController {
    // MARK: - Subviews
    
    let textBlockDraft = TextBlockDraft()
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
    }
    private func setUpLayouts() {
        view.addSubview(textBlockDraft)
        
        textBlockDraft.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view).offset(50)
            make.left.equalTo(view)
            make.right.equalTo(view)
        }
        
    }
    private func setUpActions() {
        
    }
    
    
    // MARK: - Methods
    
    
    
    
    
    
    
}
