//
//  AudioBlockDraftCell.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/18.
//

import UIKit
import AVFoundation
import DSWaveformImage
import DSWaveformImageViews

class AudioBlockDraftCell: UITableViewCell {
    
    static let identifier = "\(AudioBlockDraftCell.self)"
    
    var player: AVPlayer?
    var audioUrl: URL?
    var isPlaying = false
    
    // MARK: - Subviews
    let playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.circle"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .ITYellow
        button.cornerRadius = 20
        return button
    }()
    let audioView: UIView = {
        let view = UIView()
        view.backgroundColor = .ITVeryLightPink
        view.cornerRadius = 25
        return view
    }()
    let waveImageView: WaveformImageView = {
        let imageView = WaveformImageView(frame: CGRect(x: 0, y: 0, width: 500, height: 300))
        return imageView
    }()
    let topWaveImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    let bottomWaveImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    //MARK: - View Load
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayouts()
        setUpActions()
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying),
                                                       name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    private func setUpLayouts() {
        audioView.addSubview(playButton)
        audioView.addSubview(waveImageView)
        audioView.addSubview(topWaveImageView)
        audioView.addSubview(bottomWaveImageView)
        contentView.addSubview(audioView)
    
        playButton.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(audioView.snp.centerY)
            make.left.equalTo(audioView.snp.left).offset(8)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        waveImageView.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(audioView.snp.centerY)
            make.left.equalTo(playButton.snp.left).offset(16)
            make.right.equalTo(contentView.snp.right).offset(-16)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        topWaveImageView.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(audioView.snp.centerY)
            make.left.equalTo(playButton.snp.left).offset(16)
            make.right.equalTo(contentView.snp.right).offset(-16)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        bottomWaveImageView.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(audioView.snp.centerY)
            make.left.equalTo(playButton.snp.left).offset(16)
            make.right.equalTo(contentView.snp.right).offset(-16)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        audioView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(24)
            make.left.equalTo(contentView).offset(24)
            make.right.equalTo(contentView).offset(-24)
            make.bottom.equalTo(contentView).offset(-24)
            make.height.equalTo(50)
        }
    }
    private func setUpActions() {
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
    }
    func setUpPlayer(with url: String) {
        guard let audioURL = URL(string: url) else {
            print("Invalid audio URL")
            return
        }
        self.audioUrl = audioURL
        do {
            try setUpAudioWave()
        } catch {
            print("Error setting up audio wave: \(error)")
        }
            
    }
    // MARK: - Methods
    @objc private func playButtonTapped() {
        guard let url = audioUrl else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error setting audio session category: \(error)")
        }
        
        if isPlaying {
            player?.pause()
        } else {
            // Initialize player
            let playerItem = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: playerItem)
            player?.volume = 1.0
            player?.play()
        
        }
        
        isPlaying.toggle()
        updateButtonIcon()
    }
    func setUpAudioWave() throws {
        Task {
            guard let url = audioUrl else { return }
            let waveformImageDrawer = WaveformImageDrawer()
            
            let image = try await waveformImageDrawer.waveformImage(
                fromAudioAt: url,
                with: .init(
                    size: topWaveImageView.bounds.size,
                    style: .gradient([.ITYellow, .ITDarkGrey]),
                    damping: .init(percentage: 0.2,
                                   sides: .right,
                                   easing: { x in pow(x, 4) }),
                    verticalScalingFactor: 2),
                renderer: LinearWaveformRenderer()
            )
            
            DispatchQueue.main.async {
                self.topWaveImageView.image = image
            }
           
            waveImageView.configuration = Waveform.Configuration(
                backgroundColor: .lightGray.withAlphaComponent(0.1),
                style: .striped(.init(color: UIColor(red: 51/255.0, green: 92/255.0, blue: 103/255.0, alpha: 1), width: 5, spacing: 5)),
                verticalScalingFactor: 0.5
            )
            waveImageView.waveformAudioURL = url
            
            Task {
                let image = try! await waveformImageDrawer.waveformImage(fromAudioAt: url, with: bottomWaveformConfiguration, position: .top)
               
                DispatchQueue.main.async {
                    self.bottomWaveImageView.layer.compositingFilter = "overlayBlendMode"
                    self.bottomWaveImageView.image = image
                }
               
            }
            
        }
        
        
    }
    private var bottomWaveformConfiguration: Waveform.Configuration {
        Waveform.Configuration(
            size: bottomWaveImageView.bounds.size,
            style: .filled(.black)
        )
    }
    @objc func playerDidFinishPlaying(_ notification: Notification) {
        isPlaying.toggle()
        updateButtonIcon()
    }
    
    private func updateButtonIcon() {
        if isPlaying {
            playButton.setImage(UIImage(systemName: "pause.circle"), for: .normal)
        } else {
            playButton.setImage(UIImage(systemName: "play.circle"), for: .normal)
        }
    }
  
      deinit {
          NotificationCenter.default.removeObserver(self)
      }
}

