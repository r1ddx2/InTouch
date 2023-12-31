//
//  AudioBlockDraftCell.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/18.
//

import AVFoundation
import DSWaveformImage
import DSWaveformImageViews
import UIKit

class AudioBlockDraftCell: UITableViewCell {
    static let identifier = "\(AudioBlockDraftCell.self)"

    // MARK: - Subviews

    let audioBlockView = AudioBlockView()

    // MARK: - View Load

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayouts()
    }

    private func setUpLayouts() {
        contentView.addSubview(audioBlockView)
        audioBlockView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
}
