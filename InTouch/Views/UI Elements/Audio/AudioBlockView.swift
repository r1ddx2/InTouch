//
//  AudioBlockView.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/20.
//

import AVFoundation
import DSWaveformImage
import DSWaveformImageViews
import UIKit

class AudioBlockView: UIView {
    private let audioManager = AudioManager.shared

    var player: AVPlayer?
    var audioUrl: URL?
    var isPlaying = false
    var timeObserverToken: Any?

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

    let waveFormImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    // MARK: - View Load

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayouts()
        setUpActions()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        player?.pause()
        if let token = timeObserverToken {
            player?.removeTimeObserver(token)
        }
    }

    private func setUpLayouts() {
        audioView.addSubview(playButton)
        audioView.addSubview(waveFormImageView)
        addSubview(audioView)

        playButton.snp.makeConstraints { make in
            make.centerY.equalTo(audioView.snp.centerY)
            make.left.equalTo(audioView.snp.left).offset(8)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        waveFormImageView.snp.makeConstraints { make in
            make.centerY.equalTo(audioView.snp.centerY)
            make.left.equalTo(playButton.snp.right).offset(12)
            make.right.equalTo(audioView.snp.right).offset(-16)
            make.height.equalTo(25)
        }
        audioView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(16)
            make.left.equalTo(self).offset(24)
            make.right.equalTo(self).offset(-24)
            make.bottom.equalTo(self).offset(-16)
            make.height.equalTo(50)
        }
    }

    private func setUpActions() {
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
    }

    func setupTimeObserver() {
        timeObserverToken = player?.addPeriodicTimeObserver(
            forInterval: CMTimeMake(value: 1, timescale: 30),
            queue: DispatchQueue.main
        ) { [weak self] _ in
            self?.getPlayerProgress()
        }
    }

    // MARK: - Actions

    private func updateButtonIcon() {
        if isPlaying {
            playButton.setImage(UIImage(systemName: "pause.circle"), for: .normal)
        } else {
            playButton.setImage(UIImage(systemName: "play.circle"), for: .normal)
        }
    }

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
            let playerItem = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: playerItem)
            player?.volume = 1.0
            player?.play()
            setupTimeObserver()
        }
        isPlaying.toggle()
        updateButtonIcon()
    }

    @objc func playerDidFinishPlaying(_: Notification) {
        isPlaying.toggle()
        updateButtonIcon()
    }

    // MARK: - AVPlayer Methods

    /// Trigger method
    func downloadAudio(remoteURL: String) {
        audioManager.downloadAudio(remoteURL: remoteURL) { result in
            switch result {
            case let .success(url):
                self.audioUrl = url
                self.updateWaveformImages(with: url)
            case let .failure(error):
                print(error)
            }
        }
    }

    // MARK: - Audio Wave UI

    private func getPlayerProgress() {
        guard let player = player else { return }

        audioManager.getPlayerProgress(player: player) { result in
            switch result {
            case let .success(progress):
                self.waveFormImageView.updateProgressWaveform(progress: progress)
            case let .failure(error):
                print(error)
            }
        }
    }

    private func updateWaveformImages(with url: URL) {
        DSWaveFormImageWrapper.shared.updateWaveFormProgress(
            url: url,
            waveImageView: waveFormImageView
        ) { result in
            switch result {
            case let .success(image):
                DispatchQueue.main.async {
                    self.waveFormImageView.image = image
                    self.getPlayerProgress()
                }
            case let .failure(error):
                print(error)
            }
        }
    }
}
