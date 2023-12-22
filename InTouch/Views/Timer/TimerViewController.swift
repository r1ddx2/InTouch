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
    let daysCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ITYellow
        label.font = .bold(size: 100)
        label.textAlignment = .center
        return label
    }()
    let daysLabel: UILabel = {
        let label = UILabel()
        label.text = "DAYS"
        label.textColor = .ITBlack
        label.font = .medium(size: 28)
        label.textAlignment = .center
        return label
    }()
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
        view.cornerRadius = 100
        return view
    }()
    
    var countdownLabel: CountdownLabel!
    // MARK: - View Load
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let minutes = Date().minutesRemainingUntilNextMonday()
        print(minutes)
        let days = (minutes / 60 / 24).rounded()
        daysCountLabel.text = "\(Int(days))"
        countdownLabel = CountdownLabel(frame: .zero, minutes: minutes)
        setUpTimer()
        countdownLabel.start()
        setUpLayouts()
    }
    private func setUpLayouts() {
      //  view.addSubview(backgroundView)
        view.addSubview(daysCountLabel)
        view.addSubview(daysLabel)
        view.addSubview(countdownLabel)
        view.addSubview(titleLabel)
        daysCountLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(210)
        }
        daysLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(daysCountLabel.snp.bottom).offset(24)
        }
        countdownLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(daysLabel.snp.bottom).offset(16)
            make.height.equalTo(120)
        }
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(countdownLabel.snp.bottom).offset(12)
        }
//        backgroundView.snp.makeConstraints { (make) -> Void in
//            make.height.width.equalTo(200)
//            make.top.equalTo(view.safeAreaLayoutGuide).offset(-90)
//            make.right.equalTo(view).offset(90)
//        }
    }
    private func setUpTimer() {
        countdownLabel.animationType = .Evaporate
        countdownLabel.textColor = .ITYellow
        countdownLabel.font = .bold(size: 68)
    }
    
    // MARK: - Methods
}
