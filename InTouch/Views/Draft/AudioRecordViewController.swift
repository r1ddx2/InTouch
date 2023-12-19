//
//  AudioRecordViewController.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/18.
//

import UIKit
import DSWaveformImage
import DSWaveformImageViews
import AVFoundation

class AudioRecordViewController: ITBaseViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    var recordingSession: AVAudioSession!
    var urlHandler: ((String) -> Void)?
    var url: URL?
    var user = KeyChainManager.shared.loggedInUser
    var timer: Timer?
    
    private let cloudManager = CloudStorageManager.shared
    
    // MARK: - Subviews
    let recordButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .iconRecord).withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitleColor(.ITBlack, for: .normal)
        button.titleLabel?.font = .medium(size: 20)
        button.backgroundColor = .ITYellow
        button.cornerRadius = 36
        return button
    }()
    let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.ITBlack, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = .regular(size: 16)
        return button
    }()
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.ITDarkGrey, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = .regular(size: 16)
        return button
    }()
    let audioVisualView = WaveformLiveView()
    // MARK: - View Load
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      
        recordingSession = AVAudioSession.sharedInstance()

        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                    
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
        setUpLayouts()
        setUpActions()
        configureWaveView()
    }
  
    private func setUpLayouts() {
        view.addSubview(recordButton)
        view.addSubview(doneButton)
        view.addSubview(cancelButton)
        view.addSubview(audioVisualView)
        
        audioVisualView.snp.makeConstraints { make in
            make.top.equalTo(view).offset(60)
            make.left.equalTo(view).offset(32)
            make.right.equalTo(view).offset(-32)
            make.height.equalTo(60)
        }
        recordButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(audioVisualView.snp.bottom).offset(35)
            make.width.equalTo(72)
            make.height.equalTo(72)
        }
        doneButton.snp.makeConstraints { make in
            make.centerY.equalTo(recordButton.snp.centerY)
            make.right.equalTo(view).offset(-28)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalTo(recordButton.snp.centerY)
            make.left.equalTo(view).offset(28)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
    }
    private func setUpActions() {
        recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    private func configureWaveView() {
        audioVisualView.backgroundColor = .white
        audioVisualView.configuration = audioVisualView.configuration.with(
            style: .striped(.init(color: .ITYellow, width: 3, spacing: 3))
            )
        audioVisualView.configuration = audioVisualView.configuration.with(
                    damping: audioVisualView.configuration.damping?.with(
                        sides: .both
                    ))
        audioVisualView.configuration = audioVisualView.configuration.with(
            damping: audioVisualView.configuration.damping?.with(percentage: 0.1 )
              )
    }
    // MARK: - Methods
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
         
            audioRecorder.record()
            startTimer()
            url = audioFilename
            recordButton.setImage(UIImage(resource: .iconStop).withRenderingMode(.alwaysOriginal), for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
    func startTimer() {
          timer = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(updateAudioVisualization), userInfo: nil, repeats: true)
      }

      @objc func updateAudioVisualization() {
          guard let audioRecorder = audioRecorder else { return }
          // Perform the audio visualization update every 20 milliseconds
          audioRecorder.updateMeters()
          let currentAmplitude = 1 - pow(10, audioRecorder.averagePower(forChannel: 0) / 20)
          audioVisualView.add(sample: currentAmplitude)
      }

      deinit {
          timer?.invalidate()
      }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil

        if success {
            recordButton.setImage(UIImage(resource: .iconRecord).withRenderingMode(.alwaysOriginal), for: .normal)
            
        } else {
            recordButton.setImage(UIImage(resource: .iconStop).withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    // MARK: - Actions
    @objc func recordButtonTapped() {
        if audioRecorder == nil {
                startRecording()
            } else {
                finishRecording(success: true)
            }
        
    }
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
    @objc func doneButtonTapped() {
        
        guard let url = url , let user = user, let email = user.userEmail else { return }
        
        cloudManager.uploadAudio(
            fileUrl: url,
            userId: email) { result in
                switch result {
                case .success(let url):
                    print(url)
                    self.urlHandler?(url)
                    self.dismiss(animated: true)
                case .failure(let error):
                    print(error)
                }
            }
       
    }
    
    
}
