//
//  ImageScrollView.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/4.
//

import UIKit

class ImageScrollView: UIScrollView {
    var imageBlocksArray: [ImageBlockView] = []

    // MARK: - View Load

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpScrollView()
    }

    private func setUpScrollView() {
        isScrollEnabled = true
        showsHorizontalScrollIndicator = false
    }

    // MARK: - Methods

    func setUpImageBlocks(imageBlocks array: [ImageBlock]) {
        subviews.forEach { $0.removeFromSuperview() }
        imageBlocksArray.removeAll()

        let count = array.count
        let viewWidth = 325
        var previousView: ImageBlockView?

        for i in 0 ..< count {
            let view = ImageBlockView(image: array[i].image, caption: array[i].caption, place: array[i].place)
            addSubview(view)
            imageBlocksArray.append(view)

            view.snp.makeConstraints { make in
                make.top.equalTo(self)
                make.height.width.equalTo(viewWidth)
            }
            if let previousView = previousView {
                view.snp.makeConstraints { make in
                    make.left.equalTo(previousView.snp.right).offset(16)
                }
            } else {
                view.snp.makeConstraints { make in
                    make.left.equalTo(self.snp.left).offset(21)
                }
            }
            previousView = view
        }

        let totalWidth = CGFloat(count) * CGFloat(viewWidth) + CGFloat(count - 1) * 16 + CGFloat(42)
        contentSize = CGSize(width: totalWidth, height: 50.0)
    }
}
