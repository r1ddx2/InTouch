//
//  AudioScrollView.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/20.
//

import UIKit

class AudioScrollView: UIScrollView {
    var audioBlocksArray: [AudioBlockView] = []

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

    func setUpAudioBlocks(audioBlocks array: [AudioBlock]) {
        subviews.forEach { $0.removeFromSuperview() }
        audioBlocksArray.removeAll()

        let count = array.count
        let viewWidth = 325
        var previousView: AudioBlockView?

        for i in 0 ..< count {
            let view = AudioBlockView()
            addSubview(view)
            audioBlocksArray.append(view)
            view.downloadAudio(remoteURL: array[i].audioUrl)

            view.snp.makeConstraints { make in
                make.top.equalTo(self)
                make.width.equalTo(viewWidth)
                make.bottom.equalTo(self)
            }
            if let previousView = previousView {
                view.snp.makeConstraints { make in
                    make.left.equalTo(previousView.snp.right).offset(-24)
                }
            } else {
                view.snp.makeConstraints { make in
                    make.left.equalTo(self.snp.left)
                }
            }
            if i == count - 1 {
                view.snp.makeConstraints { make in
                    make.right.equalTo(self.snp.right)
                }
            }

            previousView = view
        }

        let totalWidth = CGFloat(count) * CGFloat(viewWidth) - (CGFloat(count - 1) * 24)
        contentSize = CGSize(width: totalWidth, height: 82)
    }
}
