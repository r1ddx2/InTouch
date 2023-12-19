//
//  TimerViewControlleer.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/19.
//

import UIKit
import CountdownLabel

class TimerViewController: ITBaseViewController {

    // MARK: - Subviews
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "till next update..."
        label.textColor = .ITBlack
        label.font = .medium(size: 24)
        label.textAlignment = .center
        return label
    }()
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .ITPurple
        view.cornerRadius = 200
        return view
    }()
    
    var countdownLabel: CountdownLabel!
    // MARK: - View Load
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let minutes = Date().minutesRemainingUntilNextMonday()
        countdownLabel = CountdownLabel(frame: .zero, minutes: minutes)
        setUpTimer()
        countdownLabel.start()
        setUpLayouts()
    }
    private func setUpLayouts() {
        view.addSubview(backgroundView)
        view.addSubview(countdownLabel)
        view.addSubview(titleLabel)
        countdownLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(250)
            make.height.equalTo(120)
        }
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(countdownLabel.snp.bottom).offset(12)
        }
        backgroundView.snp.makeConstraints { (make) -> Void in
            make.height.width.equalTo(400)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(120)
            make.left.equalTo(view).offset(-50)
        }
    }
    private func setUpTimer() {
        countdownLabel.animationType = .Evaporate
        countdownLabel.textColor = .ITYellow
        countdownLabel.font = .bold(size: 68)
    }
    
    // MARK: - Methods
}
