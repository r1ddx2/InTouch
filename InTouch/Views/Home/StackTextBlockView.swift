//
//  StackTextBlockView.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/4.
//

import UIKit

class StackTextBlockView: UIView {
    
    var textBlocksArray: [TextBlockView] = []
    
    // MARK: - View Load
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
   func setUpTextBlocks(textBlocks array: [TextBlock]) {
        textBlocksArray.removeAll()
        
        let count = array.count
        var previousView: TextBlockView?
        
        for i in 0..<count {
            let view = TextBlockView(title: array[i].title, content: array[i].content)
            self.addSubview(view)
            textBlocksArray.append(view)
            
            view.snp.makeConstraints { (make) -> Void in
                make.left.equalTo(self)
                make.right.equalTo(self)
            }
            if let previousView = previousView {
                view.snp.makeConstraints { (make) -> Void in
                    make.top.equalTo(previousView.snp.bottom).offset(12)
                }
            } else {
                view.snp.makeConstraints { (make) -> Void in
                    make.top.equalTo(self)
                }
            }
            previousView = view
            
            if i == count - 1 {
                view.snp.makeConstraints { (make) -> Void in
                    make.bottom.equalTo(self)
                }
            }
            
            if i != 0 {
                let seperatorView = UIView()
                seperatorView.backgroundColor = .ITLightGrey
                self.addSubview(seperatorView)
                seperatorView.snp.makeConstraints { (make) -> Void in
                    make.left.equalTo(self).offset(16)
                    make.right.equalTo(self).offset(-16)
                    make.height.equalTo(0.8)
                    make.top.equalTo(view.snp.top)
                }
            }
        }
        
        
    }
   
}
    
    
